library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity banc_reg_16b_tb is
end banc_reg_16b_tb;

architecture Behavioral of banc_reg_16b_tb is
    --sinais para o teste, depende doq tiver no banco de registradores
    signal clk_tb      : std_logic;
    signal rst_tb      : std_logic;
    signal wr_en_tb    : std_logic;
    signal wr_addr_tb  : std_logic_vector(3 downto 0);
    signal wr_data_tb  : std_logic_vector(15 downto 0);
    signal rd_addr_tb  : std_logic_vector(3 downto 0);
    signal rd_data_tb  : std_logic_vector(15 downto 0);
    signal finished    : std_logic := '0';

    constant period_time : time := 100 ns;

    --o banco de registradores em si (VAI MUDAR)
    component banc_reg_16b is
        port(
            clk      : in  std_logic;
            rst      : in  std_logic;
            wr_en    : in  std_logic;
            wr_addr  : in  std_logic_vector(3 downto 0);
            wr_data  : in  std_logic_vector(15 downto 0);
            rd_addr  : in  std_logic_vector(3 downto 0);
            rd_data  : out std_logic_vector(15 downto 0)
        );
    end component;

begin 

    --instancia do banco com o port map (VAI MUDAR)
    uut: banc_reg_16b
        port map(
            clk      => clk_tb,
            rst      => rst_tb,
            wr_en    => wr_en_tb,
            wr_addr  => wr_addr_tb,
            wr_data  => wr_data_tb,
            rd_addr  => rd_addr_tb,
            rd_data  => rd_data_tb
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
        wait for 200 ns; --espera o reset passar

        --testes vao vir aqui 
        


        wait;  -- OBRIGATÓRIO
    end process;

end Behavioral;
