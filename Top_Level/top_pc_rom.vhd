library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_pc_rom is
    port(
        clk   : in std_logic;
        reset : in std_logic;
        dado  : out unsigned(18 downto 0) -- dado da ROM
    );
end top_pc_rom;

architecture pc_rom of top_pc_rom is

    component pc 
        port(
            clk        : in  std_logic;
            reset      : in  std_logic;
            wr_enable  : in  std_logic;
            seletor    : in  std_logic;
            input_inc  : in  unsigned(6 downto 0);
            input_jump : in  unsigned(14 downto 0);
            pc_out     : out unsigned(6 downto 0)
        );
    end component;

    component rom
        port(
            clk      : in  std_logic;
            endereco : in  unsigned(6 downto 0);
            dado     : out unsigned(18 downto 0)
        );
    end component;

    component somador_pc
        port (
            entrada : in  unsigned(6 downto 0);
            saida   : out unsigned(6 downto 0)
        );
    end component;

    signal endereco_s  : unsigned(6 downto 0);
    signal inc_s       : unsigned(6 downto 0);
    signal dado_s      : unsigned(18 downto 0);
    signal seletor     : std_logic := '1';  --por enquanto so incrementa
    signal input_jump  : unsigned(14 downto 0) := "000000000000010";  --pulo de 2 (mais pra frente vai vir da instrução o quanto tem q pular)

begin

    pc_inst: pc
        port map (
            clk        => clk,
            reset      => reset,
            wr_enable  => '1',
            seletor    => seletor,
            input_inc  => inc_s,
            input_jump => input_jump,
            pc_out     => endereco_s
        );

    somador_inst: somador_pc
        port map (
            entrada => endereco_s,
            saida   => inc_s
        );

    rom_inst: rom
        port map (
            clk      => clk,
            endereco => endereco_s,
            dado     => dado_s
        );

    dado <= dado_s;

end architecture;
