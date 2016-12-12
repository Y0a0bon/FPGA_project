----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:15:15 04/11/2016 
-- Design Name: 
-- Module Name:    modu_TOP - Behavioral 
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

entity modu_TOP is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           A : in  STD_LOGIC;
			  B : in STD_LOGIC;
			  led : out STD_LOGIC;
           pulse : out  STD_LOGIC);
end modu_TOP;

architecture Behavioral of modu_TOP is

	-- SEQUENCEUR --
	signal 	go_seq 							: std_logic;
	signal 	consigne_seq					: std_logic_vector(15 downto 0);
	--signal 	pulse_seq						: std_logic;
	
	-- COMMANDE --
	signal 	go_commande 					: std_logic;
	signal 	trame_commande					: std_logic_vector(15 downto 0);
	--signal 	A_commande						: std_logic;
	
	-- CLOCK --
	signal 	clk_1MHz_div 					: std_logic;


begin

	------------------------------------------
	--      instantiate modu_SEND_SEQUENCEUR       --
	------------------------------------------
	modu_SEQUENCEUR : entity work.modu_SEQUENCEUR
	port map(
		-- send_one signals --
		clk				=>		clk_1MHz_div,
		reset				=> 	rst,
		go					=>		go_commande,
		consigne			=>		consigne_seq,
		pulse				=>		pulse
	);


	------------------------------------------
	--      instantiate modu_COMMANDE       --
	------------------------------------------
	modu_COMMANDE : entity work.modu_COMMANDE
	port map(
		-- send_one signals --
		clk				=>		clk,
		reset				=> 	rst,
		go					=>		go_commande,
		A					=>		A,
		trame				=>		trame_commande
	);

	
	------------------------------------------
	--      instantiate module_CLOCK       --
	------------------------------------------
	module_CLOCK : entity work.module_CLOCK
	port map(
		-- clock signals --
		clock_24MHz			=>		clk,
		reset					=> 	rst,
		clock_1MHz			=>		clk_1MHz_div
	);
	
	consigne_seq <= "1111111111111111" when B = '1' else "0000000000000000";
	led <= '1' when B = '1' else '0';
--	-- clock --
--	clocked: process(clk, rst) is
--		begin --process
--			if rst = '1' then
--			elsif rising_edge(clk) then
--			end if;
--	end process clocked;



end Behavioral;

