library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Operations_ULA is
    Port (
        num1,num2: in unsigned(15 downto 0);
        sum: out unsigned(15 downto 0);
        sub: out unsigned(15 downto 0)
    );
end Operations_ULA;

architecture arch of Operations_ULA is
begin
    sum <= num1 + num2;
    sub <= num1 - num2;
end arch;