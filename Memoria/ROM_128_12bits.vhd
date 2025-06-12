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
        0  => "0110001100000000000",  -- LOADREG R3 (0011), 0
        1  => "0110010000000000000",  -- LOADREG R4 (0100), 0
        2  => "1000001100000000000",  -- MOVAC R3
        3  => "0001010000000000000",  -- ADD R4
        4  => "1100010000000000000",  -- MOVREG R4
        5  => "1000001100000000000",  -- MOVAC R3
        6  => "1001000000000000001",  -- ADDI 1
        7  => "1100001100000000000",  -- MOVREG R3
        8  => "0100000000000011101",  -- LOADAC 29
        9  => "0111001100000000000",  -- CMP R3 e AC (30)
        10 => "1010111110000000000",  -- BHI -8 (offset = 11111000)
        11 => "1000010000000000000",  -- MOVAC R4
        12 => "1100010100000000000",  -- MOVREG R5
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
