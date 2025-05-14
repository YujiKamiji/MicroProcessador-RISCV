library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ULA is
    Port (
        clk: in std_logic;
        ent1: in unsigned(15 downto 0);
        op_code: in unsigned(1 downto 0);
        flag_zero: out std_logic;
        res: out unsigned(15 downto 0)
    );
end ULA;

architecture arch of ULA is

    component Mux_4x1 is
        port(
            add,sub,ld,cmp: in unsigned(15 downto 0);
            selector_key: in unsigned(1 downto 0);
            result: out unsigned(15 downto 0)  
        );
    end component;

    signal soma, sub: unsigned(15 downto 0);
    signal ac: unsigned(15 downto 0) := (others => '0');
    signal mux_out: unsigned(15 downto 0);
    signal carry_flag : std_logic := '0';
    signal carry_next : std_logic;
    signal ent1_carry : unsigned(15 downto 0);
    signal cmp_aux : unsigned(15 downto 0);  
begin
    soma <= ac + ent1;
    sub <= ac - ent1 - ("000000000000000" & carry_flag);
    cmp_aux <= ac - ent1;

    ent1_carry <= ent1 + ("000000000000000" & carry_flag);
    carry_next <= '1' when ac < ent1_carry else '0';

    mux: Mux_4x1
        port map(
            add => soma,
            sub => sub,
            ld => ent1,
            cmp => ac,
            selector_key => op_code,
            result => mux_out
        );

    process(clk) 
    begin
        --Registradores sendo criados para ac e flags por estarem sofrendo atribuicoes sensiveis ao clock, proposital
        if rising_edge(clk) then
            ac <= mux_out;

            if op_code = "01" then  
                carry_flag <= carry_next;
            end if;

            if op_code = "11" and cmp_aux = 0 then  
                flag_zero <= '1';
            else
                flag_zero <= '0';
            end if;

        end if;
    end process;

    res <= ac;
    
end arch;