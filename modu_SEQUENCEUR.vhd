----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:39:51 03/14/2016 
-- Design Name: 
-- Module Name:    modu_SEQUENCEUR - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity modu_SEQUENCEUR is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           go : in  STD_LOGIC;
           consigne : in  STD_LOGIC_VECTOR (15 downto 0);
           pulse : out  STD_LOGIC);
end modu_SEQUENCEUR;

architecture Behavioral of modu_SEQUENCEUR is

	-- SEND ONE
	signal 	seq_start_1 					: std_logic;
	signal 	send_one_ended					: std_logic;
	signal 	send_one_pulse					: std_logic;
	-- SEND ZERO
	signal 	seq_start_0	 					: std_logic;
	signal 	send_zero_ended				: std_logic;
	signal 	send_zero_pulse 				: std_logic;
	-- SEND PREAMBLE
	signal 	seq_start_p 					: std_logic;
	signal 	send_preamble_ended			: std_logic;
	signal 	send_preamble_pulse			: std_logic;
	-- SEND OCTET
	signal 	seq_start_b	 					: std_logic;
	signal 	send_byte_ended				: std_logic;
	signal 	send_byte_pulse 				: std_logic;
	signal	seq_input_b						: std_logic_vector(7 downto 0);
	
	
	-- State definition --
	type		state_type is (idle, preamble, processing, waiting, byte_addr, byte_data, byte_ctrl, send_start, start, stop, done);
	signal 	state, state_next				: state_type;
	-- Data definition --
	signal	byte_xor							: std_logic_vector(7 downto 0) := (others => '0');
	-- Counter definition --
	signal	counter							: std_logic_vector(1 downto 0);
	signal	counter_wait					: std_logic_vector(8 downto 0);
	-- End signal --
	signal 	tmp_terminated					: std_logic;
	signal	s_terminated					: std_logic;

	-- Static consigne --
	signal consigne_static					: std_logic_vector(15 downto 0);

	-- Trame selector --
	signal	trame_selector					: std_logic_vector(2 downto 0);
	-- trame idle
	signal 	trame_idle						: std_logic_vector(15 downto 0) := "1111111100000000";
	--trame function
	signal 	trame_function					: std_logic_vector(15 downto 0) := "0000010110000000";
	-- trame addr
	signal 	trame_addr 						: std_logic_vector(15 downto 0) := "0000010101011111";
	
