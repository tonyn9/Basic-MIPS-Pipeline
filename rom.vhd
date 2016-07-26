library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use STD.TEXTIO.all;
use IEEE.NUMERIC_STD.all;
entity rom is -- instruction memory
port(
	addr: IN STD_LOGIC_VECTOR(31 downto 0); 
	dataOut: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
);
end rom;
architecture behavior of rom is

type ramtype is array (0 to 256) of STD_LOGIC_VECTOR(7 downto 0);

constant mem: ramtype := (
							X"20", X"02", X"00", X"05",
							X"20", X"03", X"00", X"0c",
							X"20", X"67", X"ff", X"f7",
							X"00", X"e2", X"20", X"25",
							X"00", X"64", X"28", X"24",
							X"00", X"a4", X"28", X"20",
							X"10", X"a7", X"00", X"0a",
							X"00", X"64", X"20", X"2a",
							X"10", X"80", X"00", X"01",
							X"20", X"05", X"00", X"00",
							X"00", X"e2", X"20", X"2a",
							X"00", X"85", X"38", X"20",
							X"00", X"e2", X"38", X"22",
							X"ac", X"67", X"00", X"44",
							X"8c", X"02", X"00", X"50",
							X"08", X"00", X"00", X"11",
							X"20", X"02", X"00", X"01",
							X"ac", X"02", X"00", X"54",							
							others => X"00"
						);
begin
------------------------new loop-----------------------------
rom_process: process( addr )
	begin
	dataOut<= mem(to_integer(unsigned(addr(7 DOWNTO 0)))) & mem(to_integer(unsigned(addr(7 DOWNTO 0))) + 1) & mem(to_integer(unsigned(addr(7 DOWNTO 0))) +2) & mem(to_integer(unsigned(addr(7 DOWNTO 0))) + 3);

end process;
end;
