library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY processor IS
	GENERIC (
		Width: positive := 32; --number of bits
		NBIT : INTEGER := 32;
		NSEL : INTEGER := 5
	);
	PORT (
		clk : IN std_logic ;
		reset : IN std_logic;

		-- This output signal is only necessary for synthesis
		out0 : OUT std_logic_vector(31 DOWNTO 0)
	);
END processor;

architecture beh of processor is

-- component

-- adder
component adder_u_32
	port(
		in0 : IN STD_LOGIC_VECTOR(Width-1 DOWNTO 0); --input0
		in1 : IN STD_LOGIC_VECTOR(Width-1 DOWNTO 0); --input1
		out0 : OUT STD_LOGIC_VECTOR(Width-1 DOWNTO 0) --output
	);
end component;

-- alu
component alu
	PORT (
		Func_in : IN std_logic_vector (5 DOWNTO 0);
		A_in : IN std_logic_vector (31 DOWNTO 0);
		B_in : IN std_logic_vector (31 DOWNTO 0);
		O_out : OUT std_logic_vector (31 DOWNTO 0)
	);
end component;

-- alu_reg
component alu_reg
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
end component;

-- 5 bit mux
component b5_mux2_1
	port(
		in0 : IN STD_LOGIC_VECTOR(4 DOWNTO 0); --input0
		in1 : IN STD_LOGIC_VECTOR(4 DOWNTO 0); --input1
		mode : IN STD_LOGIC; --selects in0 when 0, in1 when 1
		out0 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0) --output
	);
end component;


-- 32 bit mux
component b32_mux2_1
	port(
		in0 : IN STD_LOGIC_VECTOR(Width-1 DOWNTO 0); --input0
		in1 : IN STD_LOGIC_VECTOR(Width-1 DOWNTO 0); --input1
		mode : IN STD_LOGIC; --selects in0 when 0, in1 when 1
		out0 : OUT STD_LOGIC_VECTOR(Width-1 DOWNTO 0) --output
	);
end component;

-- 32 bit 4 mux
component b32_mux4_1
	port(
		in0 : IN STD_LOGIC_VECTOR(Width-1 DOWNTO 0); --input0
		in1 : IN STD_LOGIC_VECTOR(Width-1 DOWNTO 0); --input1
		in2 : IN STD_LOGIC_VECTOR(Width-1 DOWNTO 0); --input2
		in3 : IN STD_LOGIC_VECTOR(Width-1 DOWNTO 0); --input3
		mode : IN STD_LOGIC_VECTOR(1 DOWNTO 0); --selects in0 when 00, in1 when 01, in2 when 10, else in3
		out0 : OUT STD_LOGIC_VECTOR(Width-1 DOWNTO 0) --output
	);
end component;

--concat
component concat
	port(
		in0 : IN STD_LOGIC_VECTOR(27 DOWNTO 0);
		in1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		out0 : OUT STD_LOGIC_VECTOR(31 downto 0)
	);
end component;

-- controller
component controller
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
end component;

-- equality branch check
component equality
	port(
		inA : IN STD_LOGIC_VECTOR(Width-1 DOWNTO 0); --inputA
		inB : IN STD_LOGIC_VECTOR(Width-1 DOWNTO 0); --inputB
		ALUControl : IN STD_LOGIC_VECTOR (5 DOWNTO 0); -- checks branch type
		outE : OUT STD_LOGIC --output
	);
end component;

-- hazard unit
component hazard_unit
	port(
		BranchD : IN std_logic;
		RsD: IN std_logic_vector (4 DOWNTO 0);
		RtD: IN std_logic_vector (4 DOWNTO 0);
		RsE: IN std_logic_vector (4 DOWNTO 0);
		RtE: IN std_logic_vector (4 DOWNTO 0);
		WriteRegE: IN std_logic_vector (4 DOWNTO 0);
		WriteRegM: IN std_logic_vector (4 DOWNTO 0);
		WriteRegW: IN std_logic_vector (4 DOWNTO 0);
		MemtoRegE: IN std_logic;
		RegWriteE: IN std_logic;
		RegWriteM: IN std_logic;
		RegWriteW: IN std_logic;
		JumpD: IN std_logic; -- added for jump
		StallF: OUT std_logic;
		StallD: OUT std_logic;
		ForwardAD: OUT std_logic;
		ForwardBD: OUT std_logic;
		FlushE: OUT std_logic;
		ForwardAE: OUT std_logic_vector (1 DOWNTO 0);
		ForwardBE: OUT std_logic_vector (1 DOWNTO 0)
	);
