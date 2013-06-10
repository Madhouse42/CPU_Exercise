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
signal reset_out, clk_out, start_out : std_logic;
signal sel_out : std_logic_vector (3 downto 0);

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
                reg_content <= '0' & start_out & reset_out & clk_out & "000" & t3 & "000" & t2 & "000" & t1;
            when "111110" =>
                reg_content <= pc;
            when "111111" =>
                reg_content <= ir;
            when others =>
                reg_content <= x"ffff";
        end case;
    end process;

G_INSTRU_FETCH : instru_fetch port map
	   (reset => reset,
		clk => clk,		
		data_read => data_read,
		lj_instruct => lj_instruct,
		DW_instruct => DW_instruct,
		c_z_j_flag => c_z_j_flag,
		sjmp_addr => sjmp_addr,
		t1 => t1,
        t2 => t2,
		t3 => t3,
		pc => pc,
		pc_inc => pc_inc,
		IR => IR,
		clk_out => clk_out,
		reset_out => reset_out,
		start_out => start_out
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

G_EXE : exe_unit port map
		(
	  	t1 => t1,
		op_code => op_code,
		zj_instruct => zj_instruct,
	  	cj_instruct => cj_instruct,
        nzj_instruct => nzj_instruct,
        ncj_instruct => ncj_instruct,
        rj_instruct => rj_instruct,
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

