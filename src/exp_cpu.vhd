library ieee;
use ieee.std_logic_1164.all;
use work.exp_cpu_components.all;

entity exp_cpu is port
	(
	clk : in std_logic;              -- //ϵͳʱ��
	reset : in std_logic;              -- //ϵͳ��λ�ź�
	WE : out std_logic;    				-- //��д�ڴ�����ź�
	AR : out std_logic_vector(15 downto 0);     -- //��д�ڴ��ַ
	OB : inout std_logic_vector(15 downto 0)  	-- //�ⲿ����
    reg_sel : in std_logic (5 downto 0);
    reg_content : out std_logic (15 downto 0);
    c_flag : out std_logic;
    z_flag : out std_logic
	);
end exp_cpu;

architecture behav of exp_cpu is
	-- instru_fetch out
signal t1, t2, t3 : std_logic;
signal pc, pc_inc, IR : std_logic_vector(15 downto 0);
	-- decoder_unit out
signal SR, DR : std_logic_vector(3 downto 0);
signal op_code : std_logic_vector(4 downto 0);
signal zj_instruct, cj_instruct, lj_instruct,
       nzj_instruct, ncj_instruct, rj_instruct : std_logic;
signal DRWr, Mem_Write, dw_instruct, change_z : std_logic;
signal change_c, sel_memdata : std_logic;
signal r_sjmp_addr : std_logic_vector(15 downto 0);
	-- exe_unit out
signal c_tmp, z_tmp, c_z_j_flag : std_logic;
signal Mem_Addr, result, sjmp_addr : std_logic_vector(15 downto 0);
	-- memory out
signal data_read, DR_data_out : std_logic_vector(15 downto 0);
	-- regfile out
signal r0, r1, r2, r3 : std_logic_vector (15 downto 0);
signal output_DR, output_SR : std_logic_vector(15 downto 0);
signal c_out, z_out : std_logic;  

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
                reg_content <= "0000000" & t3 & "000" & t2 "000" & t1;
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
		data_read => data_read,  -- �洢����������
		lj_instruct => lj_instruct, -- ����decoder�ĳ�ת��ָ���־
		DW_instruct => DW_instruct, -- ����decoder��˫��ָ���־
		c_z_j_flag => c_z_j_flag, -- Ϊ1ʱ��������ת�ƣ�����EXE
		sjmp_addr => sjmp_addr, -- ����ת��ָ���ת�Ƶ�ַ������EXE
		t1 => t1,
        t2 => t2,
		t3 => t3,
		pc => pc,
		pc_inc => pc_inc,
		IR => IR
		); 

G_DECODER : decoder_unit port map
	   (IR => IR,	-- ����instru_fetch
		SR => SR,   -- Դ�Ĵ�����
		DR => DR,	-- Ŀ�ļĴ�����
		op_code => op_code,  -- ALU����Ĳ�����
		zj_instruct => zj_instruct, -- Ϊ1ʱ�����Z=1��ת��ָ��
		cj_instruct => cj_instruct, -- Ϊ1ʱ�����C=1��ת��ָ��
		lj_instruct => lj_instruct, -- Ϊ1ʱ����������ת��ָ��
        rj_instruct => rj_instruct,
        nzj_instruct => nzj_instruct,
        ncj_instruct => ncj_instruct,
		DRWr => DRWr,  -- Ϊ1ʱ��t3�½���дDR�Ĵ���,����regfile
		Mem_Write => Mem_Write,  -- Ϊ1ʱ�Դ洢������д������
		dw_instruct => dw_instruct, -- Ϊ1ʱ��˫��ָ��
		change_z => change_z,  -- Ϊ1ʱ��t3�½��ظ���ָ��ִ�н����Z��־
		change_c => change_c,  -- Ϊ1ʱ��t3�½��ظ���ָ��ִ�н����Z��־
		sel_memdata => sel_memdata,  -- Ϊ1ʱ�洢���Ķ���������Ϊд��DR������
		r_sjmp_addr => r_sjmp_addr -- ���ת�Ƶ�ַ
		);

G_EXE : exe_unit port map
		(
	  	t1 => t1,
		op_code => op_code, -- ALU����Ĳ����룬����decoder
		zj_instruct => zj_instruct, -- Ϊ1ʱ�����Z=1��ת��ָ�����decoder
	  	cj_instruct => cj_instruct, -- Ϊ1ʱ�����C=1��ת��ָ�����decoder
        nzj_instruct => nzj_instruct,
        ncj_instruct => ncj_instruct,
        rj_instruct => rj_instruct,
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
	    );

G_MEMORY : memory_unit port map
	   (reset => reset,
		clk   => clk,
		t3    => t3, 
		Mem_addr  => Mem_addr,  -- �洢����ַ������exe_unit
		Mem_Write => Mem_Write, -- �洢��д������decoder_unit
		sel_memdata => sel_memdata,  -- Ϊ1ʱ�洢���Ķ���������Ϊд��DR�����ݣ�����decoder

		SR_data => output_SR,-- д�洢��������,����regfile
		result => result, -- ������������exe_unit
		rw => WE,  -- �洢����д�źţ�����оƬ�ⲿ
		ob => ob,  -- �洢���������ߣ���оƬ�ⲿ�洢��������������
		ar => AR,  -- �洢����ַ������оƬ�ⲿ�ʹ洢����ַ��������
		data_read   => data_read, -- �Ӵ洢��������ָ�����instru_fetch
		DR_data_out => DR_data_out -- д��DR�����ݣ�����regfile
		);

G_REGFILE : regfile port map
 	   (DR => DR,  -- DR�Ĵ����ţ�����decoder
		SR => SR,  -- SR�Ĵ����ţ�����decoder
		reset => reset,
		write => DRWr, -- �Ĵ���д�����źţ�����decoder                          
		clk => t3,	-- �Ĵ���д�����壬����instru_fetch���½���д��
		d_input => DR_data_out, -- д��Ĵ��������ݣ�����memory
		change_z => change_z, -- Ϊ1ʱ��t4�½��ظ���Z_tmp��Z��־,����decoder
		change_c => change_c, -- Ϊ1ʱ��t4�½��ظ���C_tmp��C��־,����decoder
	    c_in => c_tmp, -- ����ָ��õ���c,����decoder
	    z_in => z_tmp, -- ����ָ��õ���c,����decoder

		output_DR => output_DR,   -- DR�Ĵ������ݣ�����exe��memory     
		output_SR => output_SR,   -- SR�Ĵ������ݣ�����exe
		c_out => c_out,  -- C��־������exe��exp
		z_out => z_out   -- Z��־������exe��exp
	    );

end behav;

