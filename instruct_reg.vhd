library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY instruct_reg IS
	GENERIC(
		Width: positive := 32 --number of bits;
	);
	PORT(	
		ref_clk : IN std_logic;
		enable : IN std_logic;
		instruct_In : IN std_logic_vector(Width - 1 DOWNTO 0);
		clr: IN std_logic; -- clear enable from PCSrc
		instuct_Out : OUT std_logic_vector(Width - 1 DOWNTO 0);
		PCPlus4_In : IN std_logic_vector(Width - 1 DOWNTO 0);
		PCPlus4_Out : OUT std_logic_vector(Width - 1 DOWNTO 0)
	);
END instruct_reg;

architecture Behavioral of instruct_reg is
	
	signal pc: std_logic_vector (Width - 1 downto 0);
	signal ii: std_logic_vector (Width - 1 downto 0);
	
begin
impl: 	process( ref_clk )

		--variable rr : std_logic_vector (31 downto 0);

	begin
		if ref_clk'event and ref_clk='1' and enable/='1' then
			ii <= instruct_In;
			pc <= PCPlus4_In;
		end if;
	end process;
	
	-- concurrent statement
	instuct_Out <= ii;
	PCPlus4_Out <= pc;
end Behavioral;
	
	
