----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:55:26 03/07/2016 
-- Design Name: 
-- Module Name:    module_CLOCK - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity module_CLOCK is
    Port ( clock_24MHz : in  STD_LOGIC;	--Input clock (24MHz)
           reset : in  STD_LOGIC;			--Input reset
           clock_1MHz : out  STD_LOGIC);	--Output clock (1MHz)
end module_CLOCK;

architecture Behavioral of module_CLOCK is

--Counter & intermediate clock definitions
signal prescaler_counter: STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
signal clk_tmp: STD_LOGIC := '0'; 

begin --process
	
	div_clock: process(clock_24Mhz, reset)
	begin
		if reset='1' then
			prescaler_counter <= (others => '0');
			clk_tmp <= '0';
		elsif rising_edge(clock_24MHz) then
			-- if >10, rising/falling edge (counting 0 and next operation)
			if(prescaler_counter > "1010") then
				 clk_tmp <= not clk_tmp;
				 prescaler_counter <= (others => '0');
			else
				prescaler_counter <= prescaler_counter + 1;
			end if;
		end if;
	end process div_clock;

	clock_1MHz <= clk_tmp;

end Behavioral;

