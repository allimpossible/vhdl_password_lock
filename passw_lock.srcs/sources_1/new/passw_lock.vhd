----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 04/27/2019 09:06:40 PM
-- Design Name:
-- Module Name: passw_lock - Behavioral
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

entity passw_lock is
    Port (clk, reset : in STD_LOGIC;
          result, result_root : in std_logic_vector(1 downto 0);
          door : out STD_LOGIC);
end passw_lock;

architecture Behavioral of passw_lock is
    type fsm_states is (wait0, wait1, wait2, correct, die, root0, root1, root2);
    signal current_state, next_state: fsm_states := wait0;
    component shift4
        port ( RESET, clk : in STD_LOGIC;
               press : in STD_LOGIC_VECTOR (3 downto 0);
               -- 密码的每一个字符使用4bits来编码，加上#共20bits
               passw : in STD_LOGIC_VECTOR (19 downto 0);
               -- passw_root : in STD_LOGIC_VECTOR (27 downto 0);
               -- 这里使用pass_root只是临时的判断，具体还需要一个7*4位的移位寄存器
               -- 而此处则是通过保存赋值前的最后两个字符，和赋值后的密码组合判断是否root密码
               result : out STD_LOGIC_VECTOR (1 downto 0));
    end component;
begin

    main: process(reset, clk)
        begin
            if reset = '1' and reset'event then
                current_state <= wait0;
            elsif clk = '1' and clk'event then
                current_state <= next_state; --pos-edge trigger
            end if;
    end process main;

    com: process(current_state, result, result_root)
        begin
            case current_state is
                when wait0 => door <= '0';
                    if result = "00" then
                        next_state <= wait1;
                    elsif result = "01" then
                        next_state <= correct;
                    elsif result = "11" then
                        next_state <= root0;
                    else
                        next_state <= wait0;
                    end if;
                when wait1 => door <= '0';
                    if result = "00" then
                        next_state <= wait2;
                    elsif result = "01" then
                        next_state <= correct;
                    elsif result = "11" then
                        next_state <= root0;
                    else
                        next_state <= wait1;
                    end if;
                when wait2 => door <= '0';
                    if result = "00" then
                        next_state <= die;
                    elsif result = "01" then
                        next_state <= correct;
                    elsif result = "11" then
                        next_state <= root0;
                    else
                        next_state <= wait2;
                    end if;
                when correct => door <= '1';
                    -- wait for 30 sec;
                    -- 由于vhdl不能在有敏感信号的process中延时，
                    -- 所以延时须另想办法
                    next_state <= wait0;
                when die => door <= '0';
                    -- wait for 30 min;
                    next_state <= wait0;
                when root0 => door <= '0';
                    if result_root = "01" then
                        next_state <= root1;
                    elsif result_root = "11" then
                        next_state <= wait0;
                    else
                        next_state <= root0;
                    end if;
                when root1 => door <= '0';
                    if result_root = "10" then
                        next_state <= wait0;
                        -- 这里还要添加更新密码的步骤
                    elsif result_root = "11" then
                        next_state <= wait0;
                        -- 这里不需要更新密码
                    elsif result_root = "00" then
                        next_state <= root0;
                    else
                        next_state <= root1;
                    end if;
                when others => door <= '0';
                    next_state <= wait0;
            end case;
        end process com;
end Behavioral;
