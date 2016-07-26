library IEEE;
use IEEE.std_logic_1164.all;

--------- PC SHIFT -------------
--
--	takes 26 bits and 
--	logical shifts it by 2
--
---------------------------------
entity pc_shift is
	port(
		in0 : IN STD_LOGIC_VECTOR(25 DOWNTO 0);
		out0 : OUT STD_LOGIC_VECTOR(27 downto 0)
	);
end pc_shift;

architecture beh of pc_shift is

begin

	out0 <= in0 & "00";

end beh;