end component;

--instruction register after rom
component instruct_reg
	PORT(	
		ref_clk : IN std_logic;
		enable : IN std_logic;
		instruct_In : IN std_logic_vector(Width - 1 DOWNTO 0);
		clr: IN std_logic; -- clear enable from PCSrc
		instuct_Out : OUT std_logic_vector(Width - 1 DOWNTO 0);
		PCPlus4_In : IN std_logic_vector(Width - 1 DOWNTO 0);
		PCPlus4_Out : OUT std_logic_vector(Width - 1 DOWNTO 0)
	);
end component;

--load sec
component load_sec
	port(
	in0 : IN STD_LOGIC_VECTOR(31 downto 0);
	load_control : IN STD_LOGIC_VECTOR (2 downto 0);
	out0 : OUT STD_LOGIC_VECTOR(31 downto 0)
	);
end component;

--lui
component lui
	port(
		in0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		out0 : OUT STD_LOGIC_VECTOR(31 downto 0)
	);
end component;

--memory
component mem
	port(
		dataI:  in std_logic_vector(Width-1 downto 0); -- input data
		data0: out std_logic_vector(Width-1 downto 0); -- output data
		addr: in std_logic_vector(Width-1 downto 0);
		we: in std_logic;
		ref_clk: in std_logic  -- write enable and clock
	);
end component;

-- mem regfile
component mem_reg
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
end component;

-- pc_reg
component pc_register
PORT
	(	
		ref_clk : IN std_logic;
		enable : IN std_logic;
		reset : IN std_logic;
		rrIn: IN std_logic_vector(31 DOWNTO 0);
		rrOut : OUT std_logic_vector(31 DOWNTO 0)
		
	);
end component;

--pc shift
component pc_shift
	port(
		in0 : IN STD_LOGIC_VECTOR(25 DOWNTO 0);
		out0 : OUT STD_LOGIC_VECTOR(27 downto 0)
	);
end component;

--reg reg
component reg_reg
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
end component;

--regfile
component regfile
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
end component;

