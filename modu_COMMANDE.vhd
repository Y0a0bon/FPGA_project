----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:36:53 04/04/2016 
-- Design Name: 
-- Module Name:    modu_COMMANDE - Behavioral 
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
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity modu_COMMANDE is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  A : in STD_LOGIC;
           go : out  STD_LOGIC;
           trame : out  STD_LOGIC_VECTOR(15 downto 0));
end modu_COMMANDE;

architecture Behavioral of modu_COMMANDE is


--	-- SEQUENCEUR --
--	signal 	seq_go	 					: std_logic;
--	signal 	seq_consigne				: std_logic_vector(15 downto 0) := (others => '0');
--	signal 	seq_pulse 					: std_logic;

	-- State defnition
	type state_type is (idle, one, zero, inter);
	signal state, state_next: state_type;
	-- Counter definition
	signal counter							: std_logic_vector(20 downto 0);
	-- start signal
	signal start_go						: std_logic := '0';
	-- Previous A
	signal previous_A						: std_logic := '0';

	
begin

	------------------------------------------
	--      instantiate modu_SEQUENCEUR      --
	------------------------------------------
--	SEND_ONE : entity work.modu_SEQUENCEUR
--	port map(
--		-- send_one signals --
--		clk				=>		clk,
--		reset				=> 	reset,
--		go					=>		seq_go,
--		consigne			=>		seq_consigne,
--		pulse				=>		seq_pulse
--	);

	-- out
	--
	trame <= "0000000101011111";
	
	-- clock --
	clocked: process(clk, reset) is
		begin --process
			if reset = '1' then
				state <= idle;
				go <= '0';
				counter <= (others => '0');
			elsif rising_edge(clk) then
				state <= state_next;
				if A = '1' and previous_A = '0' then
					start_go <= not start_go;
					previous_A <= '1';
				elsif A = '0' then
					previous_A <= '0';
				end if;
				if state = one or state = zero then
					counter <= counter + '1';
				elsif state = inter then
					counter <= (others => '0');
				end if;
				if state = one then
					go <= '1';
				else
					go <= '0';
				end if;
			end if;
	end process clocked;


	-- Machine a etats --
	state_machine: process(state, start_go, counter) is
		begin --process
			state_next <= state;
			case state is
				-- idle
				when idle =>
					if start_go = '1' then
						state_next <= one;
					end if;
				
				-- one					
				when one =>
					if counter = "010011011100001011011" then
						state_next <= zero;
					end if;
					
				-- zero
				when zero =>
					if counter = "100110111000010110110" then
						state_next <= inter;
					end if;
					
				-- inter
				when inter =>
					if start_go = '1' then
						state_next <= one;
					else
						state_next <= idle;
					end if;
				
			end case;
	end process state_machine;

end Behavioral;

