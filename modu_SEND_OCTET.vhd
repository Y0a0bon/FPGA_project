----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:47:43 03/14/2016 
-- Design Name: 
-- Module Name:    modu_SEND_OCTET - Behavioral 
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

entity modu_SEND_OCTET is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           start_b : in  STD_LOGIC;
           input_b : in  STD_LOGIC_VECTOR (7 downto 0);
           pulse_b : out  STD_LOGIC;
           end_b : out  STD_LOGIC);
end modu_SEND_OCTET;

architecture Behavioral of modu_SEND_OCTET is
	-- SEND ONE
	signal 	byte_start_1 					: std_logic;
	signal 	send_one_ended					: std_logic;
	signal 	send_one_pulse					: std_logic;
	-- SEND ZERO
	signal 	byte_start_0	 				: std_logic;
	signal 	send_zero_ended				: std_logic;
	signal 	send_zero_pulse 				: std_logic;

	-- State defnition --
	type		state_type is (idle, send, count, done);
	signal 	state, state_next				: state_type;
	-- Data definition --
	signal	byte								: std_logic_vector(7 downto 0) := (others => '0');
	-- Counter definition --
	signal 	counter							: std_logic_vector(3 downto 0);
	--
	signal 	tmp_terminated					: std_logic;


begin

	------------------------------------------
	--      instantiate modu_SEND_ONE       --
	------------------------------------------
	SEND_ONE : entity work.modu_SEND_ONE
	port map(
		-- send_one signals --
		clk				=>		clk,
		reset				=> 	reset,
		start_1			=>		byte_start_1,
		end_1				=>		send_one_ended,
		pulse_1			=>		send_one_pulse
	);
	
	------------------------------------------
	--      instantiate modu_SEND_ZERO       --
	------------------------------------------
	SEND_ZERO : entity work.modu_SEND_ZERO
	port map(
		-- send_zero signals --
		clk				=>		clk,
		reset				=> 	reset,
		start_0			=>		byte_start_0,
		end_0				=>		send_zero_ended,
		pulse_0			=>		send_zero_pulse
	);

	-- send d'un bit termine
	tmp_terminated <= send_one_ended or send_zero_ended;
	
	-- Pulse en sortie du module
	pulse_b <= send_one_pulse or send_zero_pulse;

	-- send termine
	end_b <= '1' when state = done else '0';


	-- clock --
	clocked: process(clk, reset) is
		begin --process
			if reset = '1' then
				byte <= "00000000";
				state <= idle;
				counter <= (others => '0');
			elsif rising_edge(clk) then
				state <= state_next;
				if state = send then
					-- on decale le registre
					byte <= byte(6 downto 0)&'0';
					counter <= counter + '1';
				elsif state = done then
					counter <= (others => '0');
				elsif state = idle then
					byte(7 downto 0)<= input_b(7 downto 0);
				else
					byte <= byte;
				end if;
			end if;
	end process clocked;

	-- Machine a etats --
	state_machine: process(state, start_b, counter, tmp_terminated, byte) is
			begin --process
				state_next <= state;
				byte_start_0 <= '0';
				byte_start_1 <= '0';				
				case state is
					-- idle
					when idle =>
						byte_start_0 <= '0';
						byte_start_1 <= '0';
						if start_b='1' then
							state_next <= send;
						end if;
						
					-- send one or zero
					when send =>
						if byte(7) = '0' then
							byte_start_0 <= '1';
						else
							byte_start_1 <= '1';
						end if;
						state_next <= count;

					-- count
					when count =>
						if tmp_terminated = '1' then
							-- si on lu 8 bits, on termine
							if counter = "1000" then
								state_next <= done;
							else
								state_next <= send;
							end if;
						end if;

					-- done
					when done =>
						state_next <= idle;
				end case;
		end process state_machine;

end Behavioral;

