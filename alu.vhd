library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


ENTITY alu IS
PORT (
	Func_in : IN std_logic_vector (5 DOWNTO 0);
	A_in : IN std_logic_vector (31 DOWNTO 0);
	B_in : IN std_logic_vector (31 DOWNTO 0);
	O_out : OUT std_logic_vector (31 DOWNTO 0)
	--Branch_out : OUT std_logic 
);
END alu ;

architecture Behavioral of alu is
	
	signal temp: std_logic_vector(31 downto 0);
	signal Branch_out : std_logic;
begin

		
impl:	process(Func_in, A_in, B_in)
		VARIABLE ONE : std_logic_vector (31 DOWNTO 0) := "00000000000000000000000000000001";
		VARIABLE ZERO : std_logic_vector (31 DOWNTO 0) := "00000000000000000000000000000000";
	begin
			case Func_in is
			-- 000X00 is shift left logical
					when "000000" => O_out <= std_logic_vector(unsigned(B_in) sll to_integer(unsigned(A_in)));
									Branch_out <= '0';
					when "000100" => O_out <= std_logic_vector(unsigned(B_in) sll to_integer(unsigned(A_in)));
									Branch_out <= '0';
			-- 000X10 is shift right logical
					when "000010" => O_out <= std_logic_vector(unsigned(B_in) srl to_integer(unsigned(A_in)));
									Branch_out <= '0';
					when "000110" => O_out <= std_logic_vector(unsigned(B_in) srl to_integer(unsigned(A_in)));
									Branch_out <= '0';
			-- 000X11 is shift right arithmitic 
					when "000011" => O_out <= std_logic_vector(unsigned(B_in) ror to_integer(unsigned(A_in)));
									Branch_out <= '0';
					when "000111" => O_out <= std_logic_vector(unsigned(B_in) ror to_integer(unsigned(A_in)));
									Branch_out <= '0';
			-- 100000 is signed add
					when "100000" => O_out <= std_logic_vector(signed(A_in) + signed(B_in));
									Branch_out <= '0';

			-- 100001 is unsigned add						
					when "100001" => O_out <= std_logic_vector(unsigned(A_in) + unsigned(B_in));
									Branch_out <= '0';
									
			-- 100010 is signed subtract						
					when "100010" => O_out <= std_logic_vector(signed(A_in) - signed(B_in));
									Branch_out <= '0';
									
			-- 100011 is unsigned subtract						
					when "100011" => O_out <= std_logic_vector(unsigned(A_in) - unsigned(B_in));
									Branch_out <= '0';
									
			-- 100100 is A AND B						
					when "100100" => O_out <= A_in AND B_in;
									Branch_out <= '0';
									
			-- 100101 is A OR B						
					when "100101" => O_out <= A_in OR B_in;
									Branch_out <= '0';
									
			-- 100110 is A XOR B						
					when "100110" => O_out <= A_in XOR B_in;
									Branch_out <= '0';
									
			-- 100111 is A NOR B						
					when "100111" => O_out <= A_in NOR B_in;
									Branch_out <= '0';
									
			-- 101000 is Set Less Than Signed (signed(A) < signed(B))						
					when "101000" => temp <= std_logic_vector(signed(A_in) - signed(B_in));
						if  SIGNED(temp) < 0 then
							O_out <= ONE;
						else
							O_out <= (OTHERS=>'0');
						end if;
									Branch_out <= '0';
									
			-- 101001 is Set less than unsigned (A < B)						
					-- when "101001" => temp <= (OTHERS=> 'Z');
						-- if UNSIGNED(A_in) < UNSIGNED(B_in) then
							-- O_out <= ONE;
						-- else
							-- O_out <= ZERO;
						-- end if;
									
									
			-- 111000
					-- when "111000" => O_out <= A_in;
						-- if SIGNED(A_in) < 0 then
							-- Branch_out <= '1';
						-- else
							-- Branch_out <= '0';
						-- end if;
			-- 111001
					-- when "111001" => O_out <= A_in;	
						-- if SIGNED(A_in) >= 0 then
							-- Branch_out <= '1';
						-- else
							-- Branch_out <= '0';
						-- end if;
			-- 111100
					-- when "111100" => O_out <= A_in;
						-- if SIGNED(A_in) = SIGNED(B_in) then
							-- Branch_out <= '1';
						-- else
							-- Branch_out <= '0';
						-- end if;
			-- 111101
					-- when "111101" => O_out <= A_in;
						-- if SIGNED(A_in) /= SIGNED(B_in) then
							-- Branch_out <= '1';
						-- else
							-- Branch_out <= '0';
						-- end if;
			-- 111110
					-- when "111110" => O_out <= A_in;
						-- if SIGNED(A_in) <= 0 then
							-- Branch_out <= '1';
						-- else
							-- Branch_out <= '0';
						-- end if;
			-- 111111
					-- when "111111" => O_out <= A_in;
						-- if SIGNED(A_in) > 0 then
							-- Branch_out <= '1';
						-- else
							-- Branch_out <= '0';
						-- end if;
			
			--others
					when others => O_out <= (OTHERS=> 'Z');
									Branch_out <= '0';
			end case;
			
	
	
	end process;

end Behavioral;