--rom
component rom
	port(
		addr: IN STD_LOGIC_VECTOR(31 downto 0); 
		dataOut: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
end component;

--shift 2
component shift_2
	PORT(	
		PreShift : IN std_logic_vector (31 downto 0);
		PostShift : OUT std_logic_vector(31 DOWNTO 0)	
	);
end component;

--signed extension
component SignedExtension
	port(
		in0 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		out0 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
end component;

-- signals

signal PCSrcD : std_logic;
signal PCPlus4F : std_logic_vector (Width-1 downto 0);
signal PCPlus4D : std_logic_vector (Width-1 downto 0);
signal PCBranchD : std_logic_vector (Width-1 downto 0);
signal PC_in : std_logic_vector (Width-1 downto 0);

signal PCF : std_logic_vector (Width-1 downto 0);
signal IR_out : std_logic_vector(Width-1 downto 0);

signal four : std_logic_vector (Width-1 downto 0) := x"00000004";

signal InstrD : std_logic_vector (Width-1 downto 0);
signal RD1_o : std_logic_vector (Width-1 downto 0);
signal RD2_o : std_logic_vector (Width-1 downto 0);

signal ResultW : std_logic_vector (Width-1 downto 0);
signal SignImmD : std_logic_vector (Width-1 downto 0);
signal shift_out : std_logic_vector (Width-1 downto 0);

signal EqualD : std_logic;

signal ForwardAD_mux_out : std_logic_vector (Width-1 downto 0);
signal ForwardBD_mux_out : std_logic_vector (Width-1 downto 0);

signal RD1toMux1 : std_logic_vector (Width-1 downto 0);
signal RD2toMux2 : std_logic_vector (Width-1 downto 0);

signal ALU_OUT : std_logic_vector (Width-1 downto 0);

signal mem_out : std_logic_vector (Width-1 downto 0);

signal RegWriteD: std_logic;
signal MemtoRegD: std_logic;
signal MemWriteD: std_logic;
signal ALUControlD: std_logic_vector(5 DOWNTO 0);
signal ALUSrcD: std_logic;
signal RegDstD: std_logic;
signal BranchD: std_logic;
signal JumpD: std_logic;

signal RegWriteE: std_logic;
signal MemtoRegE: std_logic;
signal MemWriteE: std_logic;
signal ALUControlE: std_logic_vector(5 DOWNTO 0);
signal ALUSrcE: std_logic;
signal RegDstE: std_logic;

signal RsE: std_logic_vector(25 DOWNTO 21);
signal RtE: std_logic_vector(20 DOWNTO 16);
signal RdE: std_logic_vector(15 DOWNTO 11);
signal SignImmE: std_logic_vector(31 DOWNTO 0);
signal WriteRegE: std_logic_vector(4 DOWNTO 0);
signal WriteDataE: std_logic_vector(Width-1 DOWNTO 0);
signal MemtoWriteE: std_logic;
signal SrcAE: std_logic_vector(Width-1 DOWNTO 0);
signal SrcBE: std_logic_vector(Width-1 DOWNTO 0);

signal RegWriteM: std_logic;
signal MemtoRegM: std_logic;
signal MemWriteM: std_logic;
signal WriteDataM: std_logic_vector(Width-1 DOWNTO 0);
signal WriteRegM: std_logic_vector(4 DOWNTO 0);

signal RegWriteW: std_logic;
signal MemtoRegW: std_logic;
signal ReadDataW: std_logic_vector(Width-1 DOWNTO 0);
signal ALUOutW: std_logic_vector(Width-1 DOWNTO 0);
signal WriteRegW: std_logic_vector(4 DOWNTO 0);

signal ALUOutM: std_logic_vector(Width-1 DOWNTO 0);

signal ForwardAD: std_logic;
signal ForwardBD: std_logic;
signal ForwardAE: std_logic_vector(1 DOWNTO 0);
signal ForwardBE: std_logic_vector(1 DOWNTO 0);
signal StallF : std_logic;
signal StallD : std_logic;
signal FlushE: std_logic;

signal LoadControlD: std_logic_vector(2 DOWNTO 0);
signal LoadControlE: std_logic_vector(2 DOWNTO 0);
signal LoadControlM: std_logic_vector(2 DOWNTO 0);
signal LoadControlW: std_logic_vector(2 DOWNTO 0);

signal andgate_out: std_logic;

signal shiftleft_26bit_out: std_logic_vector(27 DOWNTO 0);

signal PCJumpD: std_logic_vector(Width-1 DOWNTO 0);

signal JumpDmux_out: std_logic_vector(Width-1 DOWNTO 0);

signal emptyWire: std_logic_vector(Width-1 DOWNTO 0);

signal MemtoRegWmuxx_out: std_logic_vector(Width-1 DOWNTO 0);

signal shiftlui_out: std_logic_vector(Width-1 DOWNTO 0);

signal JALDataW_out: std_logic_vector(Width-1 DOWNTO 0);

signal SignImmM: std_logic_vector(Width-1 DOWNTO 0);
signal SignImmW: std_logic_vector(Width-1 DOWNTO 0);

signal JALDataD: std_logic_vector(1 DOWNTO 0);
signal JALDataE: std_logic_vector(1 DOWNTO 0);
signal JALDataM: std_logic_vector(1 DOWNTO 0);
signal JALDataW: std_logic_vector(1 DOWNTO 0);

begin
	
	--pc side
	
	pc_mux : b32_mux2_1 PORT MAP(
		in0 => PCPlus4F,
		in1 => PCBranchD,
		mode => PCSrcD,
		out0 => PC_in
	);
			
	pc_r : pc_register PORT MAP(
		ref_clk => clk,
		enable => StallF,
		reset => reset,
		rrIn => PC_in,
		rrOut => PCF
	);
	
	rom1 : rom PORT MAP(
		addr => PCF,
		dataOut => IR_out
	);
	
	pc_add : adder_u_32 PORT MAP(
		in0 => PCF,
		in1 => x"00000004",
		out0 => PCPlus4F
	);
	
	i_reg : instruct_reg PORT MAP(
		ref_clk => clk,
		enable => StallD,
		instruct_In => IR_out,
		clr => PCSrcD, 
		instuct_Out => InstrD,
		PCPlus4_In => PCPlus4F,
		PCPlus4_Out => PCPlus4D
	);
	
	cont : controller PORT MAP(
		OPCODE =>InstrD(31 downto 26),
		FUNC => InstrD(5 downto 0),
		BR => InstrD(20 downto 16),
		RegWriteD => RegWriteD,
		ALUSrcD => ALUSrcD,
		MemWriteD => MemWriteD,
		MemToRegD => MemToRegD,
		RegDstD => RegDstD,
		BranchD => BranchD,
		JumpD => JumpD,
		JALData => JALDataD,
		LoadControlD => LoadControlD,
		ALUControlD => ALUControlD
	);

	rf : regfile PORT MAP(
		ref_clk => clk,
		we => RegWriteW,
		raddr_1 => InstrD(25 downto 21),
		raddr_2 => InstrD(20 downto 16),
		waddr => WriteRegW,
		rdata_1 => RD1_o,
		rdata_2 => RD2_o,
		wdata => JALDataW_out
	);
	
	se : SignedExtension PORT MAP(
		in0 => InstrD(15 downto 0),
		out0 => SignImmD
	);
	
	shift_32 : shift_2 PORT MAP(
		PreShift => SignImmD,
		PostShift => shift_out
	);
	
	andgate_out <= BranchD AND EqualD;
	PCSrcD <= JumpD OR andgate_out;
	
	branchc : equality PORT MAP(
		inA => ForwardAD_mux_out,
		inB => ForwardBD_mux_out,
		ALUControl => ALUControlD,
		outE => EqualD
	);
	
	FAD_mux : b32_mux2_1 PORT MAP (
		in0 => RD1_o,
		in1 => ALUOutM,
		mode => ForwardAD,
		out0 => ForwardAD_mux_out
	);
	
	FBD_mux : b32_mux2_1 PORT MAP(
		in0 => RD2_o,
		in1 => ALUOutM,
		mode => ForwardBD,
		out0 => ForwardBD_mux_out
	);
	
	jump_add : adder_u_32 PORT MAP(
		in0 => shift_out,
		in1 => PCPlus4D,
		out0 => PCBranchD
	);
	
	shift_26 : pc_shift PORT MAP(
		in0 => InstrD(25 downto 0),
		out0 => shiftleft_26bit_out
	);
	
	cat : concat PORT MAP(
		in0 => shiftleft_26bit_out,
		in1 => PCPlus4D(31 downto 28), 
		out0 => PCJumpD
	);
	
	j_mux : b32_mux2_1 PORT MAP(
		in0 => PCBranchD,
		in1 => PCJumpD,
		mode => JumpD,
		out0 => JumpDmux_out
	);
	
	reg_r : reg_reg PORT MAP(
		ref_clk => clk,
		RegWriteD => RegWriteD,
		MemtoRegD => MemToRegD,
		MemWriteD => MemWriteD,
		ALUControlD => ALUControlD,
		ALUSrcD => ALUSrcD,
		RegDstD => RegDstD,
		LoadControlD => LoadControlD,
		
		RD1 => RD1_o,
		RD2 => RD2_o,
		RsD => InstrD(25 DOWNTO 21),
		RtD => InstrD(20 DOWNTO 16),
		RdD => InstrD(15 DOWNTO 11),
		SignImmD => SignImmD,
		clr => FlushE,
		JALDataD => JALDataD,
		
		RegWriteE => RegWriteE,
		MemtoRegE => MemtoRegE,
		MemWriteE => MemWriteE,
		ALUControlE => ALUControlE,
		ALUSrcE => ALUSrcE,
		RegDstE => RegDstE,
		LoadControlE => LoadControlE,
		
		RD1Mux1 => RD1toMux1,
		RD2Mux2 => RD2toMux2,
		RsE => RsE,
		RtE => RtE,
		RdE => RdE,
		SignImmE => SignImmE,
		JALDataE => JALDataE
	);
	
	RegD_mux : b5_mux2_1 PORT MAP(
		in0 => RtE,
		in1 => RdE,
		mode => RegDstE,
		out0 => WriteRegE
	);
	
	FAE_mux : b32_mux4_1 PORT MAP(
		in0 => RD1toMux1,
		in1 => ResultW,
		in2 => ALUOutM,
		in3 => x"00000000",
		mode => ForwardAE,
		out0 => SrcAE
	);
	
	FBE_mux : b32_mux4_1 PORT MAP(
		in0 => RD2toMux2,
		in1 => ResultW,
		in2 => ALUOutM,
		in3 => x"00000000",
		mode => ForwardBE,
		out0 => WriteDataE
	);
	
	alu_s_mux : b32_mux2_1 PORT MAP(
		in0 => WriteDataE,
		in1 => SignImmE,
		mode => ALUSrcE,
		out0 => SrcBE
	);
	
	al : alu PORT MAP(
		Func_in => ALUControlE,
		A_in => SrcAE,
		B_in => SrcBE,
		O_out => ALU_OUT
	);
	
	
	a_reg : alu_reg PORT MAP(
			
		ref_clk => clk,
		RegWriteE => RegWriteE,
		MemtoRegE => MemtoRegE,
		MemWriteE => MemWriteE,
		LoadControlE => LoadControlE,
		
		ALU_IN => ALU_OUT,
		WriteDataE => WriteDataE,
		WriteRegE => WriteRegE,
		SignImmE => SignImmE,
		JALDataE => JALDataE,
		
		RegWriteM => RegWriteM,
		MemtoRegM => MemtoRegM,
		MemWriteM => MemWriteM,
		LoadControlM => LoadControlM,
		
		ALU_OUT => ALUOutM,
		WriteDataM => WriteDataM,
		WriteRegM => WriteRegM,
		SignImmM => SignImmM,
		JALDataM => JALDataM
	);
	
	mm : mem PORT MAP(
		
		dataI => WriteDataM,
		data0 => mem_out,
		addr => ALUOutM,
		we => MemWriteM,
		ref_clk => clk
	
	);
	
	mem_r : mem_reg PORT MAP(
		ref_clk => clk,
		RegWriteM => RegWriteM,
		MemtoRegM => MemtoRegM,
		LoadControlM => LoadControlM,
		
		ALU_IN => ALUOutM,
		RD_IN => mem_out,
		WriteRegM => WriteRegM,
		SignImmM => SignImmM,
		JALDataM => JALDataM,
		
		RegWriteW => RegWriteW,
		MemtoRegW => MemtoRegW,
		LoadControlW => LoadControlW,
		
		ALU_OUT => ALUOutW,
		RD_OUT => ReadDataW,
		WriteRegW => WriteRegW,
		SignImmW => SignImmW, 
		JALDataW =>JALDataW
	);
	
	luii : lui PORT MAP(
		in0 => SignImmW,
		out0 => shiftlui_out
	);
	
	MemtoRegWmux : b32_mux2_1 PORT MAP (
		in0 => ALUOutW,
		in1 => ReadDataW,
		mode => MemtoRegW,
		out0 => MemtoRegWmuxx_out
	);
	
	hazard : hazard_unit PORT MAP(
		BranchD=>BranchD,
		RsD=>InstrD(25 DOWNTO 21),
		RtD=>InstrD(20 DOWNTO 16),
		RsE=>RsE,
		RtE=>RtE,
		WriteRegE=>WriteRegE,
		WriteRegM=>WriteRegM, 
		WriteRegW=>WriteRegW,
		MemtoRegE=>MemtoRegE,
		RegWriteE=>RegWriteE,
		RegWriteM=>RegWriteM,
		RegWriteW=>RegWriteW,
		JumpD=>JumpD,
		StallF=>StallF,
		StallD=>StallD,
		ForwardAD=>ForwardAD,
		ForwardBD=>ForwardBD,
		FlushE=>FlushE,
		ForwardAE=>ForwardAE,
		ForwardBE=>ForwardBE	
	);
	
	jaldatamux : b32_mux4_1 PORT MAP(
		in0 => ResultW, 
		in1 => shiftlui_out,
		in2 => x"00000000",
		in3 => x"00000000",
		mode => JALDataW,
		out0 => JALDataW_out
	);
	
	load_sex : load_sec PORT MAP(
		in0 => MemtoRegWmuxx_out,
		load_control => LoadControlW,
		out0 => ResultW
	);
	
	out0 <= ALU_OUT;

end beh;