library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity equality is
	generic(
		Width: positive := 32 --number of bits
	);
	port(
		inA : IN STD_LOGIC_VECTOR(Width-1 DOWNTO 0); --inputA
		inB : IN STD_LOGIC_VECTOR(Width-1 DOWNTO 0); --inputB
		ALUControl : IN STD_LOGIC_VECTOR (5 DOWNTO 0); -- checks branch type
		outE : OUT STD_LOGIC --output
	);
end equality;

architecture beh of equality is

begin
	process(inA, inB, ALUControl)
	
	begin
		case ALUControl is
		
			--bltz
			when "111000" => 
				if (signed(inA) < 0) then
					outE <= '1';
				else
					outE <= '0';
				end if;
				
			--bgez
			when "111001" => 
				if (signed(inA) >= 0) then
					outE <= '1';
				else
					outE <= '0';
				end if;
				
			--beq
			when "111100" => 
				if (signed(inA) = signed(inB)) then
					outE <= '1';
				else
					outE <= '0';
				end if;
				
			--bne
			when "111101" => 
				if (signed(inA) /= signed(inB)) then
					outE <= '1';
				else
					outE <= '0';
				end if;
		
			--blez
			when "111110" => 
				if (signed(inA) <= 0) then
					outE <= '1';
				else
					outE <= '0';
				end if;
				
			--bgtz
			when "111111" => 
				if (signed(inA) < 0) then
					outE <= '1';
				else
					outE <= '0';
				end if;
				
				
			when others =>
				outE <= '0';
		
		end case;
	
	
	end process;
end beh;