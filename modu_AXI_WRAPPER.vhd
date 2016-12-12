----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:07:36 04/11/2016 
-- Design Name: 
-- Module Name:    modu_AXI_WRAPPER - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity modu_AXI_WRAPPER is
    Port ( 
			  clk : in  STD_LOGIC;
			  rst : in STD_LOGIC;
			  Consigne_IN : in  STD_LOGIC_VECTOR (15 downto 0);
           Go_IN : in  STD_LOGIC;
           Consigne_OUT : out  STD_LOGIC_VECTOR (15 downto 0);
           Go_OUT : out  STD_LOGIC);
end modu_AXI_WRAPPER;

architecture Behavioral of modu_AXI_WRAPPER is

begin


end Behavioral;

