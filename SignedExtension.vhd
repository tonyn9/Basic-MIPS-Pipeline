library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity SignedExtension is
	port(
		in0 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		out0 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
end SignedExtension;
	
architecture Behavioral of SignedExtension is

begin
	
	out0 <= std_logic_vector(resize(signed(in0), out0'length));
	
end Behavioral;
