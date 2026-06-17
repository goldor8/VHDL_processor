library ieee;
use ieee.std_logic_1164.all;

entity internal_reg_units is
    generic(
        WIDTH : integer := 8
    );
    port(
        clk : in std_logic;
        rst : in std_logic;
        
        en : in std_logic;
        R_address : in std_logic_vector(2 downto 0);
        R7_count : in std_logic;

        R0_in : in std_logic_vector(WIDTH - 1 downto 0);
        R1_in : in std_logic_vector(WIDTH - 1 downto 0);
        R2_in : in std_logic_vector(WIDTH - 1 downto 0);
        R3_in : in std_logic_vector(WIDTH - 1 downto 0);
        R4_in : in std_logic_vector(WIDTH - 1 downto 0);
        R5_in : in std_logic_vector(WIDTH - 1 downto 0);
        R6_in : in std_logic_vector(WIDTH - 1 downto 0);
        R7_in : in std_logic_vector(WIDTH - 1 downto 0);

        R0_out : out std_logic_vector(WIDTH - 1 downto 0);
        R1_out : out std_logic_vector(WIDTH - 1 downto 0);
        R2_out : out std_logic_vector(WIDTH - 1 downto 0);
        R3_out : out std_logic_vector(WIDTH - 1 downto 0);
        R4_out : out std_logic_vector(WIDTH - 1 downto 0);
        R5_out : out std_logic_vector(WIDTH - 1 downto 0);
        R6_out : out std_logic_vector(WIDTH - 1 downto 0);
        R7_out : out std_logic_vector(WIDTH - 1 downto 0)

    );
end internal_reg_units;

architecture Behavioral of internal_reg_units is
    component reg_unit is
        generic(
            WIDTH : integer := 9
        );
        port(
            clk : in std_logic;
            rst : in std_logic;
            d : in std_logic_vector(WIDTH - 1 downto 0);
            q : out std_logic_vector(WIDTH - 1 downto 0);
            en : in std_logic
        );
    end component;

    component register_counter is
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
    end component;


    signal R0_en, R1_en, R2_en, R3_en, R4_en, R5_en, R6_en, R7_en : std_logic;
begin
    R0 : reg_unit
        generic map(WIDTH => WIDTH)
        port map(clk => clk, rst => rst, d => R0_in, q => R0_out, en => R0_en);
    R1 : reg_unit
        generic map(WIDTH => WIDTH)
        port map(clk => clk, rst => rst, d => R1_in, q => R1_out, en => R1_en);
    R2 : reg_unit
        generic map(WIDTH => WIDTH)
        port map(clk => clk, rst => rst, d => R2_in, q => R2_out, en => R2_en);
    R3 : reg_unit
        generic map(WIDTH => WIDTH)
        port map(clk => clk, rst => rst, d => R3_in, q => R3_out, en => R3_en);
    R4 : reg_unit
        generic map(WIDTH => WIDTH)
        port map(clk => clk, rst => rst, d => R4_in, q => R4_out, en => R4_en);
    R5 : reg_unit
        generic map(WIDTH => WIDTH)
        port map(clk => clk, rst => rst, d => R5_in, q => R5_out, en => R5_en);
    R6 : reg_unit
        generic map(WIDTH => WIDTH)
        port map(clk => clk, rst => rst, d => R6_in, q => R6_out, en => R6_en);
    R7 : register_counter
        generic map(WIDTH => WIDTH)
        port map(clk => clk, rst => rst, d => R7_in, q => R7_out, en => R7_en, count => R7_count);

    process(en, R_address)
    begin
        R0_en <= '0';
        R1_en <= '0';
        R2_en <= '0';
        R3_en <= '0';
        R4_en <= '0';
        R5_en <= '0';
        R6_en <= '0';
        R7_en <= '0';

        if en = '1' then
            case R_address is
                when "000" =>
                    R0_en <= '1';
                when "001" =>
                    R1_en <= '1';
                when "010" =>
                    R2_en <= '1';
                when "011" =>
                    R3_en <= '1';
                when "100" =>
                    R4_en <= '1';
                when "101" =>
                    R5_en <= '1';
                when "110" =>
                    R6_en <= '1';
                when "111" =>
                    R7_en <= '1';
                when others =>
                    null;
            end case;
        end if;
    end process;
end Behavioral;