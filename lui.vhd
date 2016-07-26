library IEEE;
use IEEE.std_logic_1164.all;

------------ load upper immediate -----------
--
--
--	this block is to be after the sign extend!!
--	takes the 16 lsb bits coming out from the 
--	sign extend, shift it up, and add 0's to
--	the end.
--
--
-----------------------------------------------


entity lui is
	port(
		in0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		out0 : OUT STD_LOGIC_VECTOR(31 downto 0)
	);
end lui;

architecture beh of lui is

begin

	out0 <= in0(15 downto 0) & "0000000000000000";

end beh;