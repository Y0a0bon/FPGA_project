--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:40:22 03/31/2016
-- Design Name:   
-- Module Name:   H:/project_DCC-IP/simu_SEND_PREAMBLE.vhd
-- Project Name:  project_DCC-IP
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: modu_SEND_PREAMBLE
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
 
ENTITY simu_SEND_PREAMBLE IS
END simu_SEND_PREAMBLE;
 
ARCHITECTURE behavior OF simu_SEND_PREAMBLE IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT modu_SEND_PREAMBLE
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         start_p : IN  std_logic;
         pulse_p : OUT  std_logic;
         end_p : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal start_p : std_logic := '0';

 	--Outputs
   signal pulse_p : std_logic;
   signal end_p : std_logic;

   -- Clock period definitions
   constant clk_period : time := 1000 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: modu_SEND_PREAMBLE PORT MAP (
          clk => clk,
          reset => reset,
          start_p => start_p,
          pulse_p => pulse_p,
          end_p => end_p
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
		start_p<='1';
		wait for 2000 ns;
		start_p<='0';
      wait for clk_period*10;
      wait;
		
   end process;

END;
