library ieee;
use ieee.std_logic_1164.all;

entity internal_fsm is
    generic(
        WIDTH : integer := 8
    );
    port(
        clk : in std_logic;
        rst : in std_logic;
        
        R_select : out std_logic_vector(2 downto 0);
        DIN_select : out std_logic;
        G_select : out std_logic;

        R_en : out std_logic;
        R_address : out std_logic_vector(2 downto 0);
        
        A_en : out std_logic;
        G_en : out std_logic;
        addsub : out std_logic;
        
        IR_en : out std_logic;
        IR : in std_logic_vector(WIDTH - 1 downto 0)
    );
end internal_fsm;

architecture fsm of internal_fsm is
    type state_type is (S0, S1, S2, S3, S4, S5, S6, S7);
    signal state : state_type;
    -- S0 : store the instruction in the IR
    -- S1 : decode the instruction and set the control signals accordingly
    -- S2 : load b_address into addsub, set addsub to correct operation
    -- S3 : load G into R[a_address]
    signal instruction_bits : std_logic_vector(2 downto 0);
    signal address_a_bits : std_logic_vector(2 downto 0);
    signal address_b_bits : std_logic_vector(2 downto 0);
begin
    instruction_bits <= IR(8 downto 6);
    address_a_bits <= IR(5 downto 3);
    address_b_bits <= IR(2 downto 0);
    
    process(clk, rst)
    begin
        if rst = '1' then
            state <= S0;
            R_en <= '0';
            R_address <= "000";
            
            R_select <= "000";
            DIN_select <= '0';
            G_select <= '0';

            A_en <= '0';
            G_en <= '0';
            addsub <= '0';
            IR_en <= '0';
        elsif rising_edge(clk) then
            R_en <= '0';
            R_address <= "000";
            
            R_select <= "000";
            DIN_select <= '0';
            G_select <= '0';

            A_en <= '0';
            G_en <= '0';
            addsub <= '0';
            IR_en <= '1';
            case state is
                when S0 =>
                    IR_en <= '0';
                    state <= S1;
                when S1 =>
                    case instruction_bits is
                        when "000" => -- MOVE
                            R_select <= address_b_bits;
                            R_en <= '1';
                            R_address <= address_a_bits;
                            DIN_select <= '1';
                            state <= S0;
                        when "001" => -- MOVEI, move immediate value to register
                            R_en <= '1';
                            R_address <= address_a_bits;
                            DIN_select <= '1';
                            state <= S0;
                        when "010" or "011" => -- ADD/SUB, load R[address_a] into A, route R[address_b] into addsub, store result in G
                            IR_en <= '0'; -- keep the instruction in the IR for the next cycle
                            R_select <= address_a_bits;
                            A_en <= '1';
                            state <= S2;
                        when others =>
                            state <= S0;
                    end case;
                when S2 =>
                    IR_en <= '0';
                    R_select <= address_b_bits;
                    addsub <= '1' when instruction_bits(0) = '0' else '0';
                    G_en <= '1';
                    state <= S3;
                when S3 =>
                    R_en <= '1';
                    R_address <= address_a_bits;
                    G_select <= '1';
                    state <= S0;
                when others =>
                    state <= S0;
            end case;
        end if;
    end process;
end fsm;

