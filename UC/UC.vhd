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
        instr_out: out unsigned(18 downto 0)
    );
end UC;

architecture arch of UC is
signal flag_zero_reg: std_logic:= '0';
signal flag_carry_add_reg: std_logic:= '0';
signal flag_carry_sub_reg: std_logic:= '0';
signal opcode: unsigned(5 downto 0);

component fsm_estado 
    port (
        clk   : in  std_logic;
        reset : in  std_logic;
        estado : out unsigned(1 downto 0)
    );
end component;

signal state: unsigned(1 downto 0);
signal wr_reg_enable: 

begin
    --State machine
    inst_fsm: fsm_estado
        port map(
            clk => clk,
            reset => reset,
            estado => state
        );

    opcode <= instr(18 downto 16);
    --Atribuicao de sinais

    -- jump 111(opcode) (15 downto 0)(endereço)
    jump_en <= '1' when opcode = "111" and state = "10" else '0';

    --load control do acumulador
    -- operacoes da ula, opcode == 00 01 10
    load_control_ac <= "00" when (opcode = "100" or opcode = "010" or opcode = "000") and state = "10";
    -- load 001(opcode) (15 downto 8)(endereço) (7 downto 0) imediato
    load_control_ac <= "01" when opcode = "001" and instr(15) = '1';
    -- MV 011(opcode) (15 downto 8)(endereco do AC ou reg) (7 downto 0)(endereco do AC ou reg) o bit mais sign de cada end diz se é ac ou nao
    load_control_ac <= "10" when opcode = "011" and instr(15) = '1';

    --load control banco
    --load 001(opcode) (15 downto 8)(endereço) (7 downto 0)(imediato)
    load_control_banco <= '1' when opcode = "001" and instr(15) = '0' else '0';

    --cmpi control
    --cmpi 101(opcode) (15 downto 0)(imediato)
    cmpi_control <= '1' when opcode = "101" else '0'

    --write ac enable
    wr_ac_enable <= '1' when state = "10" else '0';

    --write reg enable

    wr_reg_enable <= '1' when state = "10" else '0';

    
    --Registradores das flags(O pdf diz que pode ficar dentro da UC)
    process(clk)
    begin
        if(rising_edge(clk)) then
            flag_zero_reg <= flag_zero_in;
            flag_carry_sub_reg <= flag_carry_in_sub;
            flag_carry_add_reg <= flag_carry_in_add;
        end if;
    end process;

    flag_zero_out <= flag_zero_reg;
    flag_carry_out_add <= flag_carry_add_reg;
    flag_carry_out_sub <= flag_carry_sub_reg;

    pc_write <= '1' when state = "10" else '0';
    opcode_out <= opcode;

end arch;