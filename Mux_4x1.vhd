library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Mux_4x1 is
    Port (
        n1,n2,n3,n4: in unsigned(15 downto 0);
        selector_key: in unsigned(1 downto 0);
        result: out unsigned(15 downto 0)
    );
end Mux_4x1;

architecture arch of Mux_4x1 is
begin
    result <= n1 when selector_key = "00" else
              n2 when selector_key = "01" else
              n3 when selector_key = "10" else
              n4 when selector_key = "11" else
              "0000000000000000";
end arch;
