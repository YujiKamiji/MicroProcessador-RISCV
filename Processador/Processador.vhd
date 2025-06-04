library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Processador is
    Port (
        clk: in std_logic;
        reset: in std_logic;
    );
end Processador;

architecture arch of Processador is

    component Banc_ULA 
        Port (
            clk: in std_logic;
            op_code: in unsigned(1 downto 0);          
            reg_selector: in unsigned(3 downto 0); 
            load_control_banco: in std_logic;
            load_control_ac: in unsigned(1 downto 0);
            cmpi_control: in std_logic;
            load_value: in unsigned(15 downto 0);     
            wr_reg_enable: in std_logic;
            wr_ac_enable: in std_logic;
            reset: in std_logic;        
            flag_carry_in_sub: in std_logic;
            flag_carry_in_add: in std_logic;                             
            flag_zero: out std_logic;
            flag_carry_out_add: out std_logic;
            flag_carry_out_sub: out std_logic;
            ac_value: out unsigned(15 downto 0)                      
        );
    end component;

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
        Port (
        instr: in unsigned(18 downto 0);
        reset: in std_logic;
        --flags in
        flag_zero_in: in std_logic;
        flag_carry_in_sub: in std_logic;
        flag_carry_in_add: in std_logic;
        clk: in std_logic;
        --flags out
        flag_zero_out: out std_logic;
        flag_carry_out_sub: out std_logic;
        flag_carry_out_add: out std_logic;
        --sinais de saida
        jump_en: out std_logic;
        pc_write : out std_logic;
        load_control_ac: out unsigned(1 downto 0);
        load_control_banco: std_logic;
        cmpi_control: std_logic;
        wr_ac_enable: std_logic;
        wr_reg_enable: std_logic;
    );
    end component;

    -- Sinais internos
    signal endereco_s   : unsigned(6 downto 0);
    signal dado_rom_s   : unsigned(18 downto 0);
    signal input_inc_s  : unsigned(6 downto 0);
    signal jump_en_s    : std_logic;
    signal input_jump_s : unsigned(14 downto 0);
    signal pc_write_s   : std_logic;
    signal opcode_ula: unsigned(1 downto 0);
    signal reg_selector_s: unsigned(3 downto 0);
    signal load_control_ac_s: unsigned(1 downto 0);
    signal load_control_banco_s: std_logic;
    signal cmpi_control_s: std_logic;
    signal load_value_s: unsigned(15 downto 0);
    signal wr_ac_enable_s: std_logic;
    signal wr_reg_enable_s: std_logic;
    signal ac_value_s: unsigned(15 downto 0);
    signal instr_out_s: unsigned(2 downto 0);

    -- Flags (sem nada por enquanto)
    signal flag_zero_in_s  : std_logic := '0';
    signal flag_carry_in_sub_s : std_logic := '0';
    signal flag_carry_in_add_s : std_logic := '0';
    signal flag_zero_out_s : std_logic;
    signal flag_carry_out_sub_s: std_logic;
    signal flag_carry_out_add_s: std_logic;

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
            flag_zero_in    => flag_zero_in_s,
            flag_carry_in_sub   => flag_carry_in_sub_s,
            flag_carry_in_add   => flag_carry_in_add_s,
            flag_zero_out   => flag_zero_out_s,
            flag_carry_out_sub  => flag_carry_out_sub_s,
            flag_carry_out_add  => flag_carry_out_add_s,
            jump_en         => jump_en_s,
            pc_write        => pc_write_s,
            load_control_ac => load_control_ac_s,
            load_control_banco => load_control_banco_s,
            cmpi_control => cmpi_control_s,
            wr_ac_enable => wr_ac_enable_s,
            wr_reg_enable => wr_reg_enable_s,
            instr_out => instr_out_s
        );

   banco_ula: Banc_ULA 
        port map (
            clk => clk,
            op_code => opcode_ula,           
            reg_selector => reg_selector_s, 
            load_control_banco => load_control_banco_s,
            load_control_ac => load_control_ac_s,
            cmpi_control => cmpi_control_s,
            load_value => load_value_s,
            wr_reg_enable => wr_reg_enable_s,
            wr_ac_enable => wr_ac_enable_s,
            reset => reset,      
            flag_carry_in_sub => flag_carry_out_sub_s,
            flag_carry_in_add => flag_carry_out_add_s,                          
            flag_zero => flag_zero_in_s,
            flag_carry_out_add => flag_carry_in_add_s,
            flag_carry_out_sub => flag_carry_in_sub_s,
            ac_value => ac_value_s                    
        );

    -- Extrai endereço de salto da ROM
    input_jump_s <= dado_rom_s(14 downto 0);

    reg_selecto_s <= dado_rom_s(16 downto 13);

    opcode_ula <= dado_rom_s(18 downto 17); --Ainda nao defini nada, peguei 2 bits random do opcode para ser o seletor da ULA

    load_value_s <= dado_rom_s(16 downto 1) --Mesma coisa, ainda nao definido

end arch;