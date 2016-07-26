library IEEE;
use IEEE.std_logic_1164.all;

entity b5_mux2_1 is
	generic (
		Width: positive := 5 --number of bits
	);
	port(
		in0 : IN STD_LOGIC_VECTOR(Width-1 DOWNTO 0); --input0
		in1 : IN STD_LOGIC_VECTOR(Width-1 DOWNTO 0); --input1
		mode : IN STD_LOGIC; --selects in0 when 0, in1 when 1
		out0 : OUT STD_LOGIC_VECTOR(Width-1 DOWNTO 0) --output
	);
end b5_mux2_1;
	
architecture beh of b5_mux2_1 is

begin

	out0 <= in0 when mode='0' else in1;

end beh;