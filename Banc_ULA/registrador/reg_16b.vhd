library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reg_16b is
    Port (
        CLK: in std_logic;
        input: in unsigned(15 downto 0);
        wr_enable: in std_logic;
        output: out unsigned(15 downto 0)
    );
end reg_16b;

architecture arch of reg_16b is

signal data: unsigned(15 downto 0):= (others => '0');

begin

    process(CLK) 
    begin
        if rising_edge(CLK) then
            if wr_enable = '1' then
                data <= input;
            end if;
        end if;
    end process;

    output <= data;

end arch;