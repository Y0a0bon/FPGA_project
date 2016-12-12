--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:31:29 03/14/2016
-- Design Name:   
-- Module Name:   H:/project_DCC-IP/simu_SEND_OCTET.vhd
-- Project Name:  project_DCC-IP
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: modu_SEND_OCTET
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
 
ENTITY simu_SEND_OCTET IS
END simu_SEND_OCTET;
 
ARCHITECTURE behavior OF simu_SEND_OCTET IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT modu_SEND_OCTET
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         start_b : IN  std_logic;
         input_b : IN  std_logic_vector(7 downto 0);
         pulse_b : OUT  std_logic;
         end_b : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal start_b : std_logic := '0';
   signal input_b : std_logic_vector(7 downto 0) := "01100101";

 	--Outputs
   signal pulse_b : std_logic;
   signal end_b : std_logic;

   -- Clock period definitions
   constant clk_period : time := 1000 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: modu_SEND_OCTET PORT MAP (
          clk => clk,
          reset => reset,
          start_b => start_b,
          input_b => input_b,
          pulse_b => pulse_b,
          end_b => end_b
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
		start_b<='1';
		wait for 2000 ns;
		start_b<='0';
      wait for clk_period*10;
		
		wait;
   end process;

END;
