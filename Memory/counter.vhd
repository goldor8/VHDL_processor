library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
    generic(
        WIDTH : integer := 8
    );
    port(
        clk : in std_logic;
        rst : in std_logic;
        count_out : out std_logic_vector(WIDTH - 1 downto 0)
    );
end counter;

architecture Behavioral of counter is
    signal count : std_logic_vector(WIDTH - 1 downto 0) := (others => '0');
begin
    process(clk, rst)
    begin
        if rst = '1' then
            count <= (others => '0');
        elsif rising_edge(clk) then
            count <= std_logic_vector(unsigned(count) + 1);
        end if;
    end process;

    count_out <= count;
end Behavioral;