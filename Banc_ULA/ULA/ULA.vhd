library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ULA is
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
    signal carry_next : std_logic;
    signal ent1_carry : unsigned(15 downto 0);
    signal cmp_aux : unsigned(15 downto 0);  
    signal and_op: unsigned(15 downto 0);
begin
    soma <= ac + ent1;
    sub <= ac - ent1 - ("000000000000000" & flag_carry_in);
    cmp_aux <= ac - ent1;

    ent1_carry <= ent1 + ("000000000000000" & flag_carry_in);
    carry_next <= '1' when ac < ent1_carry else '0';

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
    flag_carry_out <= carry_next;
    flag_zero_out <= '1' when cmp_aux = 0 else '0';
    
end arch;