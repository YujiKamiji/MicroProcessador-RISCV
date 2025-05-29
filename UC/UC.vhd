library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UC is
    Port (
        flag_zero_in: in std_logic;
        flag_carry_in: in std_logic;
        clk: in std_logic;
        flag_zero_out: out std_logic;
        flag_carry_out: out std_logic;
    );
end UC;

architecture arch of UC is
signal flag_zero_reg: std_logic:= '0';
signal flag_carry_reg: std_logic:= '0';

begin

    process(clk)
    begin
        if(rising_edge(clk)) then
            flag_zero_reg <= flag_zero_in;
            flag_carry_reg <= flag_carry_in;
        end if;
    end process;

    flag_zero_out <= flag_zero_reg;
    flag_carry_out <= flag_carry_reg;


end arch;