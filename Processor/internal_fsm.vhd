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
end internal_fsm;

architecture fsm of internal_fsm is
    type state_type is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13);
    signal state : state_type;
    signal next_state : state_type;
    -- S0 : send instruction address to memory
    -- S1 : wait for memory to update before S2
    -- S2 : store the instruction in the IR
    -- S3 : decode the instruction and set the control signals accordingly
    -- S4 : load b_address into addsub, set addsub to correct operation
    -- S5 : load G into R[a_address]
    -- S6 : wait for memory to updagte before S7
    -- S7 : store DIN to R[a_address]
    -- S8 : write R[b_address] to Data_out and enable memory write, then wait 1 cycle
    -- S9 : wait 1 cycle, then load memory to R[b_address]
    -- S10 : write DIN to R[b_address]
    -- S11 : disable write
    -- S12 : wait 2 cycles
    -- S13 : wait 1 cycles
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
        elsif rising_edge(clk) then
            state <= next_state;
        end if;
    end process;

    process(state, instruction_bits, address_a_bits, address_b_bits)
    begin
        R_en <= '0';
        R_address <= "000";
        
        R_select <= "000";
        R7_count <= '0';
        DIN_select <= '0';
        G_select <= '0';

        A_en <= '0';
        G_en <= '0';
        addsub <= '0';
        IR_en <= '0';

        Address_en <= '0';
        Data_en <= '0';
        Write_en <= '0';
        Write_in <= "0";

        done <= '0';
        case state is
            when S0 => -- Fetch the instruction from memory
                Address_en <= '1';
                R_select <= "111";
                R7_count <= '1';
                next_state <= S1;
            when S1 =>
                next_state <= S2;
            when S2 => -- store instruction in the IR
                IR_en <= '1';
                next_state <= S3;
            when S3 =>
                case instruction_bits is
                    when "000" => -- MOVE
                        R_select <= address_b_bits;
                        R_en <= '1';
                        R_address <= address_a_bits;
                        next_state <= S0;
                        done <= '1';
                    when "001" => -- MOVEI, move immediate value to register
                        -- fetch data from memory
                        Address_en <= '1';
                        R_select <= "111";
                        R7_count <= '1';
                        next_state <= S6;
                    when "010" => -- ADD/SUB, load R[address_a] into A, route R[address_b] into addsub, store result in G
                        R_select <= address_a_bits;
                        A_en <= '1';
                        next_state <= S4;
                    when "011" =>
                        R_select <= address_a_bits;
                        A_en <= '1';
                        next_state <= S4;
                    when "100" => -- store to memory, store R[address_a] into Address_out, store R[address_b] into Data_out, write to memory
                        R_select <= address_a_bits;
                        Address_en <= '1';
                        next_state <= S8;
                    when "101" => -- load from memory, store R[address_a] into Address_out, wait for memory to update, load DIN to R[address_b]
                        R_select <= address_a_bits;
                        Address_en <= '1';
                        next_state <= S9;
                    when "110" => -- move R[address_b] into R[address_a] if G != 0;
                        if G /= "000000000" then
                            R_select <= address_b_bits;
                            R_en <= '1';
                            R_address <= address_a_bits;
                        end if;
                        next_state <= S0;
                    when others =>
                        next_state <= S0;
                        done <= '1';
                end case;
            when S4 =>
                R_select <= address_b_bits;
                addsub <= '1' when instruction_bits(0) = '0' else '0';
                G_en <= '1';
                next_state <= S5;
            when S5 =>
                R_en <= '1';
                R_address <= address_a_bits;
                G_select <= '1';
                next_state <= S0;
                done <= '1';
            when S6 =>
                next_state <= S7;
            when S7 =>
                R_en <= '1';
                R_address <= address_a_bits;
                DIN_select <= '1';
                done <= '1';
                next_state <= S0;
            when S8 =>
                R_select <= address_b_bits;
                Data_en <= '1';
                Write_in <= "1";
                Write_en <= '1';
                next_state <= S11;
            when S9 =>
                next_state <= S10;
            when S10 =>
                DIN_select <= '1';
                R_address <= address_b_bits;
                R_en <= '1';
                next_state <= S0;
            when S11 =>
                Write_in <= "0";
                Write_en <= '1';
                next_state <= S0;
            when S12 =>
                next_state <= S13;
            when S13 =>
                next_state <= S0;
            when others =>
                next_state <= S0;
                done <= '1';
        end case;
    end process;
end fsm;

