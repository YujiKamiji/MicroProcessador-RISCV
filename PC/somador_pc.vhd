library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--somador externo pro pc
entity somador_pc is
    port (
        entrada : in  unsigned(6 downto 0);
        saida   : out unsigned(6 downto 0)
    );
end somador_pc;

architecture arch of somador_pc is
begin
    saida <= entrada + 1;
end architecture;
