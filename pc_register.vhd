library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY pc_register IS
PORT
	(	
		ref_clk : IN std_logic;
		enable : IN std_logic;
		reset : IN std_logic;
		rrIn: IN std_logic_vector(31 DOWNTO 0);
		rrOut : OUT std_logic_vector(31 DOWNTO 0)
		
	);
END pc_register;

architecture Behavioral of pc_register is
	
	signal rr: std_logic_vector (31 downto 0) := (others => '0');
	
begin
impl: 	process( ref_clk, reset )

		--variable rr : std_logic_vector (31 downto 0);
		variable r: std_logic;

	begin
		if reset = '1' then
			rr <= X"00000000";
			r := '0';
		else
			if ref_clk'event and ref_clk='1' and enable/='1' then
				if r ='1' then
					rr <= rrIn;
				else
					rr <= X"00000000";
					r := '1';
				end if;
			end if;
		end if;
	end process;
	
	-- concurrent statement
	rrOut <= rr;
end Behavioral;
	
	
