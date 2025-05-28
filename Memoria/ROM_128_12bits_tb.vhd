library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_rom is
end tb_rom;

architecture sim of tb_rom is
    signal clk      : std_logic := '0';
    signal endereco : unsigned(6 downto 0) := (others => '0');  -- 7 bits
    signal dado     : unsigned(18 downto 0);                    -- 19 bits

    component rom
        port (
            clk      : in  std_logic;
            endereco : in  unsigned(6 downto 0);
            dado     : out unsigned(18 downto 0)
        );
    end component;

begin
    uut: rom port map (
        clk => clk,
        endereco => endereco,
        dado => dado
    );

    clk_process: process
    begin
        for i in 0 to 10 loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
            endereco <= endereco + 1;
        end loop;
        wait;
    end process;
end architecture;
