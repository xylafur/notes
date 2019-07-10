---------------------------------------------------
--REGISTER BANK
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Register_Bank is
generic(    width   :   integer:=32;    -- size of the vector
            depth   :   integer:=4;     -- size of the array
            addr    :   integer:=2      -- size of read/write vector
);

port(
    Clock           :   in std_logic;
    Addr_Bus        :   in std_logic_vector(addr-1 downto 0);
    Data_out        :   out std_logic_vector(width-1 downto 0)
);
end Register_Bank;

-- The entire purpose of this module is to take an address from the main
-- control unit and then return the instructions in memory at that address
architecture behav of Register_Bank is
    -- Define a ram_type array of vectors
    type ram_type is array (0 to depth-1) of std_logic_vector(width-1 downto 0);
    signal tmp_ram: ram_type;
begin
    -- In the given code, the first 6 bits for index 1 and index 3 were
    -- incorrect.
    tmp_ram(conv_integer(0)) <="00000010000110000110000110000110";
    tmp_ram(conv_integer(1)) <="10001110000110000110000110000110";
    tmp_ram(conv_integer(2)) <="10101110000110000110000110000110";
    tmp_ram(conv_integer(3)) <="00010010000110000110000110000110";

    process(Clock)
    begin
    if (Clock'event and Clock='1') then
                Data_out <= tmp_ram(conv_integer(Addr_Bus));
        end if;
    end process;
end behav;

