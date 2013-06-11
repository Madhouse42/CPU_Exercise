library ieee;
use ieee.std_logic_1164.all;

entity t2 is
port(offset_8:in std_logic_vector(7 downto 0);
     offset_16:out std_logic_vector(15 downto 0));
end t2;

architecture behave of t2 is
begin
	process(offset_8)
	begin
	if offset_8(7) = '1' then offset_16 <= "11111111" & offset_8;
	else offset_16 <= "00000000" & offset_8;
	end if;
	end process;
end behave;