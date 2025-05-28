library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port (
        clk      : in  std_logic;
        endereco : in  unsigned(6 downto 0);   -- 7 bits para 128 endereços
        dado     : out unsigned(18 downto 0)   -- 19 bits de largura
    );
end entity;

architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(18 downto 0);
    constant conteudo_rom : mem := (
        -- Exemplo de instruções codificadas em 19 bits (ajuste conforme seu formato)
        0  => "0000000000000000001",  -- NOP fictício
        1  => "1000000000000000000",  -- JUMP fictício
        2  => "0000000000000000000",
        3  => "0000000000000000000",
        4  => "1000000000000000000",
        5  => "0000000000000000010",
        6  => "1111000000000000011",
        7  => "0000000000000000010",
        8  => "0000000000000000010",
        9  => "0000000000000000000",
        10 => "0000000000000000000",
        -- Restante zerado
        others => (others => '0')
    );
begin
    process(clk)
    begin
        if rising_edge(clk) then
            dado <= conteudo_rom(to_integer(endereco));
        end if;
    end process;
end architecture;
