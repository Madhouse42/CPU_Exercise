library ieee;
use ieee.std_logic_1164.all;
use work.exp_cpu_components.all;

entity exp_cpu is port
	(
	clk : in std_logic;
	reset : in std_logic;
	WE : out std_logic;
	AR : out std_logic_vector(15 downto 0);
	OB : inout std_logic_vector(15 downto 0);
    reg_sel : in std_logic_vector (5 downto 0);
    reg_content : out std_logic_vector (15 downto 0);
    c_flag : out std_logic;
    z_flag : out std_logic
	);
end exp_cpu;

architecture behav of exp_cpu is
<<<<<<< HEAD
<<<<<<< HEAD
	--instru_fetch out
signal t1,t3: std_logic;
signal pc,pc_inc,IR: std_logic_vector(15 downto 0);
	--decoder_unit out
signal SR,DR: std_logic_vector(3 downto 0);
signal op_code:	std_logic_vector(4 downto 0);
signal jz_instruct,jc_instruct,
       jmp_instruct,jnz_instruct,
       jnc_instruct,jr_instruct: std_logic;
signal DRWr,Mem_Write,dw_instruct,change_z:  std_logic;
signal change_c,sel_memdata: std_logic;
signal r_sjmp_addr: std_logic_vector(15 downto 0);
	--exe_unit out
signal c_tmp,z_tmp,c_z_j_flag: std_logic;
signal Mem_Addr,result,sjmp_addr: std_logic_vector(15 downto 0);
	--memory out
signal data_read,DR_data_out:  std_logic_vector(15 downto 0);
	--regfile out
signal output_DR,output_SR:  std_logic_vector(15 downto 0);
signal c_out,z_out:	 std_logic;  
=======
	-- instru_fetch out
=======
	
>>>>>>> a55e84249e88c48e7324ae8dd14b7a2da6fa3a3b
signal t1, t2, t3 : std_logic;
signal pc, pc_inc, IR : std_logic_vector(15 downto 0);
	
signal SR, DR : std_logic_vector(3 downto 0);
signal op_code : std_logic_vector(4 downto 0);
signal zj_instruct, cj_instruct, lj_instruct,
       nzj_instruct, ncj_instruct, rj_instruct : std_logic;
signal DRWr, Mem_Write, dw_instruct, change_z : std_logic;
signal change_c, sel_memdata : std_logic;
signal r_sjmp_addr : std_logic_vector(15 downto 0);
	
signal c_tmp, z_tmp, c_z_j_flag : std_logic;
signal Mem_Addr, result, sjmp_addr : std_logic_vector(15 downto 0);
	
signal data_read, DR_data_out : std_logic_vector(15 downto 0);
	
signal r0, r1, r2, r3 : std_logic_vector (15 downto 0);
signal output_DR, output_SR : std_logic_vector(15 downto 0);
signal c_out, z_out : std_logic;  

>>>>>>> 811a3297e5ed6406723e9cfa0e3bebbed57b8eac
begin
    test_out : process(reg_sel)
    begin
        case reg_sel is
            when "000000" =>
                reg_content <= r0;
            when "000001" =>
                reg_content <= r1;
            when "000010" =>
                reg_content <= r2;
            when "000011" =>
                reg_content <= r3;
            when "000100" =>
                reg_content <= "0000000" & t3 & "000" & t2 & "000" & t1;
            when "111110" =>
                reg_content <= pc;
            when "111111" =>
                reg_content <= ir;
            when others =>
                reg_content <= x"0000";
        end case;
    end process;

