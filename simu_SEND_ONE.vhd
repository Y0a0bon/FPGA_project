--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:46:24 03/07/2016
-- Design Name:   
-- Module Name:   H:/project_DCC-IP/simu_SEND_ONE.vhd
-- Project Name:  project_DCC-IP
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: modu_SEND_ONE
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
 
ENTITY simu_SEND_ONE IS
END simu_SEND_ONE;
 
ARCHITECTURE behavior OF simu_SEND_ONE IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT modu_SEND_ONE
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         start : IN  std_logic;
         output : OUT  std_logic;
         terminated : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal start : std_logic := '0';

 	--Outputs
   signal output : std_logic;
   signal terminated : std_logic;

   -- Clock period definitions
   constant clk_period : time := 1000 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: modu_SEND_ONE PORT MAP (
          clk => clk,
          reset => reset,
          start => start,
          output => output,
          terminated => terminated
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
      -- hold reset state for 100 ns.
		reset<='1';
      wait for 2000 ns;	
		reset<='0';
		wait for 2000 ns;
		start<='1';
		wait for 2000 ns;
		start<='0';
      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
