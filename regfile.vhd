library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity regfile is --three-port register file
	GENERIC ( NBIT : INTEGER := 32;
	NSEL : INTEGER := 5);
	Port(
		ref_clk : IN std_logic;
		we   : in std_logic;
		raddr_1 : IN std_logic_vector ( NSEL -1 DOWNTO 0); -- read address 1
		raddr_2 : IN std_logic_vector ( NSEL -1 DOWNTO 0); -- read address 2
		waddr : IN std_logic_vector ( NSEL -1 DOWNTO 0); -- write address
		rdata_1 : OUT std_logic_vector ( NBIT -1 DOWNTO 0); -- read data 1
		rdata_2 : OUT std_logic_vector ( NBIT -1 DOWNTO 0); -- read data 2
		wdata : IN std_logic_vector ( NBIT -1 DOWNTO 0) -- write data 1
	);

end regfile;
architecture beh of regfile is

	type ramtype is array (31 downto 0) of std_logic_vector (31 downto 0);
	signal mem:ramtype := (others => x"00000000");
	constant zeroes : std_logic_vector (31 downto 0) := (others => '0');
begin

	-- three-ported register file
	-- read two ports combinationally
	-- write third port on rising edge of clk
	-- register 0 hardwire to 0
	-- note: for pipleline, write third port on falling edge
	
process_write:	process(ref_clk) begin
			if ref_clk'event and ref_clk='1' then
				if we='1' then
					mem(to_integer(unsigned(waddr))) <= wdata;
				end if;
			end if;
		end process;

process_read:	process( raddr_1, raddr_2 ) begin
			if(to_integer(unsigned(raddr_1)) =0 ) then rdata_1 <= zeroes;
				--register 0 holds 00000000
			else rdata_1 <= mem(to_integer(unsigned(raddr_1)));
			end if;
			if(to_integer(unsigned(raddr_2)) =0 ) then rdata_2 <= zeroes;
				--register 0 holds 00000000
			else rdata_2 <= mem(to_integer(unsigned(raddr_2)));
			end if;
		end process;

end;