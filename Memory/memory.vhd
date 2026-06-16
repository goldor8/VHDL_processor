library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
    generic(
        WIDTH : integer := 9;
        DEPTH : integer := 256
    );
    port(
        clk : in std_logic;
        rst : in std_logic;
        
        address : in std_logic_vector(WIDTH - 1 downto 0);
        data_out : out std_logic_vector(WIDTH - 1 downto 0)
    );
end memory;

architecture Behavioral of memory is
    type memory_array is array(0 to DEPTH - 1) of std_logic_vector(WIDTH - 1 downto 0);
    signal mem : memory_array := (
        "000000000", -- wait for processor to start
        "001000000", -- store #data in R0
        "000000001", -- set #data to 1
        "001001000", -- store #data in R1
        "000000110", -- set #data to 6
        "011001000", -- subtract R0 from R1 and store result in R1
        others => (others => '0')
    );
begin
    process(clk, rst)
    begin
        if rst = '1' then
            data_out <= (others => '0');
        elsif rising_edge(clk) then
            data_out <= mem(to_integer(unsigned(address)));
        end if;
    end process;
end Behavioral;