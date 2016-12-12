----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:09:57 03/07/2016 
-- Design Name: 
-- Module Name:    modu_SEND_ONE - Behavioral 
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
-- SEND_OCTET
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity modu_SEND_ZERO is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  start_0 : in STD_LOGIC;
           pulse_0 : out  STD_LOGIC;
			  end_0 : out STD_LOGIC);
end modu_SEND_ZERO;

architecture Behavioral of modu_SEND_ZERO is

	-- State defnition
	type state_type is (idle, zero, inter, one, done);
	signal state, state_next: state_type;
	--Counter definition
	signal counter: std_logic_vector(6 downto 0);

	begin
	
		end_0 <= '1' when state=done else '0';
						

		clocked: process(clk, reset) is
			begin --process
				if reset='1' then
					state <= idle;
					counter <= (others => '0');
				elsif rising_edge(clk) then
					state <= state_next;
					if state = zero or state = one then
						counter <= counter + 1;
					else
						counter <= (others => '0');
					end if;
				end if;
		end process clocked;

		send_zero_process: process(state, counter, start_0) is
			begin --process
				state_next<=state;
				case state is
					--idle
					when idle =>
						pulse_0 <= '0';
						if start_0 = '1' then
							state_next <= zero;
						end if;
					-- envoi de 0
					when zero =>
						pulse_0 <= '0';
						if counter > "1100010" then
							state_next <= inter;
						end if;
					--remise a 0 du compteur
					when inter =>
						pulse_0 <= '1';
						state_next <= one;
					--envoi de 1
					when one =>
						pulse_0 <= '1';
						if counter > "1100001" then
							state_next <= done;
						end if;
					--termine
					when done =>
						state_next <= idle;
						pulse_0 <= '0';
				end case;
		end process send_zero_process;

end Behavioral;

