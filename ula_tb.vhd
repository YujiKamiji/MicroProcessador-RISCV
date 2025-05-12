library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_tb is
end entity;

architecture sim of ula_tb is

    -- nossa ula
    component ula
        port (
            a        : in  std_logic_vector(15 downto 0);
            b        : in  std_logic_vector(15 downto 0);
            seletor  : in  std_logic_vector(1 downto 0);
            resultado: out std_logic_vector(15 downto 0);
            zero     : out std_logic;
            negativo: out std_logic
        );
    end component;

    -- Sinais locais para conectar na nosssa ula
    signal a, b, resultado : std_logic_vector(15 downto 0);
    signal seletor         : std_logic_vector(1 downto 0);
    signal zero, negativo : std_logic;

begin
    uut: ula port map ( --ula
        a => a,
        b => b,
        seletor => seletor,
        resultado => resultado,
        zero => zero,
        negativo => negativo
    );

    -- Processo de geracao de estimulos
    stim_proc: process
    begin
        -- Soma 
        a <= std_logic_vector(to_signed(5, 16));
        b <= std_logic_vector(to_signed(3, 16));
        seletor <= "00"; -- soma
        wait for 100 ns;

        -- Subtracao 
        a <= std_logic_vector(to_signed(4, 16));
        b <= std_logic_vector(to_signed(10, 16));
        seletor <= "01"; -- subtracao
        wait for 100 ns;

        -- and
        a <= X"0F0F";
        b <= X"00FF";
        seletor <= "10"; -- and
        wait for 100 ns;

        -- or
        a <= X"FFFF";
        b <= X"0000";
        seletor <= "11"; -- or
        wait for 100 ns;

        -- fim da simulação
        wait;
    end process;

end architecture;
