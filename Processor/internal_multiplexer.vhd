library ieee;
use ieee.std_logic_1164.all;

entity internal_multiplexer is
    generic(
        WIDTH : integer := 8
    );
    port(
        DIN_in : in std_logic_vector(WIDTH - 1 downto 0);
        G_in : in std_logic_vector(WIDTH - 1 downto 0);
        R0_in : in std_logic_vector(WIDTH - 1 downto 0);
        R1_in : in std_logic_vector(WIDTH - 1 downto 0);
        R2_in : in std_logic_vector(WIDTH - 1 downto 0);
        R3_in : in std_logic_vector(WIDTH - 1 downto 0);
        R4_in : in std_logic_vector(WIDTH - 1 downto 0);
        R5_in : in std_logic_vector(WIDTH - 1 downto 0);
        R6_in : in std_logic_vector(WIDTH - 1 downto 0);
        R7_in : in std_logic_vector(WIDTH - 1 downto 0);

        DIN_select : in std_logic;
        G_select : in std_logic;
        R_select : in std_logic_vector(2 downto 0);

        mux_out : out std_logic_vector(WIDTH - 1 downto 0)
    );
end internal_multiplexer;

architecture Behavioral of internal_multiplexer is
begin
    process(DIN_select, G_select, R_select, DIN_in, G_in, R0_in,R1_in, R2_in, R3_in, R4_in, R5_in, R6_in, R7_in)
    begin
        if DIN_select = '1' then
            mux_out <= DIN_in;
        elsif G_select = '1' then
            mux_out <= G_in;
        else
            case R_select is
                when "000" => mux_out <= R0_in;
                when "001" => mux_out <= R1_in;
                when "010" => mux_out <= R2_in;
                when "011" => mux_out <= R3_in;
                when "100" => mux_out <= R4_in;
                when "101" => mux_out <= R5_in;
                when "110" => mux_out <= R6_in;
                when "111" => mux_out <= R7_in;
                when others => mux_out <= (others => '0');
            end case;
        end if;
    end process;
end Behavioral;