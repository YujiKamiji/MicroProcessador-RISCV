library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity flip_flop is
    Port (
        clk: in std_logic;
        input: std_logic;
        wr_enable: in std_logic;
        reset: in std_logic;
        output: out std_logic
    );
end flip_flop;

architecture arch of flip_flop is

signal data: std_logic:= '0';

begin

    process(clk) 
    begin
        if rising_edge(clk) then
            if reset = '0' then
                if wr_enable = '1' then
                    data <= input;
                end if;
            else
                data <= '0';
            end if;
        end if;
    end process;

    output <= data;

end arch;