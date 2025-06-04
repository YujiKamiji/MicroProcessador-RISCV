library ieee;
use ieee.std_logic_1164.all;

entity fsm_estado is
    port (
        clk   : in  std_logic;
        reset : in  std_logic;
        estado : out unsigned(1 downto 0)
    );
end fsm_estado;

architecture behavior of fsm_estado is
    signal estado_s : std_logic := '0';  -- estado interno (0: fetch, 1: execute)
begin
    process(clk, reset)
    begin
        if reset = '1' then
            estado_s <= "00";             -- volta para estado fetch
        elsif rising_edge(clk) then
            if estado_s <= "01" then
                estado_s <= estado_s + 1;
            else
                estado_s <= "00";
            end if;
        end if;
    end process;

    estado <= estado_s;
end architecture;