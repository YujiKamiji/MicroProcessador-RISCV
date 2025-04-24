library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Operations_ULA is
    Port (
        n1,n2: in unsigned(15 downto 0);
        sum: out unsigned(15 downto 0)
    );
end Operations_ULA;

architecture arch of Operations_ULA is
begin
    sum <= n1 + n2;
    sub <= n1 - n2;
end arch;