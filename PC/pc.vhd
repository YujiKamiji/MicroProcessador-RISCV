library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
    port (
        clk        : in  std_logic;
        reset      : in  std_logic;
        wr_enable  : in  std_logic;
        seletor    : in  std_logic;
        input_inc  : in  unsigned(6 downto 0);
        input_jump : in  unsigned(14 downto 0);
        pc_out     : out unsigned(6 downto 0)
    );
end entity;

architecture arch of pc is
    signal ent1_ext : unsigned(15 downto 0);
    signal ent2_ext : unsigned(15 downto 0);
    signal mux_out  : unsigned(15 downto 0);
    signal reg_out  : unsigned(15 downto 0);

    component reg_16b
        port (
            clk       : in  std_logic;
            input     : in  unsigned(15 downto 0);
            wr_enable : in  std_logic;
            reset     : in  std_logic;
            output    : out unsigned(15 downto 0)
        );
    end component;

    component Mux_2x1
        port (
            ent1         : in  unsigned(15 downto 0);
            ent2         : in  unsigned(15 downto 0);
            selector_key : in  std_logic;
            result       : out unsigned(15 downto 0)
        );
    end component;

begin
    ent1_ext(6 downto 0)  <= input_inc;
    ent1_ext(15 downto 7) <= (others => '0');

    ent2_ext(14 downto 0) <= input_jump;
    ent2_ext(15)          <= '0';

    mux_inst: Mux_2x1
        port map (
            ent1         => ent1_ext,
            ent2         => ent2_ext,
            selector_key => seletor,
            result       => mux_out
        );

    reg_inst: reg_16b
        port map (
            clk       => clk,
            input     => mux_out,
            wr_enable => wr_enable,
            reset     => reset,
            output    => reg_out
        );

    pc_out <= reg_out(6 downto 0);

end architecture;