G_INSTRU_FETCH : instru_fetch port map
	   (reset => reset,
		clk => clk,		
<<<<<<< HEAD
<<<<<<< HEAD
		data_read => data_read,  --存储器读出的数
		jmp_instruct => jmp_instruct, --来自decoder的长转移指令标志
		DW_instruct => DW_instruct, --来自decoder的双字指令标志
		c_z_j_flag => c_z_j_flag, --为1时进行条件转移，来自EXE
		sjmp_addr => sjmp_addr, --条件转移指令的转移地址，来自EXE
=======
		data_read => data_read,  -- 存储器读出的数
		lj_instruct => lj_instruct, -- 来自decoder的长转移指令标志
		DW_instruct => DW_instruct, -- 来自decoder的双字指令标志
		c_z_j_flag => c_z_j_flag, -- 为1时进行条件转移，来自EXE
		sjmp_addr => sjmp_addr, -- 条件转移指令的转移地址，来自EXE
>>>>>>> 811a3297e5ed6406723e9cfa0e3bebbed57b8eac
=======
		data_read => data_read,
		lj_instruct => lj_instruct,
		DW_instruct => DW_instruct,
		c_z_j_flag => c_z_j_flag,
		sjmp_addr => sjmp_addr,
>>>>>>> a55e84249e88c48e7324ae8dd14b7a2da6fa3a3b
		t1 => t1,
        t2 => t2,
		t3 => t3,
		pc => pc,
		pc_inc => pc_inc,
		IR => IR
		); 

G_DECODER : decoder_unit port map
	   (IR => IR,
		SR => SR,
		DR => DR,
		op_code => op_code,
		zj_instruct => zj_instruct,
		cj_instruct => cj_instruct,
		lj_instruct => lj_instruct,
        rj_instruct => rj_instruct,
        nzj_instruct => nzj_instruct,
        ncj_instruct => ncj_instruct,
		DRWr => DRWr,
		Mem_Write => Mem_Write,
		dw_instruct => dw_instruct,
		change_z => change_z,
		change_c => change_c,
		sel_memdata => sel_memdata,
		r_sjmp_addr => r_sjmp_addr
		);
<<<<<<< HEAD
		
G_DECODER:	decoder_unit port map
	   (IR => IR,	--来自instru_fetch
		SR => SR,   --源寄存器号
		DR => DR,	--目的寄存器号
		op_code => op_code,  --ALU运算的操作码
		jnz_instruct => jnz_instruct, --为1时是如果Z=0则转移指令
		jnc_instruct => jnc_instruct, --为1时是如果C=0则转移指令
		jmp_instruct => jmp_instruct, --为1时是无条件长转移指令
        jz_instruct => jz_instruct,
        jc_instruct => jc_instruct,
		DRWr => DRWr,  --为1时在t3下降沿写DR寄存器,送往regfile
		Mem_Write => Mem_Write,  --为1时对存储器进行写操作。
		dw_instruct => dw_instruct, --为1时是双字指令
		change_z => change_z,  --为1时在t3下降沿根据指令执行结果置Z标志
		change_c => change_c,  --为1时在t3下降沿根据指令执行结果置Z标志
		sel_memdata => sel_memdata,  --为1时存储器的读出数据作为写入DR的数据
		r_sjmp_addr => r_sjmp_addr --相对转移地址
		);

