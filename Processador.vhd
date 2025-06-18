library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Processador is
    Port (
        clk: in std_logic;
        reset: in std_logic
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
            load_value: in unsigned(10 downto 0); 
            ram_value: in unsigned(15 downto 0);    
            wr_reg_enable: in std_logic;
            wr_ac_enable: in std_logic;
            reset: in std_logic;        
            flag_carry_in_sub: in std_logic;
            flag_carry_in_add: in std_logic;                             
            flag_zero: out std_logic;
            flag_carry_out_add: out std_logic;
            flag_carry_out_sub: out std_logic;
            ac_value: out unsigned(15 downto 0);
            reg_value: out unsigned(15 downto 0)                      
        );
    end component;

    component pc
        port (
            clk        : in  std_logic;
            reset      : in  std_logic;
            wr_enable  : in  std_logic;
            seletor    : in  std_logic;
            input_inc  : in  unsigned(6 downto 0);
            input_jump : in  unsigned(6 downto 0);
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
    
    component reg_19b 
        Port (
            clk: in std_logic;
            input: in unsigned(18 downto 0);
            wr_enable: in std_logic;
            reset: in std_logic;
            output: out unsigned(18 downto 0)
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
        load_control_banco: out std_logic;
        cmpi_control: out std_logic;
        wr_ac_enable: out std_logic;
        wr_reg_enable: out std_logic;
        wr_ram : out std_logic

    );
    end component;

    component ram
        port(
            clk : in std_logic;
            endereco : in unsigned(6 downto 0);
            wr_en : in std_logic;
            dado_in : in unsigned(15 downto 0);
            dado_out : out unsigned(15 downto 0)
        );
    end component;

    -- Sinais internos
    signal endereco_s   : unsigned(6 downto 0);
    signal dado_rom_s   : unsigned(18 downto 0);
    signal input_inc_s  : unsigned(6 downto 0);
    signal jump_en_s    : std_logic;
    signal input_jump_s : unsigned(6 downto 0);
    signal pc_write_s   : std_logic;
    signal opcode_ula: unsigned(1 downto 0);
    signal reg_selector_s: unsigned(3 downto 0);
    signal load_control_ac_s: unsigned(1 downto 0);
    signal load_control_banco_s: std_logic;
    signal cmpi_control_s: std_logic;
    signal load_value_s: unsigned(10 downto 0);
    signal wr_ac_enable_s: std_logic;
    signal wr_reg_enable_s: std_logic;
    signal ac_value_s: unsigned(15 downto 0);
    signal instr_out_s: unsigned(18 downto 0);
    signal opcode_s: unsigned(3 downto 0);
    signal endereco_signed: signed(7 downto 0);
    signal input_aux: unsigned(6 downto 0);
    signal input_unsigned: unsigned(7 downto 0);
    signal wr_ram_s: std_logic;
    signal ram_value_s: unsigned(15 downto 0);
    signal reg_value_s: unsigned(15 downto 0);

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

    ram_inst: ram
        port map(
            clk         => clk,
            endereco    => reg_value_s(6 downto 0),
            wr_en       => wr_ram_s,
            dado_in     => ac_value_s,
            dado_out    => ram_value_s
        );

    -- Somador (PC + 1)
    somador_inst: somador_pc
        port map (
            entrada => endereco_s,
            saida   => input_inc_s
        );

    reg_instr: reg_19b 
        port map(
            clk => clk,
            input => dado_rom_s,
            wr_enable => '1',
            reset => reset,
            output => instr_out_s
        );

    -- UC
    uc_inst: UC
        port map (
            instr           => instr_out_s,
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
            wr_ram => wr_ram_s
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
            ram_value => ram_value_s,
            wr_reg_enable => wr_reg_enable_s,
            wr_ac_enable => wr_ac_enable_s,
            reset => reset,      
            flag_carry_in_sub => flag_carry_out_sub_s,
            flag_carry_in_add => flag_carry_out_add_s,                          
            flag_zero => flag_zero_in_s,
            flag_carry_out_add => flag_carry_in_add_s,
            flag_carry_out_sub => flag_carry_in_sub_s,
            ac_value => ac_value_s,
            reg_value => reg_value_s         
        );

    
    opcode_s <= instr_out_s(18 downto 15);

    endereco_signed <= signed('0' & endereco_s);

    input_unsigned <= unsigned(endereco_signed + signed(instr_out_s(14 downto 7)));

    input_aux <= input_unsigned(6 downto 0);

    -- mux para o input_jump
    with opcode_s select
    input_jump_s <= 
        instr_out_s(14 downto 8)   when "0010",  --jump
        input_aux                  when "1010" | "1110", --bhi e bcc
        to_unsigned(0, 7)          when others; --pra outra coisa, so coloca 0

    reg_selector_s <= instr_out_s(14 downto 11);

    opcode_ula <= opcode_s(2 downto 1); 

    load_value_s <= instr_out_s(10 downto 0);

end arch;