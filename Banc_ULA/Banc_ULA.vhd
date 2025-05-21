library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Banc_ULA is
    Port (
        clk: in std_logic;
        op_code: in unsigned(1 downto 0);          
        reg_selector: in unsigned(3 downto 0);      
        wr_reg_enable: in std_logic;               
        wr_ac_enable: in std_logic;                
        wr_reg_sel: in unsigned(3 downto 0);        
        flag_zero: out std_logic;
        reg_read_out: out unsigned(15 downto 0); 
        ac_value: out unsigned(15 downto 0)                      
    );
end Banc_ULA;

architecture arch of Banc_ULA is

    -- Componentes
    component ULA
        Port (
            clk: in std_logic;
            ent1: in unsigned(15 downto 0);
            ac: in unsigned(15 downto 0);
            op_code: in unsigned(1 downto 0);
            flag_zero: out std_logic;
            res: out unsigned(15 downto 0)
        );
    end component;

    component reg_16b
        Port (
            CLK: in std_logic;
            input: in unsigned(15 downto 0);
            wr_enable: in std_logic;
            output: out unsigned(15 downto 0)
        );
    end component;

    component banc_reg_16b
        Port (
            selector: in unsigned(3 downto 0);
            clk: in std_logic;
            reg_wr: in unsigned(15 downto 0);
            wr_enable: in std_logic;
            reg_out: out unsigned(15 downto 0)
        );
    end component;

    -- Sinais internos
    signal dado_banco   : unsigned(15 downto 0);
    signal dado_ula     : unsigned(15 downto 0);
    signal ac_out       : unsigned(15 downto 0);

begin

    -- Banco de Registradores
    banco: banc_reg_16b
        port map(
            selector   => reg_selector,         -- leitura
            clk        => clk,
            reg_wr     => ac_out,               -- valor vindo do acumulador
            wr_enable  => wr_reg_enable,        -- controla se escreve
            reg_out    => dado_banco            -- valor lido (ent1 da ULA)
        );

    -- ULA
    ula_inst: ULA
        port map(
            clk        => clk,
            ent1       => dado_banco,
            ac         => ac_out,
            op_code    => op_code,
            flag_zero  => flag_zero,
            res        => dado_ula              -- saída da ULA (vai pro acumulador)
        );

    -- Acumulador
    acumulador: reg_16b
        port map(
            CLK        => clk,
            input      => dado_ula,             -- recebe saída da ULA
            wr_enable  => wr_ac_enable,         -- sinal para permitir escrita
            output     => ac_out                -- valor atual do acumulador
        );

    reg_read_out <= dado_banco;
    ac_value     <= ac_out;
        
end arch;