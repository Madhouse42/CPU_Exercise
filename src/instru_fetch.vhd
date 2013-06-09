library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.exp_cpu_components.all;

entity instru_fetch     is
    port(
            reset, clk  :   in std_logic;
            data_read   :   in std_logic_vector(15 downto 0);
            lj_instruct :   in std_logic;
            dw_instruct :   in std_logic;
            c_z_j_flag  :   in std_logic;
            sjmp_addr   :   in std_logic_vector(15 downto 0);
            t1, t2, t3  :   buffer std_logic;
            pc          :   buffer std_logic_vector(15 downto 0);
            pc_inc      :   buffer std_logic_vector(15 downto 0);
            IR          :   out std_logic_vector(15 downto 0)
        );
end instru_fetch;

architecture behav of instru_fetch is
    signal start : std_logic;
begin
    IR_poc: process(reset, t2)
    begin
        if reset = '0' then
            IR  <=  x"7000";
        elsif t2'event and t2 = '1' then
            IR  <=  data_read;
        end if;
    end process;

    process(reset, clk)
    begin
        if reset = '0' then
            start <= '1';
        else
            if clk'event and clk = '0' then
                start <= '0';
            end if;
        end if;
    end process;
    
    process(reset, clk)
    begin
        if reset = '0' then 
            t1 <= '0';
            t2 <= '0';
            t3 <= '0';
        elsif clk'event and clk = '1' then
            t1 <= start or t3;
            t2 <= t1;
            t3 <= t2;
        end if;
    end process;
    
    pc_inc <= pc + '1';
    PC_proc: process(reset, t3)
    begin
        if reset = '0' then
            pc <= x"0000";
        elsif t3'event and t3 = '0' then
            if lj_instruct = '1' then
                pc <= data_read;
            elsif c_z_j_flag = '1' then
                pc <= sjmp_addr;
            elsif DW_instruct = '1' then
                pc <= pc + "10";
            else
                pc <= pc_inc;
            end if;
        end if;
    end process;
    
end behav;
