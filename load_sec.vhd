library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

--------------- load_sec ---------------
--
--	
--	controls whats goes to register after 
--	memory mux
--	2 inputs: 32 bit after memreg (mux that takes mem and alu)
--	load control from controller (3 bits)
--	000 -> Load byte 
--	001 -> Load Half 
--	010 -> Load byte unsigned
--	011 -> Load half unsigned
--	1-- -> load word


entity load_sec is
	port(
	in0 : IN STD_LOGIC_VECTOR(31 downto 0);
	load_control : IN STD_LOGIC_VECTOR (2 downto 0);
	out0 : OUT STD_LOGIC_VECTOR(31 downto 0)
	);
end load_sec;

architecture beh of load_sec is

	signal load_byte_sextended : STD_LOGIC_VECTOR(31 downto 0);
	signal load_half_sextended : STD_LOGIC_VECTOR(31 downto 0);
	
	signal sextended_mux : STD_LOGIC_VECTOR(31 downto 0);
	
	signal load_byte_uextended : STD_LOGIC_VECTOR(31 downto 0);
	signal load_half_uextended : STD_LOGIC_VECTOR(31 downto 0);
	
	signal uextended_mux : STD_LOGIC_VECTOR(31 downto 0);
	
	signal extend_mux : STD_LOGIC_VECTOR(31 downto 0);
begin

	load_byte_sextended <= std_logic_vector(resize(signed(in0(7 downto 0)), load_byte_sextended'length));
	load_half_sextended <= std_logic_vector(resize(signed(in0(15 downto 0)), load_half_sextended'length));

	load_byte_uextended <= "000000000000000000000000" & in0(7 downto 0);
	load_half_uextended <= "0000000000000000" & in0(15 downto 0);
	
	sextended_mux <= load_byte_sextended when load_control(0)='0' else load_half_sextended;
	uextended_mux <= load_byte_uextended when load_control(0)='0' else load_half_uextended;
	
	extend_mux <= sextended_mux when load_control(1)='0' else uextended_mux;
	
	out0 <= extend_mux when load_control(2)='0' else in0;
	
	
	
end beh;