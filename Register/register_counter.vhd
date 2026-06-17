library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_counter is
    generic(
        WIDTH : integer := 8
    );
    port(
        clk : in std_logic;
        rst : in std_logic;
        q : out std_logic_vector(WIDTH - 1 downto 0);
        d : in std_logic_vector(WIDTH - 1 downto 0);
        en : in std_logic;
        count : in std_logic
    );
end register_counter;

architecture Behavioral of register_counter is
begin
    process(clk, rst)
    begin
        if rst = '1' then
            q <= (others => '0');
        elsif rising_edge(clk) then
            if en = '1' then
                q <= d;
            elsif count = '1' then
                q <= std_logic_vector(unsigned(q) + 1);
            end if;
        end if;
    end process;
end Behavioral;