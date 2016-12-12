--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:34:22 03/07/2016
-- Design Name:   
-- Module Name:   H:/project_DCC-IP/simu_CLOCK.vhd
-- Project Name:  project_DCC-IP
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: module_CLOCK
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY simu_CLOCK IS
END simu_CLOCK;
 
ARCHITECTURE behavior OF simu_CLOCK IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT module_CLOCK
    PORT(
         clock_24MHz : IN  std_logic;
         reset : IN  std_logic;
         clock_1MHz : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clock_24MHz : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal clock_1MHz : std_logic;

   -- Clock period definitions
   constant clock_24MHz_period : time := 41.5 ns;
   --constant clock_1MHz_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: module_CLOCK PORT MAP (
          clock_24MHz => clock_24MHz,
          reset => reset,
          clock_1MHz => clock_1MHz
        );

   -- Clock process definitions
   clock_24MHz_process :process
   begin
		clock_24MHz <= '0';
		wait for clock_24MHz_period/2;
		clock_24MHz <= '1';
		wait for clock_24MHz_period/2;
   end process;


   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 80 ns.
      wait for 80 ns;	

      wait for clock_24MHz_period*300;

      wait;
   end process;

END;
