----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 04/28/2019 05:04:57 PM
-- Design Name:
-- Module Name: passw_lock_tb - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
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
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity passw_lock_tb is
--  Port ( );
end passw_lock_tb;

architecture Behavioral of passw_lock_tb is
    signal clk: STD_LOGIC := '0';
    signal reset: STD_LOGIC := '0';
    signal result : std_logic_vector(1 downto 0) := "00";
    signal result_root : std_logic_vector(1 downto 0) := "00";
    signal door : STD_LOGIC := '0';
    component passw_lock
        Port (clk : in STD_LOGIC;
              reset : in STD_LOGIC;
              result : in std_logic_vector(1 downto 0);
              result_root : in std_logic_vector(1 downto 0);
              door : out STD_LOGIC);
    end component;
begin
    test: passw_lock port map(
        clk => clk,
        reset => reset,
        result => result,
        result_root => result_root,
        door => door
    );

    clk_gen: process
    begin
        wait for 7 ns;
        clk <= not clk;
    end process clk_gen;

    signal_input: process
    begin
        wait for 5 ns; reset <= '1';
        wait for 10 ns; result <= "01";
        wait for 15 ns; result <= "00";
        wait for 15 ns; result <= "00";
        wait for 15 ns; result <= "00";
        wait for 15 ns; result <= "11";
        wait for 15 ns; result_root <= "01";
        wait for 15 ns; result_root <= "00";
        wait for 15 ns; result_root <= "01";
        wait for 15 ns; result_root <= "10";
        wait for 5 ns; reset <= '1';
        wait for 10 ns; result <= "01";
        wait for 15 ns; result <= "00";
        wait for 15 ns; result <= "00";
        wait for 15 ns; result <= "00";
        wait for 15 ns; result <= "11";
        wait for 15 ns; result_root <= "01";
        wait for 15 ns; result_root <= "00";
        wait for 15 ns; result_root <= "01";
        wait;
    end process signal_input;

end Behavioral;
