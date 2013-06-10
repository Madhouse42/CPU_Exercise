library ieee;
use ieee.std_logic_1164.all;

entity reg_out is
    port(ir,pc,reg_in:        in std_logic_vector(15 downto 0);
         offset,alu_a,alu_b:  in std_logic_vector(15 downto 0);
         alu_out,reg_testa:   in std_logic_vector(15 downto 0);
         reg_sel:             in std_logic_vector(3 downto 0);
         sel:                 in std_logic_vector(1 downto 0);
         reg_data:            out std_logic_vector(15 downto 0));
end reg_out;

architecture behave of reg_out is
begin
	process(ir,pc,reg_in,sel,reg_sel,offset,alu_a,alu_b,alu_out,reg_testa)
	variable temp: std_logic_vector(5 downto 0) ;
	begin
	    temp := sel & reg_sel;
		case sel is
			when "00"=>
				reg_data<=reg_in;
			when "01"=>
				case reg_sel is
				when "0000"=>
				reg_data<=offset;
				when "0001"=>
				reg_data<=alu_a;
				when "0010"=>
				reg_data<=alu_b;
				when "0011"=>
				reg_data<=alu_out;
				when "0100"=>
				reg_data<=reg_testa;
				when others=>
				reg_data<="0000000000000000";
				end case;
			when "11"=>
				case reg_sel is
				when "1110"=>
				reg_data<=pc;
				when "1111"=>
				reg_data<=ir;
				when others=>
				reg_data<="0000000000000000";
				end case;
			when others=>
				reg_data<="0000000000000000";
		end case;
	end process;
end behave;
