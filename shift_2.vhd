library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--------------- shift_2 ---------------
--
--
--	shifts incoming 32 bit by 2
--	shift is logical shift (shift by 0s)
--
--
---------------------------------------

ENTITY shift_2 IS
PORT(	
		PreShift : IN std_logic_vector (31 downto 0);
		PostShift : OUT std_logic_vector(31 DOWNTO 0)	
	);
END shift_2;

architecture beh of shift_2 is
		
begin
	
	PostShift <= PreShift(29 downto 0) & "00";
	
end beh;
	