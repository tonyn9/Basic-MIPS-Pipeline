library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mem is
	generic(
		Width: positive := 32;  -- number of bits per unit
		memSize: positive := 2048; -- number of bytes to hold in memory
		ByteSize: positive := 8 --making the memory byte addressable
	);
	port(
		dataI:  in std_logic_vector(Width-1 downto 0); -- input data
		data0: out std_logic_vector(Width-1 downto 0); -- output data
		addr: in std_logic_vector(Width-1 downto 0);
		we: in std_logic;
		ref_clk: in std_logic  -- write enable and clock
	);
end mem;
architecture beh of mem is

	type memType is array(0 to memSize-1) of 
				std_logic_vector(ByteSize-1 downto 0);
						
						
	signal memout: std_logic_vector(Width-1 downto 0);
	--signal addr1: std_logic_vector(11 downto 0);

begin
	--addr1 <= to_integer(unsigned(addr (11 downto 0)));


mem_process: process (ref_clk, addr, we)
		
		variable mem: memType := (others => x"00");
		variable addr1: natural;
	begin
		addr1 := to_integer(unsigned(addr (11 downto 0)));
		if rising_edge(ref_clk) and (we='1') then
				
				mem(addr1) := dataI(31 downto 24);
				mem(addr1+1) := dataI(23 downto 16);
				mem(addr1+2) := dataI(15 downto 8);
				mem(addr1+3) := dataI(7 downto 0);
				
		end if;
		-- in all cases, put updated value on the bus combinationally
		
		memout <= mem(addr1) & mem(addr1 + 1) & mem(addr1 + 2) & mem(addr1 + 3);
		
		
	end process;

	data0 <= memout;

end beh;