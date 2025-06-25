library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Processador_tb is
end entity;

architecture sim of Processador_tb is

    signal clk   : std_logic := '0';
    signal reset : std_logic := '1';

    component Processador
        port (
            clk: in std_logic;
            reset: in std_logic
        );
    end component;

begin
    -- Instancia o processador
    uut: Processador
        port map (
            clk   => clk,
            reset => reset
        );

    -- Geração de clock: 10 ns por ciclo
    -- O clock alterna entre '0' e '1' a cada 5 ns, totalizando 10 ns por ciclo
    clk_process: process
    begin
        while now < 240000 ns loop
            clk <= '0'; wait for 5 ns;
            clk <= '1'; wait for 5 ns;
        end loop;
        wait;
    end process;

    reset_process: process
    begin
        reset <= '1'; wait for 5 ns;
        reset <= '0'; wait;
    end process;

end architecture;