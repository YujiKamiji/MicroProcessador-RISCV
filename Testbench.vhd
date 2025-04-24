library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_tb is
end entity;

architecture sim of ula_tb is

    component ula
        port (
            a        : in  std_logic_vector(15 downto 0);            -- Declaracao do componente a ser testado (copiar exatamente a interface da sua ULA)
            b        : in  std_logic_vector(15 downto 0);
            op       : in  std_logic_vector(1 downto 0);
            res      : out std_logic_vector(15 downto 0);
            zero     : out std_logic;
            negativo : out std_logic
        );
    end component;

    -- Sinais locais que vao se conectar aos pinos da ULA
    signal a, b, res     : std_logic_vector(15 downto 0);
    signal op            : std_logic_vector(1 downto 0);
    signal zero, negativo: std_logic;

begin

    -- Instancia da ULA
    uut: ula port map (
        a => a,
        b => b,
        op => op,
        res => res,
        zero => zero,
        negativo => negativo
    );

    -- Processo de geracao de estimulos
    stim_proc: process
    begin
        -- Teste 1: Soma de dois numeros positivos
        a <= std_logic_vector(to_signed(5, 16));
        b <= std_logic_vector(to_signed(3, 16));
        op <= "00"; -- Operacao soma
        wait for 100 ns;

        -- Teste 2: Subtracao gerando resultado negativo
        a <= std_logic_vector(to_signed(4, 16));
        b <= std_logic_vector(to_signed(10, 16));
        op <= "01"; -- Operacao subtracao
        wait for 100 ns;

        -- Teste 3: Operacao logica 1 (exemplo: AND)
        a <= X"0F0F";
        b <= X"00FF";
        op <= "10"; -- Operacao logica 1
        wait for 100 ns;

        -- Teste 4: Operacao logica 2 (exemplo: OR)
        a <= X"FFFF";
        b <= X"0000";
        op <= "11"; -- Operacao logica 2
        wait for 100 ns;

        -- Finaliza a simulacao
        wait;
    end process;

end architecture;
