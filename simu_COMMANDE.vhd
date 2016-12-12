--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:50:22 04/11/2016
-- Design Name:   
-- Module Name:   H:/project_DCC-IP/simu_COMMANDE.vhd
-- Project Name:  project_DCC-IP
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: modu_COMMANDE
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
 
ENTITY simu_COMMANDE IS
END simu_COMMANDE;
 
ARCHITECTURE behavior OF simu_COMMANDE IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT modu_COMMANDE
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         A : IN  std_logic;
         go : OUT  std_logic;
         trame : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal A : std_logic := '0';

 	--Outputs
   signal go : std_logic;
   signal trame : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 42 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: modu_COMMANDE PORT MAP (
          clk => clk,
          reset => reset,
          A => A,
          go => go,
          trame => trame
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
		A<='1';
		wait for 2000 ns;
		A<='0';
      wait for clk_period*10;
      wait;
   end process;

END;
