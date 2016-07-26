library IEEE;
use IEEE.std_logic_1164.all;

-- used fore wdata
-- 00 takes from memory
-- 01 takes from adder after pc
-- 10 takes lui
-- 11 not used

entity b32_mux4_1 is
	generic (
		Width: positive := 32 --number of bits
	);
	port(
		in0 : IN STD_LOGIC_VECTOR(Width-1 DOWNTO 0); --input0
		in1 : IN STD_LOGIC_VECTOR(Width-1 DOWNTO 0); --input1
		in2 : IN STD_LOGIC_VECTOR(Width-1 DOWNTO 0); --input2
		in3 : IN STD_LOGIC_VECTOR(Width-1 DOWNTO 0); --input3
		mode : IN STD_LOGIC_VECTOR(1 DOWNTO 0); --selects in0 when 00, in1 when 01, in2 when 10, else in3
		out0 : OUT STD_LOGIC_VECTOR(Width-1 DOWNTO 0) --output
	);
end b32_mux4_1;
	
architecture beh of b32_mux4_1 is

begin

	out0 <= in0 when mode="00" else 
		in1 when mode = "01" else
		in2 when mode = "10" else
		in3;

end beh;