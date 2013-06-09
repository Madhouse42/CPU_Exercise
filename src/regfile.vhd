library ieee;
use ieee.std_logic_1164.all;
use work.exp_cpu_components.all;

entity regfile is
port (  DR: 	  in std_logic_vector(3 downto 0);  --Ŀ�ļĴ�����
		SR: 	  in std_logic_vector(3 downto 0);  --Դ�Ĵ�����
		reset: 	  in std_logic;
		write: 	  in std_logic;	--д�Ĵ����ź�
		clk:	  in std_logic;	
		d_input:  in  std_logic_vector(15 downto 0);  --д�Ĵ���������
		change_z: in std_logic;			--���Ϊ1������������z��־
		change_c: in std_logic;
	    c_in:     in std_logic;
	    z_in:     in std_logic;
		output_DR:  out std_logic_vector(15 downto 0);
		output_SR:  out std_logic_vector(15 downto 0);
		c_out:	    out std_logic;
		z_out:	    out std_logic;
        c_flag : out std_logic;
        z_flag : out std_logic;
        r0, r1, r2, r3: out std_logic_vector (15 downto 0)
	  );
end regfile;


architecture struct of regfile is

signal reg00, reg01, reg02,reg03: std_logic_vector(15 downto 0);
signal sel00, sel01, sel02, sel03: std_logic;

begin
    r0 <= reg00;
    r1 <= reg01;
    r2 <= reg02;
    r3 <= reg03;

z_c_proc: process(reset,clk)  --��ָ��ִ�н������z��c��־���д���
begin
   if reset = '0' then
		z_out <= '0';
		c_out <= '0';
	elsif clk'event and clk = '0' then
	    if change_z = '1' then
			z_out <= z_in;
			z_flag <= z_in;
        end if;
		if change_c = '1' then
			c_out <= c_in;
			c_flag <= c_in;
        end if;
	end if;
end process;

Areg00: reg port map(				--�Ĵ���R0
		reset		=> reset,
		d_input		=> d_input,
		clk			=> clk,		
		write		=> write,
	    sel			=> sel00,	
		q_output	=> reg00
		);

Areg01: reg port map(				--�Ĵ���R1
		reset		=> reset,
		d_input		=> d_input,
		clk			=> clk,		
		write		=> write,
	    sel			=> sel01,	
		q_output	=> reg01	
		);

Areg02: reg port map(				--�Ĵ���R2
		reset		=> reset,
		d_input		=> d_input,
		clk			=> clk,		
		write		=> write,
	    sel			=> sel02,	
		q_output	=>  reg02
		);

Areg03: reg port map(				--�Ĵ���R3
		reset		=> reset,
		d_input		=> d_input,
		clk			=> clk,		
		write		=> write,
	    sel			=> sel03,	
		q_output	=> reg03
		);

des_decoder: decoder_2_to_4 port map(	--2 �� 4������
		sel 	=> DR,
    	sel00 	=> sel00,
		sel01 	=> sel01,
		sel02 	=> sel02,
		sel03 	=> sel03 
		);

muxA: mux_4_to_1 port map(				--Ŀ�ļĴ�������4ѡ1ѡ����
		input0  => reg00,
    	input1  => reg01,
		input2  => reg02,
		input3  => reg03,
		sel     => DR,
		output => output_DR
		);
	
muxB: mux_4_to_1 port map(				--Դ�Ĵ�������4ѡ1ѡ����
		input0 	=> reg00,
   	 	input1 	=> reg01,
		input2 	=> reg02,
		input3 	=> reg03,
		sel 	=> SR,
		output => output_SR
		);

end struct;

