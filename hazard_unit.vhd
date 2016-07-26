library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY hazard_unit IS
	PORT (
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
END hazard_unit;

architecture behavior of hazard_unit is

begin

	hazard: process(BranchD, RsD, RtD, RsE, RtE, WriteRegE, WriteRegM, WriteRegW,
			MemtoRegE, RegWriteE, RegWriteM, RegWriteW)

		variable lwstall : std_logic;
		variable branchstall : std_logic;
	
	begin

	--ForwardAE
		if ((RsE /= "00000") AND (RsE = WriteRegM) AND (RegWriteM='1')) then
			ForwardAE <= "10";
		elsif ((RsE /= "00000") AND (RsE = WriteRegW) AND (RegWriteW='1')) then
			ForwardAE <= "01";
		else
			ForwardAE <= "00";
		end if;

	--ForwardBE
		if ((RtE /= "00000") AND (RtE = WriteRegM) AND (RegWriteM='1')) then
			ForwardBE <= "10";
		elsif ((RtE /= "00000") AND (RtE = WriteRegW) AND (RegWriteW='1')) then
			ForwardBE <= "01";
		else
			ForwardBE <= "00";
		end if;
		
	--ForwardAD and BD
		
		if((RsD /= "00000") AND (RsD = WriteRegM) AND (RegWriteM='1')) then
			ForwardAD <= '1';
		else 
			ForwardAD <= '0';
		end if;

		if ((RtD /= "00000") AND (RtD = WriteRegM) AND (RegWriteM='1')) then
			ForwardBD <= '1';
		else 
			ForwardBD <= '0';
		end if;


		
	--lw stall
		
		if(((RsD = RtE) OR (RtD = RtE)) AND (MemtoRegE='1')) then
			lwstall := '1';
		else 
			lwstall := '0';
		end if;

	--branch stall
		
		if(((BranchD='1') AND (RegWriteE='1') AND ((WriteRegE = RsD) OR (WriteRegE = RtD))) OR 
			((BranchD='1') AND (MemtoRegE='1') AND ((WriteRegM = RsD) OR (WriteRegM = RtD))) OR
			(JumpD='1')) then
			branchstall := '1';
		else 
			branchstall := '0';
		end if;

	--setting outputs
	
		if((lwstall='1') OR (branchstall='1')) then 
			StallF <= '1';
			StallD <= '1';
			FlushE <= '1';
		else 
			StallF <= '0';
			StallD <= '0';
			FlushE <= '0';
		end if;

	end process;
	
end behavior;