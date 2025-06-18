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
        0  => "0100000000000011101",  -- LOADAC 29
        1  => "0110001100000000010",  -- LOADREG R3 (0011), 2
        2  => "0000001100000000010",  -- MOVRAM R3 (Usa o ponteiro em r3 pra jogar o valor do ac na ram)
        3  => "0100000000000000000",  -- LOADAC 0
        4  => "0000001100000000001",  -- LOADRAM R3 (Usa o ponteiro em r3 pra ler o valor da ram e jogar no ac)
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
