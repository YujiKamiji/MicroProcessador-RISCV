library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity banc_reg_16b is
    Port (
        selector: in unsigned(3 downto 0);
        clk: in std_logic;
        reg_wr: in unsigned(15 downto 0);
        wr_enable: in std_logic;
        reset: in std_logic;
        reg_out: out unsigned(15 downto 0)
    );
end banc_reg_16b;

architecture arch of banc_reg_16b is

    component Mux_9x1 is
        port(
            selector: in unsigned(3 downto 0);
            x0, x1, x2, x3, x4, x5, x6, x7, x8: in unsigned(15 downto 0);
            result: out unsigned(15 downto 0)
        );
    end component;

    component Demux_1x9 is
        port(
            selector: in unsigned(3 downto 0);
            enable_in: in std_logic;
            we: out unsigned(8 downto 0)
        );
    end component;

    component reg_16b is
        port(
            clk: in std_logic;
            input: in unsigned(15 downto 0);
            wr_enable: in std_logic;
            reset: in std_logic;
            output: out unsigned(15 downto 0)
        );
    end component;

    signal we_aux: unsigned(8 downto 0):= (others => '0');
    type reg_array is array(0 to 8) of unsigned(15 downto 0);
    signal reg_aux: reg_array := (others => (others => '0'));
begin
    demux: Demux_1x9 
        port map(
            selector => selector,
            enable_in => wr_enable,
            we => we_aux
        );

    r0: reg_16b
        port map(
            clk => clk,
            input => reg_wr,
            wr_enable => we_aux(0),
            reset => reset,
            output => reg_aux(0)
        );
    
    r1: reg_16b
    port map(
        clk => clk,
        input => reg_wr,
        wr_enable => we_aux(1),
        reset => reset,
        output => reg_aux(1)
    );

    r2: reg_16b
    port map(
        clk => clk,
        input => reg_wr,
        wr_enable => we_aux(2),
        reset => reset,
        output => reg_aux(2)
    );

    r3: reg_16b
    port map(
        clk => clk,
        input => reg_wr,
        wr_enable => we_aux(3),
        reset => reset,
        output => reg_aux(3)
    );

    r4: reg_16b
    port map(
        clk => clk,
        input => reg_wr,
        wr_enable => we_aux(4),
        reset => reset,
        output => reg_aux(4)
    );

    r5: reg_16b
    port map(
        clk => clk,
        input => reg_wr,
        wr_enable => we_aux(5),
        reset => reset,
        output => reg_aux(5)
    );

    r6: reg_16b
    port map(
        clk => clk,
        input => reg_wr,
        wr_enable => we_aux(6),
        reset => reset,
        output => reg_aux(6)
    );

    r7: reg_16b
    port map(
        clk => clk,
        input => reg_wr,
        wr_enable => we_aux(7),
        reset => reset,
        output => reg_aux(7)
    );

    r8: reg_16b
    port map(
        clk => clk,
        input => reg_wr,
        wr_enable => we_aux(8),
        reset => reset,
        output => reg_aux(8)
    );

    mux: Mux_9x1
        port map(
            selector => selector,
            x0 => reg_aux(0),
            x1 => reg_aux(1),
            x2 => reg_aux(2),
            x3 => reg_aux(3),
            x4 => reg_aux(4),
            x5 => reg_aux(5),
            x6 => reg_aux(6),
            x7 => reg_aux(7),
            x8 => reg_aux(8),
            result => reg_out
        );



end arch;

