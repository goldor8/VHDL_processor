library ieee;
use ieee.std_logic_1164.all;

entity internal_addsub_tb is
end internal_addsub_tb;

architecture Behavioral of internal_addsub_tb is
    constant WIDTH : integer := 9;
    signal A_in, B_in : std_logic_vector(WIDTH - 1 downto 0);
    signal addsub : std_logic;
    signal result_out : std_logic_vector(WIDTH - 1 downto 0);
begin
    uut: entity work.internal_addsub
        generic map(WIDTH => WIDTH)
        port map(A_in => A_in, B_in => B_in, addsub => addsub, result_out => result_out);

    stim_proc: process
    begin
        A_in <= "000000001"; -- 1
        B_in <= "000000010"; -- 2
        addsub <= '1'; -- addition
        wait for 10 ns;
        assert result_out = "000000011" report "Addition failed" severity error;

        A_in <= "000000100"; -- 4
        B_in <= "000000011"; -- 3
        addsub <= '0'; -- subtraction
        wait for 10 ns;
        assert result_out = "000000001" report "Subtraction failed" severity error;

        wait;
    end process;
end Behavioral;