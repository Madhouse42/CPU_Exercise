library ieee;
use ieee.std_logic_1164.all;
use work.exp_cpu_components.all;

entity regfile is
<<<<<<< HEAD
<<<<<<< HEAD
Port (  DR: 	  in std_logic_vector(3 downto 0);  --Ŀ�ļĴ�����
		SR: 	  in std_logic_vector(3 downto 0);  --Դ�Ĵ�����   
=======
port (  DR: 	  in std_logic_vector(3 downto 0);  --Ŀ�ļĴ�����
		SR: 	  in std_logic_vector(3 downto 0);  --Դ�Ĵ�����
>>>>>>> 811a3297e5ed6406723e9cfa0e3bebbed57b8eac
=======
port (  DR: 	  in std_logic_vector(3 downto 0);  --目的寄存器号
		SR: 	  in std_logic_vector(3 downto 0);  --源寄存器号
>>>>>>> a55e84249e88c48e7324ae8dd14b7a2da6fa3a3b
		reset: 	  in std_logic;
		write: 	  in std_logic;	--写寄存器信号
		clk:	  in std_logic;	
		d_input:  in  std_logic_vector(15 downto 0);  --写寄存器的数据
		change_z: in std_logic;			--如果为1，则重新设置z标志
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

signal reg00, reg01, reg02,reg03, reg04: std_logic_vector(15 downto 0);
signal sel00, sel01, sel02, sel03, sel04: std_logic;

begin
    r0 <= reg00;
    r1 <= reg01;
    r2 <= reg02;
    r3 <= reg03;

z_c_proc: process(reset,clk)  --对指令执行结束后的z、c标志进行处理
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

Areg00: reg port map(				--寄存器R0
		reset		=> reset,
		d_input		=> d_input,
		clk			=> clk,		
		write		=> write,
	    sel			=> sel00,	
		q_output	=> reg00
		);

Areg01: reg port map(				--寄存器R1
		reset		=> reset,
		d_input		=> d_input,
		clk			=> clk,		
		write		=> write,
	    sel			=> sel01,	
		q_output	=> reg01	
		);

Areg02: reg port map(				--寄存器R2
		reset		=> reset,
		d_input		=> d_input,
		clk			=> clk,		
		write		=> write,
	    sel			=> sel02,	
		q_output	=>  reg02
		);

Areg03: reg port map(				--寄存器R3
		reset		=> reset,
		d_input		=> d_input,
		clk			=> clk,		
		write		=> write,
	    sel			=> sel03,	
		q_output	=> reg03
		);
		
Areg04: reg port map(				--�Ĵ���R3
		reset		=> reset,
		d_input		=> d_input,
		clk			=> clk,		
		write		=> write,
	    sel			=> sel04,	
		q_output	=> reg04
		);

des_decoder: decoder_2_to_4 port map(	--2 — 4译码器
		sel 	=> DR,
    	sel00 	=> sel00,
		sel01 	=> sel01,
		sel02 	=> sel02,
		sel03 	=> sel03 
		);

muxA: mux_4_to_1 port map(				--目的寄存器读出4选1选择器
		input0  => reg00,
    	input1  => reg01,
		input2  => reg02,
		input3  => reg03,
		sel     => DR,
		output => output_DR
		);
	
muxB: mux_4_to_1 port map(				--源寄存器读出4选1选择器
		input0 	=> reg00,
   	 	input1 	=> reg01,
		input2 	=> reg02,
		input3 	=> reg03,
		sel 	=> SR,
		output => output_SR
		);

end struct;

