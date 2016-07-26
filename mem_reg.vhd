library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY mem_reg IS
	GENERIC(
		Width: positive := 32 --number of bits;
	);
	PORT(	
		ref_clk : IN std_logic;
		RegWriteM :	IN std_logic;
		MemtoRegM : IN std_logic;
		LoadControlM : IN std_logic_vector (2 downto 0);
		
		ALU_IN : IN std_logic_vector (Width-1 downto 0);
		RD_IN : IN std_logic_vector (Width-1 downto 0);
		WriteRegM : IN std_logic_vector (4 downto 0);
		SignImmM : IN std_logic_vector (Width-1 downto 0);
		JALDataM : IN std_logic_vector (1 downto 0);
		
		RegWriteW : OUT std_logic;
		MemtoRegW : OUT std_logic;
		LoadControlW : OUT std_logic_vector (2 downto 0);
		
		ALU_OUT : OUT std_logic_vector(Width-1 downto 0);
		RD_OUT : OUT std_logic_vector(Width-1 downto 0);
		WriteRegW : OUT std_logic_vector(4 downto 0);
		SignImmW : OUT std_logic_vector(Width-1 downto 0);
		JALDataW : OUT std_logic_vector (1 downto 0)

	);
END mem_reg;

architecture beh of mem_reg is

begin

	process( ref_clk , RegWriteM, MemtoRegM, RD_IN, ALU_IN, WriteRegM)
	
		variable RegWriteM_temp : std_logic := '0';
		variable MemtoRegM_temp : std_logic := '0';
		variable ALU_TEMP : std_logic_vector(Width-1 downto 0) := x"00000000";
		variable RD_TEMP : std_logic_vector(Width-1 downto 0) := x"00000000";
		variable WriteRegM_temp : std_logic_vector(4 downto 0) := "00000";
		variable LoadControlM_temp : std_logic_vector(2 downto 0) := "100";
		variable SignImmM_temp : std_logic_vector(Width-1 downto 0) := x"00000000";
		variable JALDataM_temp : std_logic_vector(1 downto 0) := "00";
	
	begin
	
		if ref_clk'event and ref_clk='1' then
			RegWriteM_temp := RegWriteM;
			MemtoRegM_temp := MemtoRegM;
			ALU_TEMP := std_logic_vector(unsigned(ALU_IN));
			RD_TEMP := std_logic_vector(unsigned(RD_IN));
			WriteRegM_temp := std_logic_vector(unsigned(WriteRegM));
			LoadControlM_temp := std_logic_vector(unsigned(LoadControlM));
			SignImmM_temp := std_logic_vector(unsigned(SignImmM));
			JALDataM_temp := std_logic_vector(unsigned(JALDataM));
		end if;
		
		RegWriteW <= RegWriteM_temp;
		MemtoRegW <= MemtoRegM_temp;
		ALU_OUT <= ALU_TEMP;
		RD_OUT <= RD_TEMP;
		WriteRegW <= WriteRegM_temp;
		LoadControlW <= LoadControlM_temp;
		SignImmW <= SignImmM_temp;
		JALDataW <= JALDataM_temp;
	end process;

end;