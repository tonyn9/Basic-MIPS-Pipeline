

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY controller is
	PORT (
		--maybe clock?
		--clk : IN std_logic;
		
		OPCODE : IN std_logic_vector (31 downto 26);
		FUNC : IN std_logic_vector (5 downto 0);
		BR : IN std_logic_vector(20 downto 16);
		
		-- CONTROL ENABLE
		
		-- write enable for regfile
		-- '0' if read, '1' if write
		RegWriteD: OUT std_logic;

		-- selecting sign extend OR raddr_2
		-- '0' if raddr_2 result, '1' if sign extend result
		ALUSrcD: OUT std_logic;

		-- write ebable for data memory
		-- '0' if not writing to mem, '1' if writing to mem
		MemWriteD: OUT std_logic;

		--lets mem know how much to write
		-- "00" for byte "01" for half "11" for word
		--DSize: OUT std_logic_vector (1 downto 0);
		
		-- selecting output data from memory OR ALU result
		-- '1' if ALU result, '0' if mem result
		MemToRegD: OUT std_logic;

		-- selecting if 'rs' or 'rt' is selected to write destination (regfile)
		-- '1' if rd, '0' if rt
		RegDstD: OUT std_logic;

		-- '1' if branching, '0' if not branching
		BranchD: OUT std_logic;

		-- '1' if JumpD instruction, else '0' 
		JumpD: OUT std_logic;

		-- '1' if JR instruction, else '0'
		--JRControl: OUT std_logic;

		-- '1' if JAL instruction and saves current address to register '31' else '0' 
		--JALAddr: OUT std_logic;

		-- "00" (LB/LH, and whatever comes out from memReg)
		-- "01" for LUI instruction,
		-- "10" for JAL, saves data of current instruction (or the next one)		 
		JALData: OUT std_logic_vector(1 DOWNTO 0);

		-- '1' if shift, else '0' (SLL, SRL, SRA ONLY)
		--ShiftControl: OUT std_logic;

		-- "000" if LB; "001" if LH; "010" if LBU; "011" if LHU; 
		-- "100" if normal, (don't do any manipulation to input) 
		LoadControlD: OUT std_logic_vector(2 DOWNTO 0);

		-- func for ALU
		ALUControlD: OUT std_logic_vector(5 DOWNTO 0)
	
	
	);
end controller;

architecture beh of controller is

begin

	-- CONTROL ENABLE
	--enable register write when its not branch, jump, or store
	RegWriteD <= '1' when (
			--branches
			--BEQ
			NOT(OPCODE="000100") AND
			
			--BNE
			NOT(OPCODE="000101") AND
			
			--BLTZ or BGEZ
			NOT(OPCODE="000001") AND
			
			-- BLEZ
			NOT(OPCODE="000110") AND
			
			--BGTZ
			NOT(OPCODE="000111") AND
			
			--jumps
			--Jump
			NOT(OPCODE="000010") AND
			
			--JR
			NOT(OPCODE="000000" AND FUNC="001000") AND
			
			--stores
			--SB
			NOT(OPCODE="101000") AND
			
			--SH
			NOT(OPCODE="101001") AND
			
			--SW
			NOT(OPCODE="101011")
	
		) else
		'0';
	

	
	ALUSrcD <= '1' when (	

			-- addi
			(OPCODE = "001000") OR

			-- ADDIU or JALR(can be anything)
			(OPCODE = "001001") OR

			-- SUBi and SubUi
			--no such thing in mips to subtract immediate

			-- ANDI
			(OPCODE = "001100") OR

			-- ORI
			(OPCODE = "001101") OR

			-- XORI
			(OPCODE = "001110") OR

			-- SLTI
			(OPCODE = "001010") OR

			-- SLTUI
			(OPCODE = "001011") OR

			-- LUI
			(OPCODE = "001111") OR

			-- BLTZ or BGEZ
			(OPCODE = "000001") OR

			-- BLEZ
			(OPCODE = "000110") OR

			-- BGTZ
			(OPCODE = "000111") OR

			-- LB
			(OPCODE = "100000") OR

			-- LH
			(OPCODE = "100001") OR

			-- SB
			(OPCODE = "101000") OR

			-- SH
			(OPCODE = "101001") OR

			-- LBU
			(OPCODE = "100100") OR

			-- LHU
			(OPCODE = "100101") OR

			-- LW
			(OPCODE = "100011") OR

			-- SW
			(OPCODE = "101011") 

		) else 
		'0';
	
	MemWriteD <= '1' when (
			--write to memory when its store
			-- SB
			(OPCODE = "101000") OR

			-- SH
			(OPCODE = "101001") OR

			-- SW
			(OPCODE = "101011")
		) else 
		'0';


	MemToRegD <= '1' when (

			-- SB
			(OPCODE = "101000") OR

			-- SH
			(OPCODE = "101001") OR

			-- SW
			(OPCODE = "101011") OR
			
			-- LB
			(OPCODE = "100000") OR

			-- LH
			(OPCODE = "100001") OR
			
			-- LBU
			(OPCODE = "100100") OR

			-- LHU
			(OPCODE = "100101") OR

			-- LW
			(OPCODE = "100011")

		) else 
		'0';
		
	RegDstD <= '1'  when (

			-- R-type and instruction with opcode "000000"
			-- all take RegDstD='1'
			(OPCODE = "000000") 
		) else 
		'0';
		
	BranchD <= '1'  when (

			-- BEQ
			(OPCODE = "000100") OR

			-- BNE
			(OPCODE = "000101") OR

			-- BLTZ or BGEZ
			(OPCODE = "000001") OR

			-- BLEZ
			(OPCODE = "000110") OR

			-- BGTZ
			(OPCODE = "000111") 
		) else 
		'0';
		
	JumpD <= '1'	 when (

			-- JUMP
			 (OPCODE = "000010") --OR

			-- -- JR or JALR
			-- (OPCODE = "000000" AND
				-- (FUNC = "001000" OR
				  -- FUNC = "001001")) OR

			-- -- JAL
			-- (OPCODE = "000011") 
		) else
		'0'; 
		
		


	JALData <= "10" when(

			-- JAL
			(OPCODE = "000011") OR

			-- JALR
			((OPCODE = "000000") AND
				(FUNC = "001001"))
		) else 
		"01" when (

			-- LUI
			(OPCODE = "001111")
		) else 
		"00";

	LoadControlD <= "000" when(

			-- LB
			(OPCODE = "100000")
		) else 
		"001" when (

			-- LH
			(OPCODE = "100001")
		) else 
		"010" when (

			-- LBU
			(OPCODE = "100100")
		) else 
		"011" when (

			-- LHU
			(OPCODE = "100101")
		) else 
		"100";

		
	ALUControlD <= "100000" when (

			-- ADDI
			(OPCODE = "001000")
		) else 
		"100001" when (

			-- ADDUI
			(OPCODE = "001001") OR

			-- LB
			(OPCODE = "100000") OR

			-- LH
			(OPCODE = "100001") OR

			-- SB
			(OPCODE = "101000") OR

			-- SH
			(OPCODE = "101001") OR

			-- LBU 
			(OPCODE = "100100") OR

			-- LHU
			(OPCODE = "100101") OR

			-- LW
			(OPCODE = "100011") OR

			-- SW
			(OPCODE = "101011") 
		) else 
		"100100" when (

			-- ANDI
			(OPCODE = "001100")
		) else 
		"100101" when (

			-- ORI
			(OPCODE = "001101")
		) else
		"100110" when (

			-- XORI
			(OPCODE = "001110")
		) else 
		"101010" when (

			-- SLTI
			(OPCODE = "001010")
		) else
		"101011" when (

			-- SLTIU
			(OPCODE = "001011")
		) else 
		(FUNC);
end beh;
