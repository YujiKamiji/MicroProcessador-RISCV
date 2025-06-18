library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UC is
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
end UC;

architecture arch of UC is
signal flag_zero_reg: std_logic:= '0';
signal flag_carry_add_reg: std_logic:= '0';
signal flag_carry_sub_reg: std_logic:= '0';
signal opcode: unsigned(3 downto 0);
signal reset_flags: std_logic;

component fsm_estado 
    port (
        clk   : in  std_logic;
        reset : in  std_logic;
        estado : out unsigned(1 downto 0)
    );
end component;

component flip_flop 
    Port (
        clk: in std_logic;
        input: std_logic;
        wr_enable: in std_logic;
        reset: in std_logic;
        output: out std_logic
    );
end component;

signal state: unsigned(1 downto 0);
signal wr_enable_flags: std_logic := '0';
 

begin
    --State machine
    inst_fsm: fsm_estado
        port map(
            clk => clk,
            reset => reset,
            estado => state
        );

    opcode <= instr(18 downto 15);

    wr_enable_flags <= opcode(0) when opcode /= "1101";

    --Clear das flags
    reset_flags <= '1' when opcode = "1101" else '0';

    --Atribuicao de sinais

    -- jump 0010(opcode) (14 downto 8)(endereço rom)
    -- BHI 1010(opcode) (14 downto 7)(imediato)
    -- BCC 1110(opcode) (14 downto 7)(imediato)
    jump_en <= '1' when (opcode = "0010") or (opcode = "1010" and flag_zero_reg = '0' and flag_carry_sub_reg = '0') or (opcode = "1110" and flag_carry_sub_reg = '0') else '0';

    -- MOVRAM 0000(opcode) (14 downto 11)(endereço reg) instr(1)(bit que usamos pq faltou opcodekk)
    wr_ram <= '1' when opcode = "0000"  and instr(1) = '1' and state = "11" else '0'; --falta de planejamento ao decidir 4 bits no opcode, estamos usando o 5 bit apenas nessa pq faltou e 0000 é o NOP entao nao tem como instr(1) ser 1

    --load control do acumulador
    --with opcode select
    --load_control_ac <= 
    --    "00" when "0001" | "0011" | "0101" | "1001" | "1011", -- operacoes da ula, opcode == 0001 0011 0011 (ultimo bit 1) (14 downto 11)(endereço)
    --    "01" when "0100", -- loadac 0100(opcode) (10 downto 0) (imediato)
    --    "10" when "1000", -- MVac 1000(opcode) (14 downto 11)(endereço) 
    --    "11" when ""
    --    "00" when others;
    --LOADRAM 0000(opcode) (14 downto 11)(endereço reg) instr(0)(bit que usamos q faltou opcode... perdão pela gambiarra)
    load_control_ac <= 
    "00" when (
        opcode = "0001" or 
        opcode = "0011" or 
        opcode = "0101" or 
        opcode = "1001" or 
        opcode = "1011"
    ) else
    "01" when opcode = "0100" else
    "10" when opcode = "1000" else
    "11" when (opcode = "0000" and instr(0) = '1') else
    "00";  -- valor padrão obrigatório
    
    --load control banco
    --load 0110(opcode) (14 downto 11)(endereço) (10 downto 0)(imediato)
    load_control_banco <= '1' when opcode = "0110" else '0';

    --cmpi control
    --cmpi 1111(opcode) (10 downto 0)(imediato) addi 1001(opcode)(10 downto 0)(imediato) subi 1011(opcode) (10 downto 0)(imediato)
    cmpi_control <= '1' when opcode = "1111" or opcode = "1001" or opcode = "1011" else '0';

    --write ac enable
    wr_ac_enable <= '1' when state = "10" and (opcode = "0001" or opcode = "0011" or opcode = "0101" or opcode = "1001" or opcode = "1011" or opcode = "0100" or opcode = "1000" or (opcode = "0000" and instr(0) = '1'))  else '0';

    --write reg enable
    --MVreg 1100(opcode) (14 downto 11)(endereço)
    --LOADREG 0110(opcode) (14 downto 11)(endereço) (10 downto 0)(imediato)
    wr_reg_enable <= '1' when state = "10" and (opcode = "1100" or opcode = "0110") else '0';

    flag_zero_ffp: flip_flop
        port map(
            clk => clk,
            input => flag_zero_in,
            wr_enable => wr_enable_flags, --atualizar apenas quando instr da ula
            reset => reset_flags,
            output => flag_zero_reg
        );

    flag_carry_sub_ffp: flip_flop
        port map(
            clk => clk,
            input => flag_carry_in_sub,
            wr_enable => wr_enable_flags,
            reset => reset_flags,
            output => flag_carry_sub_reg
        );

    flag_carry_add_ffp: flip_flop
        port map(
            clk => clk,
            input => flag_carry_in_add,
            wr_enable => wr_enable_flags,
            reset => reset_flags,
            output => flag_carry_add_reg
        );

    pc_write <= '1' when state = "11" else '0';

    flag_zero_out <= flag_zero_reg;
    flag_carry_out_sub <= flag_carry_sub_reg;
    flag_carry_out_add <= flag_carry_add_reg;
    

end arch;