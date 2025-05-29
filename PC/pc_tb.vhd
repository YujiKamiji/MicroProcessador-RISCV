library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_pc is
end tb_pc;

architecture sim of tb_pc is
    signal clk       : std_logic := '0';
    signal reset     : std_logic := '0';
    signal wr_enable : std_logic := '1';
    signal pc_out    : unsigned(6 downto 0);

    component pc
        port (
            clk       : in  std_logic;
            reset     : in  std_logic;
            wr_enable : in  std_logic;
            pc_out    : out unsigned(6 downto 0)
        );
    end component;

begin
    -- Instancia o PC
    uut: pc
        port map (
            clk       => clk,
            reset     => reset,
            wr_enable => wr_enable,
            pc_out    => pc_out
        );

    -- Clock gerado com período de 10 ns
    clk_process: process
    begin
        while now < 150 ns loop
            clk <= '0'; wait for 5 ns;
            clk <= '1'; wait for 5 ns;
        end loop;
        wait;
    end process;

    -- Reset aplicado no início por 10 ns
    reset_process: process
    begin
        reset <= '1'; wait for 10 ns;
        reset <= '0'; wait;
    end process;

end architecture;
