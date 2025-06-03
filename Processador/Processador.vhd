library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Processador is
    Port (
        clk: in std_logic;
        reset: in std_logic;

    );
end Processador;

architecture arch of Processador is

    component Banc_ULA 
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
            flag_carry_in_sub: in std_logic;
            flag_carry_in_add: in std_logic;                             
            flag_zero: out std_logic;
            flag_carry_out_add: out std_logic;
            flag_carry_out_sub: out std_logic;
            ac_value: out unsigned(15 downto 0)                      
        );
    end component;

    component pc
        port (
            clk        : in  std_logic;
            reset      : in  std_logic;
            wr_enable  : in  std_logic;
            seletor    : in  std_logic;
            input_inc  : in  unsigned(6 downto 0);
            input_jump : in  unsigned(14 downto 0);
            pc_out     : out unsigned(6 downto 0)
        );
    end component;

    component rom
        port (
            clk      : in  std_logic;
            endereco : in  unsigned(6 downto 0);
            dado     : out unsigned(18 downto 0)
        );
    end component;

    component somador_pc
        port (
            entrada : in  unsigned(6 downto 0);
            saida   : out unsigned(6 downto 0)
        );
    end component;

    component UC
        port (
            instr           : in  unsigned(18 downto 0);
            reset           : in  std_logic;
            flag_zero_in    : in  std_logic;
            flag_carry_in   : in  std_logic;
            clk             : in  std_logic;
            flag_zero_out   : out std_logic;
            flag_carry_out  : out std_logic;
            jump_en         : out std_logic;
            pc_write        : out std_logic
        );
    end component;

begin








end arch;