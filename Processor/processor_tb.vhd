library ieee;
use ieee.std_logic_1164.all;

entity processor_tb is
end processor_tb;

architecture Behavioral of processor_tb is
    constant WIDTH : integer := 9;
    signal clk : std_logic := '0';
    signal rst : std_logic := '1';
    signal DIN : std_logic_vector(WIDTH - 1 downto 0) := (others => '0');
    signal bus_data : std_logic_vector(WIDTH - 1 downto 0);
    signal run : std_logic := '0';

    component processor is
        generic(
            WIDTH : integer := 8
        );
        port(
            clk : in std_logic;
            rst : in std_logic;
            DIN : in std_logic_vector(WIDTH - 1 downto 0);
            bus_data : out std_logic_vector(WIDTH - 1 downto 0);
            run : in std_logic
        );
    end component;

begin
    proc : processor
        generic map(WIDTH => WIDTH)
        port map(clk => clk, rst => rst, DIN => DIN, bus_data => bus_data, run => run);

    clk_process : process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    stim_proc: process
    begin
        rst <= '1';
        wait for 10 ns;
        rst <= '0';
        wait for 10 ns;
        DIN <= "001000000"; --movei to R0
        wait for 10 ns;
        DIN <= "000000001"; -- Load R0 with 1
        wait for 10 ns;
        DIN <= "001000001"; --movei to R1
        wait for 10 ns;
        DIN <= "000000010"; -- Load R1 with 2
        wait for 10 ns;
        DIN <= "010000001"; --add R0 and R1
        wait;
    end process;
end Behavioral;
        
