library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity Decoder is
    port(
        clock   : in  std_logic;
        Frame   : in std_logic_vector(5 downto 0);
        RAd1    : out std_logic_vector(1 downto 0);
        RAd2    : out std_logic_vector(1 downto 0);
        Op_code : out std_logic_vector(1 downto 0)
    );
end Decoder;


-- Just takes in the frame and seperates out the other components such as the
-- register addresses and opcode
architecture behav of Decoder is
begin
    process(Frame,clock)
    begin
        if (Clock'event and Clock='1') then
            Op_code <= Frame (5 downto 4);
            RAd1 <= Frame (3 downto 2);
            RAd2 <= Frame (1 downto 0);
        end if;
    end process;
end behav;
