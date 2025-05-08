library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ULA is
    Port (
        ent1,ent2: in unsigned(15 downto 0);
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

    component Operations_ULA is
        port(
            num1,num2: in unsigned(15 downto 0);
            sum: out unsigned(15 downto 0);
            sub: out unsigned(15 downto 0)
        );
    end component;

    signal soma, subt: unsigned(15 downto 0);
begin

    operations: Operations_ULA
        port map(
            num1 => ent1,
            num2 => ent2,
            sum => soma,
            sub => subt
        );

    mux: Mux_4x1
        port map(
            n1 => soma,
            n2 => subt,
            n3 => '0',
            n4 => '0',
            selector_key => selector,
            result => res
        );
    
end arch;