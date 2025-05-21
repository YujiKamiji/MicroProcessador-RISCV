library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity banc_ula_tb is
end banc_ula_tb;

architecture Behavioral of banc_ula_tb is
    --sinais para o teste, depende doq tiver no Banc_ULA
    signal clk_tb               : std_logic;
    signal rst_tb               : std_logic := '0';
    signal op_code_tb           : unsigned(1 downto 0);
    signal reg_selector_tb      : unsigned(3 downto 0);
    signal load_control_banco_tb: std_logic;
    signal load_control_ac_tb   : unsigned(1 downto 0);
    signal cmpi_control_tb      : std_logic;
    signal load_value_tb        : unsigned(15 downto 0);
    signal wr_reg_enable_tb     : std_logic;
    signal flag_zero_tb         : std_logic;
    signal flag_carry_tb        : std_logic;
    signal reg_read_out_tb      : unsigned(15 downto 0);
    signal ac_value_tb          : unsigned(15 downto 0);
    signal finished             : std_logic := '0';
    signal wr_ac_enable_tb      : std_logic;

    constant period_time : time := 100 ns;

    --componente a ser testado
    component Banc_ULA is
        Port (
            clk: in std_logic;
            op_code: in unsigned(1 downto 0);          
            reg_selector: in unsigned(3 downto 0); 
            load_control_banco: in std_logic;
            load_control_ac: in unsigned(1 downto 0);
            cmpi_control: in std_logic;
            load_value: in unsigned(15 downto 0);     
            wr_reg_enable: in std_logic;
            wr_ac_enable: in std_logic;
            reset: in std_logic;                                    
            flag_zero: out std_logic;
            flag_carry: out std_logic;
            reg_read_out: out unsigned(15 downto 0); 
            ac_value: out unsigned(15 downto 0)                      
        );
    end component;

begin 

    --instancia do componente a ser testado
    banc: Banc_ULA
        port map(
            clk                  => clk_tb,
            op_code              => op_code_tb,
            reg_selector         => reg_selector_tb,
            load_control_banco   => load_control_banco_tb,
            load_control_ac      => load_control_ac_tb,
            cmpi_control         => cmpi_control_tb,
            load_value           => load_value_tb,
            wr_reg_enable        => wr_reg_enable_tb,
            wr_ac_enable         => wr_ac_enable_tb,
            reset                => rst_tb,
            flag_zero            => flag_zero_tb,
            flag_carry           => flag_carry_tb,
            reg_read_out         => reg_read_out_tb,
            ac_value             => ac_value_tb
        );

    --gera o clock so quando o teste estiver ativo (finished = '0')
    process
    begin
        while finished /= '1' loop
            clk_tb <= '0';
            wait for period_time / 2;
            clk_tb <= '1';
            wait for period_time / 2;
        end loop;
        wait;
    end process;

    --processo de reset, da um pulso inicial e dps congela com o wait
    process
    begin
        rst_tb <= '1';              --ativa o reset por 200ns
        wait for 2 * period_time;
        rst_tb <= '0';
        wait;
    end process;

    --tempo total da simulação
    sim_time_proc: process
    begin
        wait for 3 us;
        finished <= '1';            --dps dos 3000ns, termina a simulacao
        wait;
    end process;

    process
    begin
        wait for 300 ns; --espera o reset passar

        --testes vao vir aqui 

        -- carrega valor 10 no registrador 2
        wr_ac_enable_tb <= '1';
        load_value_tb        <= to_unsigned(10, 16);
        load_control_banco_tb <= '1'; -- usar load_value
        reg_selector_tb      <= "0010";
        wr_reg_enable_tb     <= '1';
        wait until rising_edge(clk_tb);

        -- carrega valor 5 no acumulador (pela entrada direta)
        load_value_tb        <= to_unsigned(5, 16);
        load_control_ac_tb   <= "01"; -- usar load_value
        wr_reg_enable_tb     <= '0';
        wait until rising_edge(clk_tb);

        -- soma acumulador + registrador 2 (ac = 5 + 10)
        op_code_tb           <= "00";  -- opcode para ADD
        load_control_ac_tb   <= "00";  -- usar saida da ULA
        reg_selector_tb      <= "0010"; -- registrador 2
        cmpi_control_tb      <= '0';   -- usar valor do banco na ULA
        wait until rising_edge(clk_tb);

        -- grava valor do acumulador no registrador 3
        wr_ac_enable_tb <= '0';
        load_control_banco_tb <= '0';  -- usar ac como entrada
        wr_reg_enable_tb     <= '1';
        reg_selector_tb      <= "0011"; -- registrador 3
        wait until rising_edge(clk_tb);

        -- desativa escrita
        wr_reg_enable_tb     <= '0';
        wait;

    end process;

end Behavioral;
