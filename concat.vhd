library IEEE;
use IEEE.std_logic_1164.all;

entity concat is
	port(
		in0 : IN STD_LOGIC_VECTOR(27 DOWNTO 0);
		in1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		out0 : OUT STD_LOGIC_VECTOR(31 downto 0)
	);
end concat;

architecture beh of concat is

begin

	out0 <= in1 & in0;

end beh;