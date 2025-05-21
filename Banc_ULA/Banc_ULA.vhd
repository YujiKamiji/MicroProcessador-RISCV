library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Banc_ULA is
    Port (
        clk: in std_logic;
        op_code: in unsigned(1 downto 0);          
        reg_selector: in unsigned(3 downto 0); 
        load_control_banco: in std_logic;
        load_control_ac: in unsigned(1 downto 0);
        cmpi_control: in std_logic;
        load_value: in unsigned(15 downto 0);     
        wr_reg_enable: in std_logic;
        reset: in std_logic;                                     
        flag_zero: out std_logic;
        flag_carry: out std_logic;
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
            flag_carry_in: in std_logic;
            flag_carry_out: out std_logic;
            flag_zero_out: out std_logic;
            res: out unsigned(15 downto 0)
        );
    end component;

    component reg_16b
        Port (
            clk: in std_logic;
            input: in unsigned(15 downto 0);
            wr_enable: in std_logic;
            reset: in std_logic;
            output: out unsigned(15 downto 0)
        );
    end component;

    component banc_reg_16b
        Port (
            selector: in unsigned(3 downto 0);
            clk: in std_logic;
            reg_wr: in unsigned(15 downto 0);
            wr_enable: in std_logic;
            reset: in std_logic;
            reg_out: out unsigned(15 downto 0)
        );
    end component;

    component Mux_2x1
        Port (
            ent1,ent2: in unsigned(15 downto 0);
            selector_key: in std_logic;
            result: out unsigned(15 downto 0)
        );
    
    component Mux_3x1
        Port (
            ent1,ent2, ent3: in unsigned(15 downto 0);
            selector_key: in unsigned(1 downto 0);
            result: out unsigned(15 downto 0)
        );

    -- Sinais internos
    signal out_banco   : unsigned(15 downto 0);
    signal dado_ula     : unsigned(15 downto 0);
    signal ac_out       : unsigned(15 downto 0);
    signal in_banco, in_ac, in_ula: unsigned(15 downto 0);

begin
    -- mux que entra no banco
    mux_banco: Mux_2x1
        port map(
            ent1 => ac_out,
            ent2 => load_value,
            selector_key => load_control_banco,
            result => in_banco
        );
    -- mux que entra no ac
    mux_ac: Mux_3x1
        port map(
            ent1 => dado_ula,
            ent2 => load_value,
            ent3 => out_banco,
            selector_key => load_control_ac,
            result => in_ac
        );

    mux_ula: Mux_2x1
        port map(
            ent1 => out_banco,
            ent2 => load_value,
            selector_key => cmpi_control,
            result => in_ula
        );

    -- Banco de Registradores
    banco: banc_reg_16b
        port map(
            selector   => reg_selector,         -- leitura
            clk        => clk,
            reg_wr     => in_banco,               -- valor vindo do acumulador
            wr_enable  => wr_reg_enable,        
            reset => reset,
            reg_out    => out_banco            
        );

    -- ULA
    ula_inst: ULA
        port map(
            clk        => clk,
            ent1       => in_ula,
            ac         => ac_out,
            op_code    => op_code,
            flag_carry_in => '0',
            flag_carry_out => flag_carry,
            flag_zero_out  => flag_zero,
            res        => dado_ula              -- saída da ULA (vai pro acumulador)
        );

    -- Acumulador
    acumulador: reg_16b
        port map(
            CLK        => clk,
            input      => in_ac,            
            wr_enable  => '1',    
            reset => reset,    
            output     => ac_out               
        );

    reg_read_out <= out_banco;
    ac_value     <= ac_out;
        
end arch;