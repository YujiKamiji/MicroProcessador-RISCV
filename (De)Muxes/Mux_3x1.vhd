library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Mux_3x1 is
    Port (
        ent1,ent2,ent3: in unsigned(15 downto 0);
        selector_key: in unsigned(1 downto 0);
        result: out unsigned(15 downto 0)
    );
end Mux_3x1;

architecture arch of Mux_3x1 is
begin
    result <= ent1 when selector_key = "00" else
              ent2 when selector_key = "01" else
              ent3 when selector_key = "10" else
              "0000000000000000";
end arch;