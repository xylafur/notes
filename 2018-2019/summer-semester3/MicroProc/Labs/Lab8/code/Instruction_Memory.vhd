library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Instruction_Memory is
    generic(
        width   :   integer:=6; -- size of the vector
        depth   :   integer:=4; -- size of the array
        addr    :   integer:=2  -- size of read/write vector
    );
    port(
        Clock   :   in std_logic;
        Enable  :   in std_logic;
        Addr_Bus:   in std_logic_vector(addr-1 downto 0);
        Data_out:   out std_logic_vector(width-1 downto 0)
    );
end Instruction_Memory;



-- On the rising clock edge, if we are enabled, just move the data at location
-- 'Addr_Bus' into Data_out
architecture behav of Instruction_Memory is
    type ram_type is array (0 to depth-1) of std_logic_vector(width-1 downto 0);
    signal tmp_ram: ram_type;
begin
    -- Store various frames in our instruction memory
    tmp_ram(conv_integer(0)) <="100001";
    tmp_ram(conv_integer(1)) <="110001";
    tmp_ram(conv_integer(2)) <="101011";
    tmp_ram(conv_integer(3)) <="111011";
    process(Clock)
    begin
        if (Clock'event and Clock='1') then
            if Enable='1' then
                Data_out <= tmp_ram(conv_integer(Addr_Bus));
            end if;
        end if;
    end process;
end behav;
