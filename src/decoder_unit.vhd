library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.exp_cpu_components.all;

entity decoder_unit is
    port (IR : in std_logic_vector (15 downto 0);
          SR : out std_logic_vector (1 downto 0);
          DR : out std_logic_vector (1 downto 0);
          op_code : out std_logic_vector (2 downto 0);
          zj_instruct : out std_logic;
          cj_instruct : out std_logic;
          lj_instruct : out std_logic;
          DRWr : buffer std_logic;
          mem_write : out std_logic;
          dw_instruct : buffer std_logic;
          change_z : out std_logic;
          change_c : out std_logic;
          sel_memdata : out std_logic;
          r_sjmp_addr : out std_logic_vector (15 downto 0));
end decoder_unit;

architecture behavioral of decoder_unit is
begin
    sr <= ir (9 downto 8);
    dr <= ir (11 downto 10);
    sel_memdata <= ir (15) and ir (14) and (not ir (13));
    change_z <= not ir (15) and ir (1);
    change_c <= not ir (15) and ir (2);

    DRWr_proc : process (ir)
    begin
        if ir (15) = '0' then
            if ir (0) = '1' then
                DRWr <= '1';
            else
                DRWr <= '0';
            end if;
        elsif ir (14) = '1' and ir (13) = '0' then
            DRWr <= '1';
        else
            DRWr <= '0';
        end if;
    end process;

    sjmp_addr_proc : process (ir)
    begin
        if ir (7) = '1' then
            r_sjmp_addr <= "11111111" & ir (7 downto 0);
        else
            r_sjmp_addr <= "00000000" & ir (7 downto 0);
        end if;
    end process;

    m_instruct : process (ir)
    begin
        case ir (15 downto 12) is
            when "1000" | "1100" =>
                mem_write <= '1';
                dw_instruct <= '0';
            when "1110" =>
                mem_write <= '1';
                dw_instruct <= '0';
            when others =>
                mem_write <= '0';
                dw_instruct <= '0';
        end case;
    end process;

    alu_op_code_proc : process (ir)
    begin
        if ir (15) = '0' then
            op_code <= ir (14 downto 12);
        else
            op_code <= "111";
        end if;
    end process;

    instruct_proc : process (ir)
    begin
        case ir (15 downto 12) is
            when "1000" =>
                zj_instruct <= '0';
                cj_instruct <= '0';
                lj_instruct <= '1';
            when "1001" =>
                zj_instruct <= '0';
                cj_instruct <= '1';
                lj_instruct <= '0';
            when "1010" =>
                zj_instruct <= '1';
                cj_instruct <= '0';
                lj_instruct <= '0';
            when others =>
                zj_instruct <= '0';
                cj_instruct <= '0';
                lj_instruct <= '0';
        end case;
    end process;
end behavioral;

        

