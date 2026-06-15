library ieee;
use ieee.std_logic_1164.all;

entity internal_fsm is
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
end internal_fsm;