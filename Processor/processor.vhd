library ieee;
use ieee.std_logic_1164.all;

entity processor is
    generic(
        WIDTH : integer := 8;
    );
    port(
        clk : in std_logic;
        rst : in std_logic;
        DIN : in std_logic_vector(WIDTH - 1 downto 0);
        bus_data : out std_logic_vector(WIDTH - 1 downto 0);
        run : in std_logic
    );
end processor;

architecture Behavioral of processor is
    component register is
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

    component internal_fsm is
        port(
            clk : in std_logic;
            rst : in std_logic;
            
            R_select : out std_logic_vector(2 downto 0);
            DIN_select : out std_logic;
            G_select : out std_logic;

            R0_en : out std_logic;
            R1_en : out std_logic;
            R2_en : out std_logic;
            R3_en : out std_logic;
            R4_en : out std_logic;
            R5_en : out std_logic;
            R6_en : out std_logic;
            R7_en : out std_logic;
            
            A_en : out std_logic;
            G_en : out std_logic;
            addsub : out std_logic;
            
            IR_en : out std_logic;
        );
    end component;

    component internal_multiplexer is
        generic(
            WIDTH : integer := 9
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
    end component;

    component internal_addsub is
        generic(
            WIDTH : integer := 9
        );
        port(
            A_in : in std_logic_vector(WIDTH - 1 downto 0);
            B_in : in std_logic_vector(WIDTH - 1 downto 0);
            addsub : in std_logic;
            result_out : out std_logic_vector(WIDTH - 1 downto 0)
        );
    end component;

    signal R0, R1, R2, R3, R4, R5, R6, R7 : std_logic_vector(WIDTH - 1 downto 0);
    signal A, G, IR : std_logic_vector(WIDTH - 1 downto 0);

    signal R_select : std_logic_vector(2 downto 0);
    signal DIN_select, G_select : std_logic;

    signal R0_en, R1_en, R2_en, R3_en, R4_en, R5_en, R6_en, R7_en : std_logic;
    signal A_en, G_en, addsub, IR_en : std_logic;

    signal bus_data_internal : std_logic_vector(WIDTH - 1 downto 0);
begin
    R0 : register
        generic map(WIDTH => WIDTH)
        port map(clk => clk, rst => rst, d => bus_data_internal, q => R0, en => R0_en);
    R1 : register
        generic map(WIDTH => WIDTH)
        port map(clk => clk, rst => rst, d => bus_data_internal, q => R1, en => R1_en);
    R2 : register
        generic map(WIDTH => WIDTH)
        port map(clk => clk, rst => rst, d => bus_data_internal, q => R2, en => R2_en);
    R3 : register
        generic map(WIDTH => WIDTH)
        port map(clk => clk, rst => rst, d => bus_data_internal, q => R3, en => R3_en);
    R4 : register
        generic map(WIDTH => WIDTH)
        port map(clk => clk, rst => rst, d => bus_data_internal, q => R4, en => R4_en);
    R5 : register
        generic map(WIDTH => WIDTH)
        port map(clk => clk, rst => rst, d => bus_data_internal, q => R5, en => R5_en);
    R6 : register
        generic map(WIDTH => WIDTH)
        port map(clk => clk, rst => rst, d => bus_data_internal, q => R6, en => R6_en);
    R7 : register
        generic map(WIDTH => WIDTH)
        port map(clk => clk, rst => rst, d => bus_data_internal, q => R7, en => R7_en);
    
    A : register
        generic map(WIDTH => WIDTH)
        port map(clk => clk, rst => rst, d => bus_data_internal, q => A, en => A_en);
    G : register
        generic map(WIDTH => WIDTH)
        port map(clk => clk, rst => rst, d => bus_data_internal, q => G, en => G_en);
    addsub_unit : internal_addsub
        generic map(WIDTH => WIDTH)
        port map(A_in => A, B_in => bus_data_internal, addsub => addsub, result_out => G);
    
    IR : register
        generic map(WIDTH => WIDTH)
        port map(clk => clk, rst => rst, d => bus_data_internal, q => IR, en => IR_en);
    
    mux : internal_multiplexer
        generic map(WIDTH => WIDTH)
        port map(DIN_in => DIN, G_in => G, R0_in => R0, R1_in => R1, R2_in => R2, R3_in => R3, R4_in => R4, R5_in => R5, R6_in => R6, R7_in => R7,
                 DIN_select => DIN_select, G_select => G_select, R_select => R_select,
                 mux_out => bus_data_internal);
    
    fsm : internal_fsm
        port map(clk => clk, rst => rst,
                 R_select => R_select, DIN_select => DIN_select, G_select => G_select,
                 R0_en => R0_en, R1_en => R1_en, R2_en => R2_en, R3_en => R3_en, R4_en => R4_en, R5_en => R5_en, R6_en => R6_en, R7_en => R7_en,
                 A_en => A_en, G_en => G_en, addsub => addsub,
                 IR_en => IR_en);
    
    bus_data <= bus_data_internal;
end Behavioral;

