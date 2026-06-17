library ieee;
use ieee.std_logic_1164.all;

entity processor is
    generic(
        WIDTH : integer := 8
    );
    port(
        clk : in std_logic;
        rst : in std_logic;
        DIN : in std_logic_vector(WIDTH - 1 downto 0);
        bus_data : out std_logic_vector(WIDTH - 1 downto 0);

        Address_out : out std_logic_vector(WIDTH - 1 downto 0);
        Data_out : out std_logic_vector(WIDTH - 1 downto 0);
        write_out : out std_logic_vector(0 downto 0);

        run : in std_logic;
        done : out std_logic
    );
end processor;

architecture Behavioral of processor is
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

    component internal_reg_units is
        generic(
            WIDTH : integer := 9
        );
        port(
            clk : in std_logic;
            rst : in std_logic;
            
            en : out std_logic;
            R_address : out std_logic_vector(2 downto 0);
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
    end component;

    component internal_fsm is
        generic(
            WIDTH : integer := 9
        );
        port(
            clk : in std_logic;
            rst : in std_logic;
            
            R_select : out std_logic_vector(2 downto 0);
            DIN_select : out std_logic;
            G_select : out std_logic;

            R_en : out std_logic;
            R_address : out std_logic_vector(2 downto 0);
            R7_count : out std_logic;
            
            A_en : out std_logic;
            G_en : out std_logic;
            G : in std_logic_vector(WIDTH - 1 downto 0);
            addsub : out std_logic;
            
            IR_en : out std_logic;
            IR : in std_logic_vector(WIDTH - 1 downto 0);
            
            Address_en : out std_logic;
            Data_en : out std_logic;
            Write_en : out std_logic;
            Write_in : out std_logic_vector(0 downto 0);

            done : out std_logic
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
    signal A, G, IR, addsub_result : std_logic_vector(WIDTH - 1 downto 0);

    signal R_select : std_logic_vector(2 downto 0);
    signal DIN_select, G_select : std_logic;

    signal R_en : std_logic;
    signal R_address : std_logic_vector(2 downto 0);
    signal R7_count : std_logic;

    signal A_en, G_en, addsub, IR_en : std_logic;

    signal Data_en, Address_en : std_logic;
    signal write_in : std_logic_vector(0 downto 0);
    signal write_en : std_logic;

    signal bus_data_internal : std_logic_vector(WIDTH - 1 downto 0);
begin
    internal_registers : internal_reg_units
        generic map(WIDTH => WIDTH)
        port map(clk => clk, rst => rst,
                 en => R_en,
                 R_address => R_address, R7_count => R7_count,
                 R0_in => bus_data_internal, R1_in => bus_data_internal, R2_in => bus_data_internal, R3_in => bus_data_internal,
                 R4_in => bus_data_internal, R5_in => bus_data_internal, R6_in => bus_data_internal, R7_in => bus_data_internal,
                 R0_out => R0, R1_out => R1, R2_out => R2, R3_out => R3,
                 R4_out => R4, R5_out => R5, R6_out => R6, R7_out => R7);

    A_reg : reg_unit
        generic map(WIDTH => WIDTH)
        port map(clk => clk, rst => rst, d => bus_data_internal, q => A, en => A_en);
    G_reg : reg_unit
        generic map(WIDTH => WIDTH)
        port map(clk => clk, rst => rst, d => addsub_result, q => G, en => G_en);
    addsub_unit : internal_addsub
        generic map(WIDTH => WIDTH)
        port map(A_in => A, B_in => bus_data_internal, addsub => addsub, result_out => addsub_result);
    
    IR_reg : reg_unit
        generic map(WIDTH => WIDTH)
        port map(clk => clk, rst => rst, d => DIN, q => IR, en => IR_en);
    Address_reg : reg_unit
        generic map(WIDTH => WIDTH)
        port map(clk => clk, rst => rst, d => bus_data_internal, q => Address_out, en => Address_en);
    Data_reg : reg_unit
        generic map(WIDTH => WIDTH)
        port map(clk => clk, rst => rst, d => bus_data_internal, q => Data_out, en => Data_en);
    Write_reg : reg_unit
        generic map(WIDTH => 1)
        port map(clk => clk, rst => rst, d => write_in, q => write_out, en => write_en);
    
    mux : internal_multiplexer
        generic map(WIDTH => WIDTH)
        port map(DIN_in => DIN, G_in => G, R0_in => R0, R1_in => R1, R2_in => R2, R3_in => R3, R4_in => R4, R5_in => R5, R6_in => R6, R7_in => R7,
                 DIN_select => DIN_select, G_select => G_select, R_select => R_select,
                 mux_out => bus_data_internal);
    
    fsm : internal_fsm
        generic map(WIDTH => WIDTH)
        port map(clk => clk, rst => rst,
                 R_select => R_select, DIN_select => DIN_select, G_select => G_select,
                 R_en => R_en, R_address => R_address, R7_count => R7_count,
                 A_en => A_en, G_en => G_en, G => G, addsub => addsub,
                 IR_en => IR_en, IR => IR,
                 Address_en => Address_en, Data_en => Data_en, Write_en => write_en, Write_in => write_in,
                 done => done);
    
    bus_data <= bus_data_internal;
end Behavioral;

