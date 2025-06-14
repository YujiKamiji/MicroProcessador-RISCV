library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reg_19b is
    Port (
        clk: in std_logic;
        input: in unsigned(18 downto 0);
        wr_enable: in std_logic;
        reset: in std_logic;
        output: out unsigned(18 downto 0)
    );
end reg_19b;

architecture arch of reg_19b is

signal data: unsigned(18 downto 0):= (others => '0');

begin

    process(clk) 
    begin
        if rising_edge(clk) then
            if reset = '0' then
                if wr_enable = '1' then
                    data <= input;
                end if;
            else
                data <= (others => '0');
            end if;
        end if;
    end process;

    output <= data;

end arch;