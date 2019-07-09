library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--------------------------------------------------------------

entity SRAM is
    generic(
        width       :   integer:=4; -- size of the vector
        depth       :   integer:=1; -- size of the array
        addr        :   integer:=4  -- size of read/write vector
    );
    port(
        Clock       :   in std_logic;
        Enable      :   in std_logic;

        -- 1 means read, 0 means write
        Read_Write  :   in std_logic;
        Addr_Bus    :   in std_logic_vector(addr-1 downto 0);
        Data_in     :   in std_logic_vector(width-1 downto 0);
        Data_out    :   out std_logic_vector(width-1 downto 0)
    );
end SRAM;

architecture behav of SRAM is
    -- create out own type that is an array of logic vectors.
    -- This acts as a ram that holds words
    type ram_type is array (0 to depth-1) of std_logic_vector(width-1 downto 0);
    signal tmp_ram: ram_type;

begin

-- Allows for reading / writing of 'RAM'
process(Clock, Read_Write)
begin
    if (Clock'event and Clock='1') then
        if Enable='1' then

            -- Read Op
            if Read_Write='1' then
                -- Take data from out ram at the given address and write it to output
                Data_out <= tmp_ram(conv_integer(Addr_Bus));


            -- Write Op
            elsif Read_Write='0' then
                -- write the input data to ram
                tmp_ram(conv_integer(Addr_Bus)) <= Data_in;
                -- Set output data to high ipeadance
                Data_out <= (Data_out'range => 'Z');
            end if;
        end if;
    end if;
end process;
end behav;
