library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port (
        clk      : in  std_logic;
        endereco : in  unsigned(6 downto 0);   -- 7 bits para 128 endereços
        dado     : out unsigned(18 downto 0)   -- 19 bits de largura
    );
end rom;

architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(18 downto 0);
    constant conteudo_rom : mem := (

        0  => "0110001100000000101", --carrega r3 com valor 5
        1  => "0110010000000001000", --carrega r4 com valor 8
        2  => "1000001100000000000", --move o conteudo de r3 para o ac  
        3  => "0001010000000000000", --soma ac(r3) com r4 e guarda no ac
        4  => "1010010100000000000", --move o conteudo do ac para r5
        5  => "1000010100000000000", --move o conteudo de r5 para o ac (para conseguir subtrair 1)
        6  => "1011000000000000001", --subtrai 1 do ac(r5) e guarda no ac
        7  => "1000001100000000000", --move o conteudo de ac para r5
        8  => "0010001010000000000", --jump o endereco 20
        9  => "0110010100000000000", --carrega r5 com 0 (nao vai ser executada)
        20 => "1000010100000000000", --move o conteudo de r5 para o ac (para conseguir mover o r5 no r3)
        21 => "1010001100000000000", --move do ac(r5) para r3
        22 => "0010000001000000000", --jump para o endereco 2
        23 => "0110001100000000000", --carrega r3 com 0 (nao vai ser executada)

        others => "0000000000000000000"


    );
begin
    process(clk)
    begin
        if rising_edge(clk) then
            dado <= conteudo_rom(to_integer(endereco));
        end if;
    end process;
end architecture;
