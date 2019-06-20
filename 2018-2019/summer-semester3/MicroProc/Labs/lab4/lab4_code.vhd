--A simple 4*4 RAM module
--ELET 3405

---------------------------------------------------------------
--Include the  arithmertic and unsigned ieee Library
---------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--------------------------------------------------------------
entity SRAM is
    generic(
        width:  integer:=4; -- size of the vector
        depth:  integer:=4; -- size of the array
        addr:   integer:=4   -- size of read/write vector
    );
    port(
        Clock       :   in  std_logic;
        Enable      :   in  std_logic;
        Read_Write  :   in  std_logic;
        Addr_Bus    :   in  std_logic_vector(addr-1 downto 0);
        Data_in     :   in  std_logic_vector(width-1 downto 0);
        Data_out    :   out std_logic_vector(width-1 downto 0)
    );
end SRAM;

--------------------------------------------------------------

architecture behav of SRAM is
    -- we define a type which is an array of logic vectors
    type ram_type is array (0 to depth-1) of std_logic_vector(width-1 downto 0);
    -- create a signal that is of out created type
    signal tmp_ram: ram_type;
begin
    process(Clock, Read_Write)
    begin
        -- on every rising edge
        if (Clock'event and Clock='1') then
            -- if our RAM is enabled
            if Enable='1' then
                if Read_Write='1' then
                    -- if we are reading, take the data from the address and
                    -- write it to the output
                    Data_out <= tmp_ram(conv_integer(Addr_Bus));
                elsif Read_Write='0' then
                    -- If we are set to write, write the data from input to
                    -- the address
                    tmp_ram(conv_integer(Addr_Bus)) <= Data_in;
                    Data_out <= (Data_out'range => '0');
                end if;
            end if;
        end if;
    end process;
end behav;
----------------------------------------------------------------
