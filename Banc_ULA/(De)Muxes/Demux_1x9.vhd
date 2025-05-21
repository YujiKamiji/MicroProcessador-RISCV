library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Demux_1x9 is
    Port (
        selector: in unsigned(3 downto 0);
        enable_in: in std_logic;
        we: out unsigned(8 downto 0)
    );
end Demux_1x9;

architecture arch of Demux_1x9 is
begin
    we(0) <= '1' when selector = "0000" and enable_in = '1' else '0';
    we(1) <= '1' when selector = "0001" and enable_in = '1' else '0';
    we(2) <= '1' when selector = "0010" and enable_in = '1' else '0';
    we(3) <= '1' when selector = "0011" and enable_in = '1' else '0';
    we(4) <= '1' when selector = "0100" and enable_in = '1' else '0';
    we(5) <= '1' when selector = "0101" and enable_in = '1' else '0';
    we(6) <= '1' when selector = "0110" and enable_in = '1' else '0';
    we(7) <= '1' when selector = "0111" and enable_in = '1' else '0';
    we(8) <= '1' when selector = "1000" and enable_in = '1' else '0';
end arch;