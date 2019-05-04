----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 05/04/2019 07:52:27 PM
-- Design Name:
-- Module Name: shift4_tb - Behavioral
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

entity shift4_tb is
--  Port ( );
end shift4_tb;

architecture Behavioral of shift4_tb is
    signal RESET, clk, if_press : STD_LOGIC := '0';
    signal press, see_press : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    signal passw : STD_LOGIC_VECTOR (19 downto 0);
    signal result : STD_LOGIC_VECTOR (1 downto 0);
    signal see_reg : std_logic_vector (27 downto 0);
    component shift4
    Port ( RESET, clk : in STD_LOGIC;
           press : in STD_LOGIC_VECTOR (3 downto 0);
           if_press : in STD_LOGIC;
           -- 密码的每一个字符使用4bits来编码，加上#共20bits
           passw : in STD_LOGIC_VECTOR (19 downto 0);
           -- passw_root : in STD_LOGIC_VECTOR (27 downto 0);
           -- 这里使用pass_root只是临时的判断，具体还需要一个7*4位的移位寄存器
           -- 而此处则是通过保存赋值前的最后两个字符，和赋值后的密码组合判断是否root密码
           result : out STD_LOGIC_VECTOR (1 downto 0);
           see_reg : out STD_LOGIC_VECTOR (27 downto 0);
           see_press : out STD_LOGIC_VECTOR (3 downto 0));
   end component;
begin
    type_passw: shift4 port map(
        clk => clk,
        RESET => reset,
        press => press,
        if_press => if_press,
        passw => passw,
        result => result,
        see_reg => see_reg,
        see_press => see_press
    );

    clk_gen: process
    begin
        wait for 7 ns;
        clk <= not clk;
    end process clk_gen;

    signal_input: process
    begin
        wait for 5 ns; RESET <= '1';
        wait for 10 ns; passw <= "01000011100010011111";
        wait for 10 ns; press <= "1001"; if_press <= not if_press;
        wait for 10 ns; press <= "1111"; if_press <= not if_press;
        wait for 10 ns; press <= "0001"; if_press <= not if_press;
        wait for 10 ns; press <= "1101"; if_press <= not if_press;
        wait for 10 ns; press <= "0100"; if_press <= not if_press;
        wait for 10 ns; press <= "0011"; if_press <= not if_press;
        wait for 10 ns; press <= "1000"; if_press <= not if_press;
        wait for 10 ns; press <= "1001"; if_press <= not if_press;
        wait for 10 ns; press <= "1111"; if_press <= not if_press;
        wait for 10 ns; press <= "1101"; if_press <= not if_press;
        wait for 10 ns; press <= "1011"; if_press <= not if_press;
        wait for 10 ns; press <= "1011"; if_press <= not if_press;
        wait for 10 ns; press <= "1000"; if_press <= not if_press;
        wait for 10 ns; press <= "1101"; if_press <= not if_press;
        wait;
    end process;

end Behavioral;
