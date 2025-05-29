library ieee;
use ieee.std_logic_1164.all;

entity fsm_estado is
    port (
        clk   : in  std_logic;
        reset : in  std_logic;
        estado : out std_logic
    );
end fsm_estado;

architecture behavior of fsm_estado is
    signal estado_s : std_logic := '0';  -- estado interno (0: fetch, 1: execute)
begin
    process(clk, reset)
    begin
        if reset = '1' then
            estado_s <= '0';             -- volta para estado fetch
        elsif rising_edge(clk) then
            estado_s <= not estado_s;    -- alterna estado a cada clock
        end if;
    end process;

    estado <= estado_s;
end architecture;