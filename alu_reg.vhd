library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY alu_reg IS
	GENERIC(
		Width: positive := 32 --number of bits;
	);
	PORT(	
		ref_clk : IN std_logic;
		RegWriteE :	IN std_logic;
		MemtoRegE : IN std_logic;
		MemWriteE : IN std_logic;
		LoadControlE : IN std_logic_vector (2 downto 0);
		
		ALU_IN : IN std_logic_vector (Width-1 downto 0);
		WriteDataE : IN std_logic_vector (Width-1 downto 0);
		WriteRegE : IN std_logic_vector (4 downto 0);
		SignImmE : IN std_logic_vector (Width-1 downto 0);
		JALDataE : IN std_logic_vector (1 downto 0);
		
		RegWriteM : OUT std_logic;
		MemtoRegM : OUT std_logic;
		MemWriteM : OUT std_logic;
		LoadControlM : OUT std_logic_vector (2 downto 0);
		
		ALU_OUT : OUT std_logic_vector(Width-1 downto 0);
		WriteDataM : OUT std_logic_vector(Width-1 downto 0);
		WriteRegM : OUT std_logic_vector(4 downto 0);
		SignImmM : OUT std_logic_vector(Width-1 downto 0);
		JALDataM : OUT std_logic_vector (1 downto 0)

	);
END alu_reg;

architecture beh of alu_reg is

begin
	
	process( ref_clk, RegWriteE, MemtoRegE, MemWriteE, ALU_IN, WriteDataE, WriteRegE)
	
		variable RegWriteE_temp : std_logic := '0';
		variable MemtoRegE_temp : std_logic := '0';
		variable MemWriteE_temp : std_logic := '0';
		variable ALU_TEMP : std_logic_vector(Width-1 downto 0) := x"00000000";
		variable WriteDataE_temp : std_logic_vector(Width-1 downto 0) := x"00000000";
		variable WriteRegE_temp : std_logic_vector( 4 downto 0) := "00000";
		variable LoadControlE_temp : std_logic_vector (2 downto 0) := "100";
		variable SignImmE_temp : std_logic_vector(Width-1 downto 0) := x"00000000";
		variable JALDataE_temp : std_logic_vector(1 downto 0) := "00";
	
	begin
	
		if ref_clk'event AND ref_clk='1' then
		
			RegWriteE_temp := RegWriteE;
			MemtoRegE_temp := MemtoRegE;
			MemWriteE_temp := MemWriteE;
			ALU_TEMP := std_logic_vector(unsigned(ALU_IN));
			WriteDataE_temp := std_logic_vector(unsigned(WriteDataE));
			WriteRegE_temp := std_logic_vector(unsigned(WriteRegE));
			LoadControlE_temp := std_logic_vector(unsigned(LoadControlE));
			SignImmE_temp := std_logic_vector(unsigned(SignImmE));
			JALDataE_temp := std_logic_vector(unsigned(JALDataE));
		
		end if;
	
		RegWritem <= RegWriteE_temp;
		MemtoRegM <= MemtoRegE_temp;
		MemWriteM <= MemWriteE_temp;
		ALU_OUT <= ALU_TEMP;
		WriteDataM <= WriteDataE_temp;
		WriteRegM <= WriteRegE_temp;
		LoadControlM <= LoadControlE_temp;
		SignImmM <= SignImmE_temp;
		JALDataM <= JALDataE_temp;
	
	end process;

end;