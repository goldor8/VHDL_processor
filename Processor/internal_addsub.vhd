library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity internal_addsub is
    generic(
        WIDTH : integer := 8
    );
    port(
        A_in : in std_logic_vector(WIDTH - 1 downto 0);
        B_in : in std_logic_vector(WIDTH - 1 downto 0);
        addsub : in std_logic;
        result_out : out std_logic_vector(WIDTH - 1 downto 0)
    );
end internal_addsub;

architecture Behavioral of internal_addsub is
begin
    process(A_in, B_in, addsub)
    begin
        if addsub = '1' then
            result_out <= std_logic_vector(unsigned(A_in) + unsigned(B_in));
        else
            result_out <= std_logic_vector(unsigned(A_in) - unsigned(B_in));
        end if;
    end process;
end Behavioral;