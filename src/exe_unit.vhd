library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.exp_cpu_components.all;

entity exe_unit is
	port(
<<<<<<< HEAD
	  	t1: in std_logic;
		op_code:	in std_logic_vector(4 downto 0);
		jz_instruct: in std_logic;
	  	jc_instruct: in std_logic;
        jnz_instruct: in std_logic;
        jnc_instruct: in std_logic;
        jr_instruct: in std_logic;
	    pc: in std_logic_vector(15 downto 0);
		pc_inc:	in std_logic_vector(15 downto 0);
		c_in: in std_logic;  --ÒÔÇ°Ö¸Áî²úÉúµÄ½øÎ»C
	    z_in: in std_logic;  --ÒÔÇ°Ö¸Áî²úÉúµÄZ
		Mem_Write: in std_logic;  --Îª1Ê±£¬Ð´´æ´¢Æ÷
		c_tmp:	out std_logic;
		z_tmp:	out std_logic;
		c_z_j_flag: out std_logic; --Îª1Ê±½øÐÐÌõ¼þ×ªÒÆ
		r_sjmp_addr:	in std_logic_vector(15 downto 0); --Ïà¶Ô×ªÒÆµØÖ·
		DW_instruct: in std_logic;
		sjmp_addr:	out std_logic_vector(15 downto 0); --Ìõ¼þ×ªÒÆÖ¸ÁîµÄ×ªÒÆµØÖ·
		SR_data: in std_logic_vector(15 downto 0);
		DR_data: in std_logic_vector(15 downto 0);
		Mem_Addr: out std_logic_vector(15 downto 0);
		result: out std_logic_vector(15 downto 0)  --ÔËËã½á¹û
=======
	  	t1 : in std_logic;
		op_code : in std_logic_vector(4 downto 0);
		zj_instruct : in std_logic;
	  	cj_instruct : in std_logic;
        nzj_instruct : in std_logic;
        ncj_instruct : in std_logic;
        rj_instruct : in std_logic;
	    pc : in std_logic_vector(15 downto 0);
		pc_inc : in std_logic_vector(15 downto 0);
		c_in : in std_logic;  --ä»¥å‰æŒ‡ä»¤äº§ç”Ÿçš„è¿›ä½C
	    z_in : in std_logic;  --ä»¥å‰æŒ‡ä»¤äº§ç”Ÿçš„Z
		Mem_Write : in std_logic;  --ä¸º1æ—¶ï¼Œå†™å­˜å‚¨å™¨
		c_tmp : out std_logic;
		z_tmp : out std_logic;
		c_z_j_flag : out std_logic; --ä¸º1æ—¶è¿›è¡Œæ¡ä»¶è½¬ç§»
		r_sjmp_addr : in std_logic_vector(15 downto 0); --ç›¸å¯¹è½¬ç§»åœ°å€
		DW_instruct : in std_logic;
		sjmp_addr : out std_logic_vector(15 downto 0); --æ¡ä»¶è½¬ç§»æŒ‡ä»¤çš„è½¬ç§»åœ°å€
		SR_data : in std_logic_vector(15 downto 0);
		DR_data : in std_logic_vector(15 downto 0);
		Mem_Addr : out std_logic_vector(15 downto 0);
<<<<<<< HEAD
		result : out std_logic_vector(15 downto 0)  --ÔËËã½á¹û
>>>>>>> 811a3297e5ed6406723e9cfa0e3bebbed57b8eac
=======
		result : out std_logic_vector(15 downto 0)  --è¿ç®—ç»“æžœ
>>>>>>> a55e84249e88c48e7324ae8dd14b7a2da6fa3a3b
	    );

end exe_unit;

architecture behav of exe_unit is
signal A, B : std_logic_vector(15 downto 0);
signal result_t : std_logic_vector(16 downto 0);

