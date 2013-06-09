library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.exp_cpu_components.all;

entity decoder_unit is
    port (IR : in std_logic_vector (15 downto 0);
          SR : out std_logic_vector (3 downto 0);
          DR : out std_logic_vector (3 downto 0);
          op_code : out std_logic_vector (4 downto 0);
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
    alu_instruction : variable std_logic_vector (2 downto 0);
begin
    sr <= ir (7 downto 4);
    dr <= ir (3 downto 0);

    sel_memdata <= ir (15) and
                   (not ir (14)) and
                   (not ir (13)) and
                   (not ir (12));

    alu_instruction <= (not ir (15)) and
                       (not ir (14)) and
                       (not ir (13));
    change_z <= alu_instruction and
                (not (ir (12) and
                      ir (11) and
                      ir (10) and
                      ir (9) and
                      ir (8));
    change_c <= alu_instruction and
                ((not ir (0)) or
                 ((not ir (12)) and
                  ir (11) and
                  ir (10)));

    DRWr_proc : process (ir)
    begin
        if ir (15 downto 13) = "000" then -- 算术指令，包括mvrr
            if ir (12) = '1' then -- modifiable
                drwr <= '1';
            else
                drwr <= '0';
            end if;
        elsif ir (15 downto 12) = "1000" then
            if ir (11 downto 8) = "0011" then -- strr
                drwr <= '0';
            else -- mvrd与ldrr
                drwr <= '1';
            end if;
        else
            drwr <= '0';
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
        if ir (15 downto 12) = "1000" then
            case ir (11 downto 8) is
                when "0001" =>
                    mem_write <= '0';
                    dw_instruct <= '1';
                when "0011" =>
                    mem_write <= '1';
                    dw_instruct <= '0';
                when others =>
                    mem_write <= '0';
                    dw_instruct <= '0';
            end case;
        elsif ir (15 downto 12) = "0100" then
            if ir (11 downto 8) = "1111" then
                mem_write <= '0';
                dw_instruct <= '1';
            end if;
        end if;
    end process;

    alu_op_code_proc : process (ir)
    begin
        if ir (15 downto 13) = "000" then
            op_code <= ir (12 downto 8);
        else
            op_code <= "11111";
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


