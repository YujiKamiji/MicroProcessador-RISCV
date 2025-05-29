library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_uc_pc_rom_tb is
end entity;

architecture sim of top_uc_pc_rom_tb is

    signal clk   : std_logic := '0';
    signal reset : std_logic := '1';
    signal dado  : unsigned(18 downto 0);

    component top_uc_pc_rom
        port (
            clk   : in std_logic;
            reset : in std_logic;
            dado  : out unsigned(18 downto 0)
        );
    end component;

begin

    uut: top_uc_pc_rom
        port map (
            clk   => clk,
            reset => reset,
            dado  => dado
        );

    clk_process: process
    begin
        while now < 200 ns loop
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
