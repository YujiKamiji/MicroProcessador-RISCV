library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ula_tb is
end ula_tb;

architecture Behavioral of ula_tb is
    -- Sinais de teste
    signal clk_tb       : std_logic := '0';
    signal ent1_tb      : unsigned(15 downto 0) := (others => '0');
    signal op_code_tb   : unsigned(1 downto 0) := (others => '0');
    signal flag_zero_tb : std_logic;
    signal res_tb       : unsigned(15 downto 0);
begin

    -- Instância da ULA
    uut: entity work.ULA
        port map (
            clk        => clk_tb,
            ent1       => ent1_tb,
            op_code    => op_code_tb,
            flag_zero  => flag_zero_tb,
            res        => res_tb
        );

    -- Geração do clock
    clk_process : process
    begin
        for i in 0 to 9 loop
            clk_tb <= '0';
            wait for 2.5 ns;
            clk_tb <= '1';
            wait for 2.5 ns;
        end loop;
        wait; -- finaliza o processo
    end process;

    -- Estímulos
    stim_proc : process
begin
    wait for 5 ns; -- Espera 1 ciclo para estabilidade inicial

    -- LD: ac ← 10
    wait until rising_edge(clk_tb);
    ent1_tb <= to_unsigned(10, 16);
    op_code_tb <= "10";

    -- ADD: ac ← 10 + 5 = 15
    wait until rising_edge(clk_tb);
    ent1_tb <= to_unsigned(5, 16);
    op_code_tb <= "00";

    -- SUB: ac ← 15 - 3 = 12
    wait until rising_edge(clk_tb);
    ent1_tb <= to_unsigned(3, 16);
    op_code_tb <= "01";

    -- CMP: ac = 12, ent1 = 12 → flag_zero = 1
    wait until rising_edge(clk_tb);
    ent1_tb <= to_unsigned(12, 16);
    op_code_tb <= "11";

    -- CMP: ac = 12, ent1 = 7 → flag_zero = 0
    wait until rising_edge(clk_tb);
    ent1_tb <= to_unsigned(7, 16);
    op_code_tb <= "11";

    wait;
end process;

end Behavioral;