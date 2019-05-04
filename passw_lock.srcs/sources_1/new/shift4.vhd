----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 04/27/2019 09:06:40 PM
-- Design Name:
-- Module Name: shift4 - Behavioral
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

entity shift4 is
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
end shift4;

architecture Behavioral of shift4 is
    signal reg: std_logic_vector (27 downto 0) := "0000000000000000000000000000";
    -- signal temp: std_logic_vector (7 downto 0) := "00000000";
    constant passw_root: std_logic_vector (27 downto 0) := "0001100000000100000010011111";
    -- # 使用 1111编码
begin
    main: process(reset)
    begin
        if RESET = '1' and RESET'event then
            reg(27 downto 0) <= "0000000000000000000000000000";
            -- temp(7 downto 0) <= "00000000";
            result <= "00";
        -- elsif clk = '1' and clk'event then
        --     -- temp(7 downto 4) <= temp(3 downto 0);
        --     -- temp(3 downto 0) <= reg(19 downto 16);
        --
        --     reg(27 downto 4) <= reg(23 downto 0);
        --     reg(3 downto 0) <= press(3 downto 0);
        else
            null;
        end if;
    end process main;

    com: process(press, if_press)
    variable x : std_logic_vector (23 downto 0);
    variable y : std_logic_vector (3 downto 0);
    variable z : std_logic_vector (27 downto 0);
    begin
        -- reg(27 downto 4) <= reg(23 downto 0);
        -- see_press <= press;
        -- reg(3 downto 0) <= press(3 downto 0);
        -- see_reg <= reg;

        x := reg(23 downto 0);
        y := press;
        z := x & y;
        reg <= x & y;
        see_reg <= reg;

        if z(27 downto 0) = passw_root then
            result <= "11";
        elsif z(19 downto 0) = passw then
            result <= "01";
        else
            result <= "00";
        end if;
    end process com;
end Behavioral;