begin

	------------------------------------------
	--      instantiate modu_SEND_ONE       --
	------------------------------------------
	SEND_ONE : entity work.modu_SEND_ONE
	port map(
		-- send_one signals --
		clk				=>		clk,
		reset				=> 	reset,
		start_1			=>		seq_start_1,
		end_1				=>		send_one_ended,
		pulse_1			=>		send_one_pulse
	);
	
	------------------------------------------
	--     instantiate modu_SEND_ZERO       --
	------------------------------------------
	SEND_ZERO : entity work.modu_SEND_ZERO
	port map(
		-- send_zero signals --
		clk				=>		clk,
		reset				=> 	reset,
		start_0			=>		seq_start_0,
		end_0				=>		send_zero_ended,
		pulse_0			=>		send_zero_pulse
	);
	
	------------------------------------------
	--    instantiate modu_SEND_PREAMBLE    --
	------------------------------------------
	SEND_PREAMBLE : entity work.modu_SEND_PREAMBLE
	port map(
		-- send_preamble signals --
		clk				=>		clk,
		reset				=> 	reset,
		start_p			=>		seq_start_p,
		end_p				=>		send_preamble_ended,
		pulse_p			=>		send_preamble_pulse
	);
	
	------------------------------------------
	--     instantiate modu_SEND_OCTET      --
	------------------------------------------
	SEND_OCTET : entity work.modu_SEND_OCTET
	port map(
		-- send_octet signals --
		clk				=>		clk,
		reset				=> 	reset,
		start_b			=>		seq_start_b,
		input_b			=>		seq_input_b,
		end_b				=>		send_byte_ended,
		pulse_b			=>		send_byte_pulse
	);

	-- OUTPUTS
	-- send octet termine
	tmp_terminated <= send_byte_ended or send_preamble_ended;
	-- start/stop termine
	s_terminated <= send_one_ended or send_zero_ended;
	
	-- Pulse en sortie du module
	pulse <= send_byte_pulse or send_preamble_pulse or send_one_pulse or send_zero_pulse;

	trame_function <= "0000010110010000" when consigne = "1111111111111111" else "0000010110000000";
	
	-- clock --
	clocked: process(clk, reset) is
		begin --process
			if reset = '1' then
				byte_xor <= (others => '0');
				counter <= "00";
				counter_wait <= (others => '0');
				trame_selector <= "000";
				consigne_static <= (others => '0');
				state <= idle;
			elsif rising_edge(clk) then
				state <= state_next;
				if state = send_start then
					counter <= counter + '1';
				elsif state = waiting then
					counter_wait <= counter_wait + '1';
				elsif state = preamble then
					if trame_selector = "000" or trame_selector = "011" then
						consigne_static <= trame_idle;
					elsif trame_selector = "001" then
						consigne_static <= trame_addr;
					elsif trame_selector = "010" then
						consigne_static <= trame_function;
					end if;
				elsif state = processing then
					byte_xor <= consigne_static(15 downto 8) xor consigne_static(7 downto 0);
				elsif state = stop then
					trame_selector <= trame_selector + '1';
					byte_xor <= (others => '0');
				elsif state = idle then
					if go='0' then
						trame_selector <= "000";
					end if;
					counter <= (others => '0');
					counter_wait <= (others => '0');
				end if;
			end if;
	end process clocked;

	-- Machine a etats --
	state_machine: process(state, seq_start_b, counter, tmp_terminated, s_terminated, go, consigne_static, byte_xor, counter_wait, trame_selector) is
			begin --process
				state_next <= state;
				seq_start_p <= '0';
				seq_start_0 <= '0';
				seq_input_b <= (others => '0');
				seq_start_b <= '0';
				seq_start_1 <= '0';
				
				case state is
					-- idle
					when idle =>
						if go='1' and trame_selector < "100" then
							state_next <= preamble;
						end if;
						
					-- preamble
					when preamble =>
						seq_start_p <= '1';
						state_next <= processing;

					-- send start
					when send_start =>
						seq_start_0 <= '1';
						state_next <= start;
						
					-- start
					when start =>
						if s_terminated = '1' then
							if counter = "01" then
								state_next <= byte_addr;
							elsif counter = "10" then
								state_next <= byte_data;
							elsif counter = "11" then
								state_next <= byte_ctrl;
							end if;
						end if;

					-- state byte addr
					when byte_addr =>
						seq_input_b <= consigne_static(15 downto 8);
						seq_start_b <= '1';
						state_next <= processing;
						
					-- state byte data
					when byte_data =>
						seq_input_b <= consigne_static(7 downto 0);
						seq_start_b <= '1';
						state_next <= processing;
						
					-- state byte ctrl
					when byte_ctrl =>
						seq_input_b <= byte_xor;
						seq_start_b <= '1';
						state_next <= processing;
						
					-- processing
					when processing =>
						if tmp_terminated = '1' then
							if counter = "11" then
								state_next <= stop;
							else
								state_next <= send_start;
							end if;
						end if;
					
					-- stop
					when stop =>
						seq_start_1 <= '1';
						state_next <= done;
						
					-- done
					when done =>
						if s_terminated = '1' then
							state_next <= waiting;
						end if;
											
					-- waiting
					when waiting =>
						if counter_wait > "110010000" then
							state_next <= idle;
						end if;
				end case;
		end process state_machine;

end Behavioral;


