library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Mux_4x1 is
    Port (
        add,sub,andOP,cmp: in unsigned(15 downto 0);
        selector_key: in unsigned(1 downto 0);
        result: out unsigned(15 downto 0)
    );
end Mux_4x1;

architecture arch of Mux_4x1 is
begin
    result <= add when selector_key = "00" else
              sub when selector_key = "01" else
              andOP when selector_key = "10" else
              cmp when selector_key = "11" else
              "0000000000000000";
end arch;
