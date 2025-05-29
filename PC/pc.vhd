library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
    port (
        clk      : in  std_logic;
        reset    : in  std_logic;
        wr_enable: in  std_logic;
        pc_out   : out unsigned(6 downto 0)
    );
end pc;

architecture arch of pc is
    signal reg_out : unsigned(15 downto 0);
    signal reg_in  : unsigned(15 downto 0);
    signal reg_7   : unsigned(6 downto 0);
    signal soma    : unsigned(6 downto 0);

    component reg_16b
        port (
            clk      : in  std_logic;
            input    : in  unsigned(15 downto 0);
            wr_enable: in  std_logic;
            reset    : in  std_logic;
            output   : out unsigned(15 downto 0)
        );
    end component;

    component somador_pc
        port (
            entrada : in  unsigned(6 downto 0);
            saida   : out unsigned(6 downto 0)
        );
    end component;

begin
    -- Seleciona os 7 bits menos significativos da saída do registrador
    reg_7 <= reg_out(6 downto 0);

    -- Alimenta a entrada do registrador com a saída do somador (expandida para 16 bits)
    reg_in(6 downto 0) <= soma;
    reg_in(15 downto 7) <= (others => '0');

    -- Saída pública
    pc_out <= reg_7;

    -- Instancia o registrador (PC)
    reg_inst: reg_16b
        port map (
            clk       => clk,
            input     => reg_in,
            wr_enable => wr_enable,
            reset     => reset,
            output    => reg_out
        );

    -- Instancia o somador
    somador_inst: somador_pc
        port map (
            entrada => reg_7,
            saida   => soma
        );

end architecture;
