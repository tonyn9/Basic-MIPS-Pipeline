library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY reg_reg IS
	GENERIC(
		Width: positive := 32 --number of bits;
	);
	PORT(	
		ref_clk : IN std_logic;
		RegWriteD :	IN std_logic;
		MemtoRegD : IN std_logic;
		MemWriteD : IN std_logic;
		ALUControlD : IN std_logic_vector(5 downto 0);
		ALUSrcD : IN std_logic;
		RegDstD : IN std_logic;
		LoadControlD : IN std_logic_vector (2 downto 0);
		
		RD1 : IN std_logic_vector (Width-1 downto 0);
		RD2 : IN std_logic_vector (Width-1 downto 0);
		RsD : IN std_logic_vector (4 downto 0);
		RtD : IN std_logic_vector (4 downto 0);
		RdD : IN std_logic_vector (4 downto 0);
		SignImmD : IN std_logic_vector (Width-1 downto 0);
		clr : std_logic;
		JALDataD : IN std_logic_vector (1 downto 0);
		
		RegWriteE : OUT std_logic;
		MemtoRegE : OUT std_logic;
		MemWriteE : OUT std_logic;
		ALUControlE : OUT std_logic_vector(5 downto 0);
		ALUSrcE : OUT std_logic;
		RegDstE : OUT std_logic;
		LoadControlE : OUT std_logic_vector (2 downto 0);
		
		RD1Mux1 : OUT std_logic_vector(Width-1 downto 0);
		RD2Mux2 : OUT std_logic_vector(Width-1 downto 0);
		RsE : OUT std_logic_vector(4 downto 0);
		RtE : OUT std_logic_vector(4 downto 0);
		RdE : OUT std_logic_vector(4 downto 0);
		SignImmE : OUT std_logic_vector(Width-1 downto 0);
		JALDataE : OUT std_logic_vector (1 downto 0)

	);
END reg_reg;

architecture beh of reg_reg is

begin

	process ( ref_clk, RegWriteD, MemtoRegD, MemWriteD, ALUControlD, ALUSrcD, 
				RegDstD, RD1, RD2, RsD, RtD, RdD, SignImmD, clr)
			
			variable RegWriteD_temp : std_logic := '0';
			variable MemWriteD_temp : std_logic := '0';
			variable MemtoRegD_temp : std_logic := '0';
			variable ALUControlD_temp : std_logic_vector(5 downto 0) := "000000";
			variable ALUSrcD_temp : std_logic := '0';
			variable RegDstD_temp : std_logic := '0';
			variable RD1_temp : std_logic_vector(Width-1 downto 0) := x"00000000";
			variable RD2_temp : std_logic_vector(Width-1 downto 0) := x"00000000";
			variable RsD_temp : std_logic_vector(4 downto 0) := "00000";
			variable RtD_temp : std_logic_vector(4 downto 0) := "00000";
			variable RdD_temp : std_logic_vector(4 downto 0) := "00000";
			variable SignImmD_temp : std_logic_vector(Width-1 downto 0) := x"00000000";
			variable LoadControlD_temp : std_logic_vector(2 downto 0) := "100";
			variable JALDataD_temp : std_logic_vector(1 downto 0) := "XX";
			
		begin
			if ref_clk'event and ref_clk = '1' then
				if clr = '1' then
					RegWriteD_temp := 'X';
					MemtoRegD_temp := 'X';
					MemWriteD_temp := '0';
					ALUControlD_temp := "XXXXXX";
					ALUSrcD_temp := 'X';
					RegDstD_temp := 'X';
					RD1_temp := x"00000000";
					RD2_temp := x"00000000";
					RsD_temp := "00000";
					RtD_temp := "00000";
					RdD_temp := "00000";
					SignImmD_temp := x"00000000";
					JALDataD_temp := "XX";
				elsif clr = '0' then
					RegWriteD_temp := RegWriteD;
					MemtoRegD_temp := MemtoRegD;
					MemWriteD_temp := MemWriteD;
					ALUControlD_temp := ALUControlD;
					ALUSrcD_temp := ALUSrcD;
					RegDstD_temp := RegDstD;
					LoadControlD_temp := std_logic_vector(unsigned(LoadControlD));
					RD1_temp := std_logic_vector(unsigned(RD1));
					RD2_temp := std_logic_vector(unsigned(RD2));
					RsD_temp := std_logic_vector(unsigned(RsD));
					RtD_temp := std_logic_vector(unsigned(RtD));
					RdD_temp := std_logic_vector(unsigned(RdD));
					SignImmD_temp := std_logic_vector(unsigned(SignImmD));
					JALDataD_temp := std_logic_vector(unsigned(JALDataD));
				end if;
			
			RegWriteE <= RegWriteD_temp;
			MemtoRegE <= MemtoRegD_temp;
			MemWriteE <= MemWriteD_temp;
			ALUControlE <= ALUControlD_temp;
			ALUSrcE <= ALUSrcD_temp;
			RegDstE <= RegDstD_temp;
			LoadControlE <= LoadControlD_temp;
			RD1Mux1 <= RD1_temp;
			RD2Mux2 <= RD2_temp;
			RsE <= RsD_temp;
			RtE <= RtD_temp;
			RdE <= RdD_temp;
			SignImmE <= SignImmD_temp;
			JALDataE <= JALDataD_temp;
			
			
			end if;
		
	end process;


end;