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
        data_in : in std_logic_vector(WIDTH - 1 downto 0);
        data_out : out std_logic_vector(WIDTH - 1 downto 0);

        write_en : in std_logic_vector(0 downto 0)
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
        "001010000", -- store #data in R2
        std_logic_vector(to_unsigned(128, 9)), -- set #data to 128
        "100010001", -- store [R1] at memory address [R2]
        "101010011", -- load memory address [R2] to R3
        "000100111", -- save R7(PC) to R4 (jump: here)
        "011011000", -- subtract R0 from R3 and store result in R3
        "110111100", -- rollback R7(PC) to [R4] (to goto: here)
        "000001011", -- move [R3] to R1
        others => (others => '0')
    );
begin
    process(clk, rst)
    begin
        if rst = '1' then
            data_out <= (others => '0');
        elsif rising_edge(clk) then
            if write_en = "1" then
                mem(to_integer(unsigned(address))) <= data_in;
            end if;

            data_out <= mem(to_integer(unsigned(address)));
        end if;
    end process;
end Behavioral;