G_EXE:	exe_unit port map
		(
	  	t1 => t1,
		op_code => op_code, --ALU运算的操作码，来自decoder
		jnz_instruct => jnz_instruct, --为1时是如果Z=1则转移指令，来自decoder
	  	jnc_instruct => jnc_instruct, --为1时是如果C=1则转移指令，来自decoder
        jc_instruct => jc_instruct,
        jr_instruct => jr_instruct,
        jz_instruct => jz_instruct,
	    pc => pc,  --来自instru_fetch
		pc_inc => pc_inc, --来自instru_fetch
		c_in => c_out,--以前指令产生的进位C，来自regfile
	    z_in => z_out,  --以前指令产生的Z，来自regfile
		Mem_Write => Mem_Write, --存储器写，来自decoder_unit
		c_tmp => c_tmp, --本条指令产生的Z标志送往regfile
		z_tmp => z_tmp, --本条指令产生的Z标志送往regfile
		c_z_j_flag => c_z_j_flag, --为1时进行条件转移，送往instru_fetch
		r_sjmp_addr => r_sjmp_addr,  --相对转移地址，来自decoder
		dw_instruct => dw_instruct,  --双字指令标志，来自decoder，送往
		sjmp_addr =>  sjmp_addr,--条件转移指令的转移地址instru_fetch
		SR_data => output_SR,  --SR寄存器值，来自regfile
		DR_data => output_DR,  --SR寄存器值，来自regfile
		Mem_Addr => Mem_Addr, --存储器地址，送往memory
		result => result  --运算结果，送往regfile
=======

G_EXE : exe_unit port map
		(
	  	t1 => t1,
		op_code => op_code,
		zj_instruct => zj_instruct,
	  	cj_instruct => cj_instruct,
        nzj_instruct => nzj_instruct,
        ncj_instruct => ncj_instruct,
        rj_instruct => rj_instruct,
<<<<<<< HEAD
	    pc => pc,  -- 来自instru_fetch
		pc_inc => pc_inc, -- 来自instru_fetch
		c_in => c_out,-- 以前指令产生的进位C，来自regfile
	    z_in => z_out,  -- 以前指令产生的Z，来自regfile
		Mem_Write => Mem_Write, -- 存储器写，来自decoder_unit
		c_tmp => c_tmp, -- 本条指令产生的Z标志送往regfile
		z_tmp => z_tmp, -- 本条指令产生的Z标志送往regfile
		c_z_j_flag => c_z_j_flag, -- 为1时进行条件转移，送往instru_fetch
		r_sjmp_addr => r_sjmp_addr,  -- 相对转移地址，来自decoder
		dw_instruct => dw_instruct,  -- 双字指令标志，来自decoder，送往
		sjmp_addr =>  sjmp_addr,-- 条件转移指令的转移地址instru_fetch
		SR_data => output_SR,  -- SR寄存器值，来自regfile
		DR_data => output_DR,  -- SR寄存器值，来自regfile
		Mem_Addr => Mem_Addr, -- 存储器地址，送往memory
		result => result  -- 运算结果，送往regfile
>>>>>>> 811a3297e5ed6406723e9cfa0e3bebbed57b8eac
=======
	    pc => pc,
		pc_inc => pc_inc,
		c_in => c_out,
	    z_in => z_out,
		Mem_Write => Mem_Write,
		c_tmp => c_tmp,
		z_tmp => z_tmp,
		c_z_j_flag => c_z_j_flag,
		r_sjmp_addr => r_sjmp_addr,
		dw_instruct => dw_instruct,
		sjmp_addr =>  sjmp_addr,
		SR_data => output_SR,
		DR_data => output_DR,
		Mem_Addr => Mem_Addr,
		result => result
>>>>>>> a55e84249e88c48e7324ae8dd14b7a2da6fa3a3b
	    );

G_MEMORY : memory_unit port map
	   (reset => reset,
		clk   => clk,
		t3    => t3, 
		Mem_addr  => Mem_addr,  
		Mem_Write => Mem_Write, 
		sel_memdata => sel_memdata,  

		SR_data => output_SR,
		result => result, 
		rw => WE,  
		ob => ob,  
		ar => AR,  
		data_read   => data_read, 
		DR_data_out => DR_data_out 
		);

G_REGFILE : regfile port map
 	   (DR => DR,  
		SR => SR,  
		reset => reset,
		write => DRWr, 
		clk => t3,	
		d_input => DR_data_out, 
		change_z => change_z, 
		change_c => change_c, 
	    c_in => c_tmp, 
	    z_in => z_tmp, 

		output_DR => output_DR,   
		output_SR => output_SR,   
		c_out => c_out,  
		z_out => z_out,   
		r0 => r0,
		r1 => r1,
		r2 => r2,
		r3 => r3,
		c_flag => c_flag,
		z_flag => z_flag
	    );

end behav;
<<<<<<< HEAD
=======

>>>>>>> 811a3297e5ed6406723e9cfa0e3bebbed57b8eac
