------------------------------------------
-- Lab 2 ---------------------------------
------------------------------------------
--- Code for the Encoder / Decoder
---
library ieee;
use ieee.std_logic_1164.all;
entity EncDec is
port(
    A : in std_logic_vector (7 downto 0);       --- Encoder Input
    B : out std_logic_vector (2 downto 0);      --- Encoder Output

    C : in std_logic_vector (2 downto 0);       --- Decoder Input
    D : out std_logic_vector (7 downto 0)       --- Decoder Output
);

end entity;

architecture behavioral of EncDec is
begin

--- This process is for the Encoder
process(A)
begin
	Case A is
		when "00000001" =>B<= "000";
		when "00000010" =>B<= "001";
		when "00000100" =>B<= "010";
		when "00001000" =>B<= "011";
		when "00010000" =>B<= "100";
		when "00100000" =>B<= "101";
		when "01000000" =>B<= "110";
		when "10000000" =>B<= "111";
		when others => B<="000";			--8 to 3 encoder behavior
	end case;
end process;

process(C)
begin
	case C is
		when "000"=>D<="00000001";			----- 0 (0123456)
		when "001"=>D<="00000010";			----- 1
		when "010"=>D<="00000100";			----- 2
		when "011"=>D<="00001000";			----- 3
		when "100"=>D<="00010000";			----- 4
		when "101"=>D<="00100000";			----- 5
		when "110"=>D<="01000000";			----- 6
		when "111"=>D<="10000000";			----- 7
	end case;
end process;
end behavioral;
