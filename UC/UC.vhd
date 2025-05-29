library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UC is
    Port (
        instr: in unsigned(18 downto 0);
        reset: in std_logic;
        --flags in
        flag_zero_in: in std_logic;
        flag_carry_in: in std_logic;
        clk: in std_logic;
        --flags out
        flag_zero_out: out std_logic;
        flag_carry_out: out std_logic;
        --sinais de saida
        jump_en: out std_logic;
    );
end UC;

architecture arch of UC is
signal flag_zero_reg: std_logic:= '0';
signal flag_carry_reg: std_logic:= '0';
signal opcode: unsigned(5 downto 0);

component fsm_estado 
    port (
        clk   : in  std_logic;
        reset : in  std_logic;
        estado : out std_logic
    );
end component;

signal state: std_logic;

begin
    --State machine
    inst_fsm: fsm_estado
        port map(
            clk => clk,
            reset => reset,
            estado => state
        );

    opcode <= instr(18 downto 13);
    --Atribuicao de sinais

    jump_en <= '1' when opcode = "110011" and state = '1' else '0'
    
    --Registradores das flags(O pdf diz que pode ficar dentro da UC)
    process(clk)
    begin
        if(rising_edge(clk)) then
            flag_zero_reg <= flag_zero_in;
            flag_carry_reg <= flag_carry_in;
        end if;
    end process;

    flag_zero_out <= flag_zero_reg;
    flag_carry_out <= flag_carry_reg;

end arch;