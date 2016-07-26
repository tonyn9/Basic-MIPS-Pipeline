library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adder_u_32 is
	generic(
		Width: positive := 32 --number of bits
	);
	port(
		in0 : IN STD_LOGIC_VECTOR(Width-1 DOWNTO 0); --input0
		in1 : IN STD_LOGIC_VECTOR(Width-1 DOWNTO 0); --input1
		out0 : OUT STD_LOGIC_VECTOR(Width-1 DOWNTO 0) --output
	);
end adder_u_32;

architecture beh of adder_u_32 is

begin

	out0 <= std_logic_vector(unsigned(in0) + unsigned(in1));

end beh;