library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ULA is
    Port (
        clk: in std_logic;
        ent1: in unsigned(15 downto 0);
        selector: in unsigned(1 downto 0);
        res: out unsigned(15 downto 0)
    );
end ULA;

architecture arch of ULA is

    component Mux_4x1 is
        port(
            n1,n2,n3,n4: in unsigned(15 downto 0);
            selector_key: in unsigned(1 downto 0);
            result: out unsigned(15 downto 0)  
        );
    end component;

    signal soma, sub: unsigned(15 downto 0);
    signal ac: unsigned(15 downto 0);
    signal mux_out: unsigned(15 downto 0);
begin
    soma <= ac + ent1;
    sub <= ac - ent1;

    mux: Mux_4x1
        port map(
            n1 => soma,
            n2 => sub,
            n3 => (others => 0),
            n4 => (others => 0),
            selector_key => selector,
            result => mux_out
        );

    process(clk)
    begin
        if rising_edge(clk) then
            ac <= mux_out;
        end if;
    end process;

    res <= ac;
    
end arch;