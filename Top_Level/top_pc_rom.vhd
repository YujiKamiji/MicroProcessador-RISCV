library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_pc_rom is
    port(
        clk   : in std_logic;
        reset : in std_logic;
        dado  : out unsigned(18 downto 0) --dado da rom
    );
end top_pc_rom;

architecture pc_rom of top_pc_rom is

    component pc 
        port(
            clk      : in  std_logic;
            reset    : in  std_logic;
            wr_enable: in  std_logic;
            pc_out   : out unsigned(6 downto 0)
        );
    end component;

    component rom
        port(
            clk      : in  std_logic;
            endereco : in  unsigned(6 downto 0);   -- 7 bits para 128 endereços
            dado     : out unsigned(18 downto 0)   -- 19 bits de largura
        );
    end component;

    signal endereco_s : unsigned(6 downto 0); -- conexão PC -> ROM

begin

    -- Instancia o PC
    pc_inst: pc
        port map (
            clk       => clk,
            reset     => reset,
            wr_enable => '1',          -- conta sempre
            pc_out    => endereco_s
        );

    -- Instancia a ROM
    rom_inst: rom
        port map (
            clk      => clk,
            endereco => endereco_s,
            dado     => dado
        );

end architecture;
