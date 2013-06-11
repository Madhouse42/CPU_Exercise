library ieee;
use ieee.std_logic_1164.all;

entity decoder_2_to_4 is
    port (
            sel :   in std_logic_vector(3 downto 0);
            sel00:  out std_logic;
            sel01:  out std_logic;
            sel02:  out std_logic;
            sel03:  out std_logic;
			sel04: out std_logic
        );
end decoder_2_to_4;

architecture behavioral of decoder_2_to_4 is
begin
    sel00 <= (not sel(3)) and
             (not sel(2)) and
             (not sel(1)) and
             (not sel(0));
    sel01 <= (not sel(3)) and
             (not sel(2)) and
             (not sel(1)) and
             sel(0);
    sel02 <= (not sel(3)) and
             (not sel(2)) and
             sel(1) and
             (not sel(0));
    sel03 <= (not sel(3)) and
             (not sel(2)) and
             sel(1) and
             sel(0);
	sel04 <= (not sel(3)) and
			  sel(2) and
			 (not sel(1)) and
			 (not sel(0));
end behavioral;

