library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_uc_pc_rom is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        dado  : out unsigned(18 downto 0)  -- saida da rom
    );
end entity;

architecture arch of top_uc_pc_rom is

    component pc
        port (
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
        port (
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

    component UC
        port (
            instr           : in  unsigned(18 downto 0);
            reset           : in  std_logic;
            flag_zero_in    : in  std_logic;
            flag_carry_in   : in  std_logic;
            clk             : in  std_logic;
            flag_zero_out   : out std_logic;
            flag_carry_out  : out std_logic;
            jump_en         : out std_logic;
            pc_write        : out std_logic
        );
    end component;

    -- Sinais internos
    signal endereco_s   : unsigned(6 downto 0);
    signal dado_rom_s   : unsigned(18 downto 0);
    signal input_inc_s  : unsigned(6 downto 0);
    signal jump_en_s    : std_logic;
    signal input_jump_s : unsigned(14 downto 0);
    signal pc_write_s   : std_logic;

    -- Flags (sem nada por enquanto)
    signal flag_zero_in  : std_logic := '0';
    signal flag_carry_in : std_logic := '0';
    signal flag_zero_out : std_logic;
    signal flag_carry_out: std_logic;

begin

    -- PC
    pc_inst: pc
        port map (
            clk        => clk,
            reset      => reset,
            wr_enable  => pc_write_s,
            seletor    => jump_en_s,
            input_inc  => input_inc_s,
            input_jump => input_jump_s,
            pc_out     => endereco_s
        );

    -- ROM
    rom_inst: rom
        port map (
            clk      => clk,
            endereco => endereco_s,
            dado     => dado_rom_s
        );

    -- Somador (PC + 1)
    somador_inst: somador_pc
        port map (
            entrada => endereco_s,
            saida   => input_inc_s
        );

    -- UC
    uc_inst: UC
        port map (
            instr           => dado_rom_s,
            reset           => reset,
            clk             => clk,
            flag_zero_in    => flag_zero_in,
            flag_carry_in   => flag_carry_in,
            flag_zero_out   => flag_zero_out,
            flag_carry_out  => flag_carry_out,
            jump_en         => jump_en_s,
            pc_write        => pc_write_s
        );

    -- Extrai endereço de salto da ROM
    input_jump_s <= dado_rom_s(14 downto 0);

    -- Saída externa da ROM
    dado <= dado_rom_s;

end architecture;