begin
<<<<<<< HEAD
c_z_j_flag <= (c_in and jc_instruct) or
              (z_in and jz_instruct) or
              ((not c_in) and jnc_instruct) or
              ((not z_in) and jnz_instruct) or
              jr_instruct;
=======
c_z_j_flag <= ((not c_in) and ncj_instruct) or
              ((not z_in) and nzj_instruct) or
              (c_in and cj_instruct) or
              (z_in and zj_instruct) or
              rj_instruct;

>>>>>>> 811a3297e5ed6406723e9cfa0e3bebbed57b8eac
A <= DR_data;
B <= SR_data;

sjmp_addr <= pc_inc + r_sjmp_addr;	

Mem_Addr_proc : process(t1, SR_data, pc, dw_instruct)
begin
	if t1 = '1' then
		Mem_Addr <= pc;
	else
		if dw_instruct = '1' then
			Mem_Addr <= pc_inc;
		elsif Mem_Write = '1' then
			Mem_Addr <= DR_data;
		else
			Mem_Addr <= SR_data;
		end if;
	end if;
end process;

alu_proc : process(op_code, A, B)
begin
	case op_code is
		when "10000" => -- add
			result_t <= ('0' & A) + ('0' & B);
		when "11000" => -- inc
			result_t <= ('0' & A) + '1';
<<<<<<< HEAD
        when "10100" => -- adc
            result_t <= ('0' & A) + ('0' & B) + c_in;
		when "10010" => -- sub
			result_t <= ('0' & A) - ('0' & B);
		when "00010" => -- cmp
			result_t <= ('0' & A) - ('0' & B);
		when "11010" => -- dec
			result_t <= ('0' & A) - '1';
        when "10110" => -- sbb
            result_t <= ('0' & A) - ('0' & B) - c_in;
        when "11110" => -- shl dr
            result_t <= A & '0';
        when "11111" => -- shr dr
            result_t <= "00" & A(15 downto 1);
        when "10001" => -- and
            result_t <= '0' & (A and B);
        when "00001" => -- test
            result_t <= '0' & (A and B);
        when "10011" => -- or
            result_t <= '0' & (A or B);
        when "10111" => -- xor
            result_t <= '0' & (A xor B);
        when "11001" => -- not
            result_t <= '0' & (not A);
        when "11011" => -- mvrr
            result_t <= c_in & B;
=======
		when "10100" => -- adc
            result_t <= ('0' & A) + ('0' & B) + c_in;
        when "10010" | "00010" => -- sub | cmp
			result_t <= ('0' & A) - ('0' & B);
		when "10110" => -- sbb
			result_t <= ('0' & A) -  ('0' & B) - c_in;
		when "11010" => -- dec
			result_t <= ('0' & A) - '1';
        when "01101" => -- shl
            result_t <= B & '0';
        when "01111" => -- shr
            result_t <= B (0) & c_in & B (15 downto 1);
        when "10001" | "00001" => -- and | test
            result_t <= c_in & (A and B);
        when "10011" => -- or
            result_t <= c_in & (A or B);
        when "10111" => -- xor
            result_t <= c_in & (A xor B);
        when "11001" => -- not
            result_t <= c_in & (not B);
>>>>>>> 811a3297e5ed6406723e9cfa0e3bebbed57b8eac
		when others =>
			null;
	end case;
end process;

result <= result_t(15 downto 0);
c_tmp <= result_t(16);
z_tmp <= (not result_t(15)) and (not result_t(14)) and
		 (not result_t(13)) and (not result_t(12)) and
		 (not result_t(11)) and (not result_t(10)) and
		 (not result_t(9)) and (not result_t(8)) and
		 (not result_t(7)) and (not result_t(6)) and
		 (not result_t(5)) and (not result_t(4)) and
		 (not result_t(3)) and (not result_t(2)) and
		 (not result_t(1)) and (not result_t(0));

end behav;
<<<<<<< HEAD
=======

>>>>>>> 811a3297e5ed6406723e9cfa0e3bebbed57b8eac
