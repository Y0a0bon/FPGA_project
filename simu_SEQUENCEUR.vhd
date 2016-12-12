--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:08:03 04/04/2016
-- Design Name:   
-- Module Name:   H:/project_DCC-IP/simu_SEQUENCEUR.vhd
-- Project Name:  project_DCC-IP
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: modu_SEQUENCEUR
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY simu_SEQUENCEUR IS
END simu_SEQUENCEUR;
 
ARCHITECTURE behavior OF simu_SEQUENCEUR IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT modu_SEQUENCEUR
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         go : IN  std_logic;
         consigne : IN  std_logic_vector(15 downto 0);
         pulse : OUT std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal go : std_logic := '0';
   signal consigne : std_logic_vector(15 downto 0) := "0101111110000000";

	--Outputs
   signal pulse : std_logic;

   -- Clock period definitions
   constant clk_period : time := 1000 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: modu_SEQUENCEUR PORT MAP (
          clk => clk,
          reset => reset,
          go => go,
          consigne => consigne,
          pulse => pulse
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		reset<='1';
      wait for 2000 ns;	
		reset<='0';
		wait for 2000 ns;
		go<='1';
		wait for 2000 ns;
		go<='0';
      wait for clk_period*10;
      wait;
   end process;

END;
