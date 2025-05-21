library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Mux_9x1 is
    Port (
        selector: in unsigned(3 downto 0);
        x0, x1, x2, x3, x4, x5, x6, x7, x8: in unsigned(15 downto 0);
        result: out unsigned(15 downto 0)
    );
end Mux_9x1;

architecture arch of Mux_9x1 is
begin
    result <= x0 when selector = "0000" else
              x1 when selector = "0001" else
              x2 when selector = "0010" else
              x3 when selector = "0011" else
              x4 when selector = "0100" else
              x5 when selector = "0101" else
              x6 when selector = "0110" else
              x7 when selector = "0111" else
              x8 when selector = "1000" else
              (others => '0');
end arch;