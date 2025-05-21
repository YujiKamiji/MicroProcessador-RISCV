library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Mux_2x1 is
    Port (
        ent1,ent2: in unsigned(15 downto 0);
        selector_key: in std_logic;
        result: out unsigned(15 downto 0)
    );
end Mux_2x1;

architecture arch of Mux_2x1 is
begin
    result <= ent1 when selector_key = '0' else
              ent2 when selector_key = '1' else
              "0000000000000000";
end arch;