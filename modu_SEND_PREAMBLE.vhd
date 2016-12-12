----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:25:29 03/14/2016 
-- Design Name: 
-- Module Name:    modu_SEND_PREAMBLE - Behavioral 
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

entity modu_SEND_PREAMBLE is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           start_p : in  STD_LOGIC;
           pulse_p : out  STD_LOGIC;
           end_p : out  STD_LOGIC);
end modu_SEND_PREAMBLE;



architecture Behavioral of modu_SEND_PREAMBLE is

	-- latche: added 0
	signal 	preamble_start_p_one 		: std_logic := '0';
	signal 	send_one_end_p					: std_logic;
	signal 	send_one_pulse_p 				: std_logic;
	signal 	tmp_end_p						: std_logic;	

  -- State defnition --
	type		state_type is (idle, one, count, done);
	signal 	state, state_next				: state_type;
	-- Counter definition --
	signal 	counter							: std_logic_vector(3 downto 0);


begin


	------------------------------------------
	--      instantiate modu_SEND_ONE       --
	------------------------------------------
	SEND_ONE : entity work.modu_SEND_ONE
	port map(
		-- send_one signals --
		clk				=>		clk,
		reset				=> 	reset,
		start_1			=>		preamble_start_p_one,
		end_1				=>		send_one_end_p,
		pulse_1			=>		send_one_pulse_p
	);

	end_p <= '1' when state=done else '0';
	pulse_p <= send_one_pulse_p;
	tmp_end_p <= send_one_end_p;
	
	clocked: process(clk, reset) is
			begin --process
				if reset='1' then
					state <= idle;
					counter <= (others => '0');
				elsif rising_edge(clk) then
					state <= state_next;
					if state = one then
						counter <= counter + '1';
					elsif state = done then
						counter <= (others => '0');
					end if;
				end if;
		end process clocked;
		
		-- Machine a etats & compteur--
		state_machine: process(state, start_p, counter, tmp_end_p) is
			begin --process
				state_next <= state;
				preamble_start_p_one <= '0';
				case state is
					-- idle
					when idle =>
						if start_p = '1' then
							state_next <= one;
						end if;
						
					-- send a logic one
					when one =>
						preamble_start_p_one <= '1';
						state_next <= count;
						
					-- count
					when count =>
						if tmp_end_p = '1' then
							if counter < "1110" then
								state_next <= one;
							else
								state_next <= done;
							end if;
						end if;
						
					-- done
					when done =>
						state_next <= idle;
				end case;
		end process state_machine;

		
end Behavioral;

