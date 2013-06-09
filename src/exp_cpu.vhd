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
		data_read => data_read,  --�洢����������
		jmp_instruct => jmp_instruct, --����decoder�ĳ�ת��ָ���־
		DW_instruct => DW_instruct, --����decoder��˫��ָ���־
		c_z_j_flag => c_z_j_flag, --Ϊ1ʱ��������ת�ƣ�����EXE
		sjmp_addr => sjmp_addr, --����ת��ָ���ת�Ƶ�ַ������EXE
=======
		data_read => data_read,  -- �洢����������
		lj_instruct => lj_instruct, -- ����decoder�ĳ�ת��ָ���־
		DW_instruct => DW_instruct, -- ����decoder��˫��ָ���־
		c_z_j_flag => c_z_j_flag, -- Ϊ1ʱ��������ת�ƣ�����EXE
		sjmp_addr => sjmp_addr, -- ����ת��ָ���ת�Ƶ�ַ������EXE
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
	   (IR => IR,	--����instru_fetch
		SR => SR,   --Դ�Ĵ�����
		DR => DR,	--Ŀ�ļĴ�����
		op_code => op_code,  --ALU����Ĳ�����
		jnz_instruct => jnz_instruct, --Ϊ1ʱ�����Z=0��ת��ָ��
		jnc_instruct => jnc_instruct, --Ϊ1ʱ�����C=0��ת��ָ��
		jmp_instruct => jmp_instruct, --Ϊ1ʱ����������ת��ָ��
        jz_instruct => jz_instruct,
        jc_instruct => jc_instruct,
		DRWr => DRWr,  --Ϊ1ʱ��t3�½���дDR�Ĵ���,����regfile
		Mem_Write => Mem_Write,  --Ϊ1ʱ�Դ洢������д������
		dw_instruct => dw_instruct, --Ϊ1ʱ��˫��ָ��
		change_z => change_z,  --Ϊ1ʱ��t3�½��ظ���ָ��ִ�н����Z��־
		change_c => change_c,  --Ϊ1ʱ��t3�½��ظ���ָ��ִ�н����Z��־
		sel_memdata => sel_memdata,  --Ϊ1ʱ�洢���Ķ���������Ϊд��DR������
		r_sjmp_addr => r_sjmp_addr --���ת�Ƶ�ַ
		);

G_EXE:	exe_unit port map
		(
	  	t1 => t1,
		op_code => op_code, --ALU����Ĳ����룬����decoder
		jnz_instruct => jnz_instruct, --Ϊ1ʱ�����Z=1��ת��ָ�����decoder
	  	jnc_instruct => jnc_instruct, --Ϊ1ʱ�����C=1��ת��ָ�����decoder
        jc_instruct => jc_instruct,
        jr_instruct => jr_instruct,
        jz_instruct => jz_instruct,
	    pc => pc,  --����instru_fetch
		pc_inc => pc_inc, --����instru_fetch
		c_in => c_out,--��ǰָ������Ľ�λC������regfile
	    z_in => z_out,  --��ǰָ�������Z������regfile
		Mem_Write => Mem_Write, --�洢��д������decoder_unit
		c_tmp => c_tmp, --����ָ�������Z��־����regfile
		z_tmp => z_tmp, --����ָ�������Z��־����regfile
		c_z_j_flag => c_z_j_flag, --Ϊ1ʱ��������ת�ƣ�����instru_fetch
		r_sjmp_addr => r_sjmp_addr,  --���ת�Ƶ�ַ������decoder
		dw_instruct => dw_instruct,  --˫��ָ���־������decoder������
		sjmp_addr =>  sjmp_addr,--����ת��ָ���ת�Ƶ�ַinstru_fetch
		SR_data => output_SR,  --SR�Ĵ���ֵ������regfile
		DR_data => output_DR,  --SR�Ĵ���ֵ������regfile
		Mem_Addr => Mem_Addr, --�洢����ַ������memory
		result => result  --������������regfile
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
	    pc => pc,  -- ����instru_fetch
		pc_inc => pc_inc, -- ����instru_fetch
		c_in => c_out,-- ��ǰָ������Ľ�λC������regfile
	    z_in => z_out,  -- ��ǰָ�������Z������regfile
		Mem_Write => Mem_Write, -- �洢��д������decoder_unit
		c_tmp => c_tmp, -- ����ָ�������Z��־����regfile
		z_tmp => z_tmp, -- ����ָ�������Z��־����regfile
		c_z_j_flag => c_z_j_flag, -- Ϊ1ʱ��������ת�ƣ�����instru_fetch
		r_sjmp_addr => r_sjmp_addr,  -- ���ת�Ƶ�ַ������decoder
		dw_instruct => dw_instruct,  -- ˫��ָ���־������decoder������
		sjmp_addr =>  sjmp_addr,-- ����ת��ָ���ת�Ƶ�ַinstru_fetch
		SR_data => output_SR,  -- SR�Ĵ���ֵ������regfile
		DR_data => output_DR,  -- SR�Ĵ���ֵ������regfile
		Mem_Addr => Mem_Addr, -- �洢����ַ������memory
		result => result  -- ������������regfile
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
