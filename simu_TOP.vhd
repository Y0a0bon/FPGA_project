--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:07:53 04/11/2016
-- Design Name:   
-- Module Name:   H:/project_DCC-IP/simu_TOP.vhd
-- Project Name:  project_DCC-IP
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: modu_TOP
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
 
ENTITY simu_TOP IS
END simu_TOP;
 
ARCHITECTURE behavior OF simu_TOP IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT modu_TOP
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         A : IN  std_logic;
			B : IN  std_logic;
			
         pulse : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal A : std_logic := '0';
	signal B : std_logic := '0';
	
 	--Outputs
   signal pulse : std_logic;

   -- Clock period definitions
   constant clk_period : time := 42 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: modu_TOP PORT MAP (
          clk => clk,
          rst => rst,
          A => A,
			 B => B,
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
		rst<='1';
      wait for 2000 ns;	
		rst<='0';
		wait for 2000 ns;
		A<='1';
		wait for 2000 ns;
		A<='0';
		B<='1';
		wait for 2000 ns;
		B<='0';
		wait for 2000 ns;
		B<='1';
      wait for clk_period*10;
      wait;
   end process;

END;
