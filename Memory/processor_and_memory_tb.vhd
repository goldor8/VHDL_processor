library ieee;
use ieee.std_logic_1164.all;

entity processor_and_memory_tb is
end processor_and_memory_tb;

architecture Behavioral of processor_and_memory_tb is
    constant WIDTH : integer := 9;
    constant DEPTH : integer := 256;

    signal mem_clk : std_logic := '0';
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal address : std_logic_vector(WIDTH - 1 downto 0);
    signal data_out : std_logic_vector(WIDTH - 1 downto 0);

    component memory is
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
    end component;
    
    component counter is
        generic(
            WIDTH : integer := 9
        );
        port(
            clk : in std_logic;
            rst : in std_logic;
            count_out : out std_logic_vector(WIDTH - 1 downto 0)
        );
    end component;

    component processor is
        generic(
            WIDTH : integer := 9
        );
        port(
            clk : in std_logic;
            rst : in std_logic;
            DIN : in std_logic_vector(WIDTH - 1 downto 0);
            bus_data : out std_logic_vector(WIDTH - 1 downto 0);
            run : in std_logic;
            done : out std_logic
        );
    end component;
begin
    mem : memory
        generic map(WIDTH => WIDTH, DEPTH => DEPTH)
        port map(clk => mem_clk, rst => rst, address => address, data_out => data_out);

    cnt : counter
        generic map(WIDTH => WIDTH)
        port map(clk => mem_clk, rst => rst, count_out => address);

    proc : processor
        generic map(WIDTH => WIDTH)
        port map(clk => clk, rst => rst, DIN => data_out, bus_data => open, run => '1', done => open);

    clk_process : process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    mem_clk_process : process
    begin
        mem_clk <= '0';
        wait for 5 ns;
        mem_clk <= '1';
        wait for 5 ns;
    end process;
end Behavioral;
