library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ULA is
    Port (
        clk: in std_logic;
        ent1: in unsigned(15 downto 0);
        ac: in unsigned(15 downto 0);
        op_code: in unsigned(1 downto 0);
        flag_carry_in_sub: in std_logic;
        flag_carry_out_sub: out std_logic;
        flag_carry_in_add: in std_logic;
        flag_carry_out_add: out std_logic;
        flag_zero_out: out std_logic;
        res: out unsigned(15 downto 0)
    );
end ULA;

architecture arch of ULA is

    component Mux_4x1 is
        port(
            add,sub,andOP,cmp: in unsigned(15 downto 0);
            selector_key: in unsigned(1 downto 0);
            result: out unsigned(15 downto 0)  
        );
    end component;

    signal soma, sub: unsigned(15 downto 0);
    signal mux_out: unsigned(15 downto 0);
    signal and_op: unsigned(15 downto 0);
    signal result_carry_add, result_carry_sub: unsigned(16 downto 0);
begin
    --Soma e sub
    soma <= ac + ent1 + unsigned("000000000000000" & flag_carry_in_add);
    sub <= ac - ent1 - unsigned("000000000000000" & flag_carry_in_sub);
    
    --Verificacao carry
    --carry add
    result_carry_add <= ("0" & ac) + ("0" & ent1);
    flag_carry_out_add <= result_carry_add(16);
    --carry sub
    result_carry_sub <= ("0" & ac) - ("0" & ent1);
    flag_carry_out_sub <= result_carry_sub(16);

    and_op <= ac and ent1;

    mux: Mux_4x1
        port map(
            add => soma,
            sub => sub,
            andOP => and_op,
            cmp => ac,
            selector_key => op_code,
            result => mux_out
        );

    res <= mux_out;
    flag_zero_out <= '1' when mux_out = 0 else '0';
    
end arch;