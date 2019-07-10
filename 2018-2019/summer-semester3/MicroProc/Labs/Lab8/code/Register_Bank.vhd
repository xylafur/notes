library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Register_Bank is
    generic(
        width   :   integer:=2; -- size of the vector
        depth   :   integer:=4; -- size of the array
        addr    :   integer:=2  -- size of read/write vector
    );
    port(
        Clock       :   in std_logic;
        Enable      :   in std_logic;
        Reg_Addr_A  :   in std_logic_vector(addr-1 downto 0);
        Reg_Addr_B  :   in std_logic_vector(addr-1 downto 0);
        Data_out_A  :   out std_logic_vector(width-1 downto 0);
        Data_out_B  :   out std_logic_vector(width-1 downto 0)
    );
end Register_Bank;

-- On positive clock edge, if enabled, just take data from the given register locations
-- and put the into the coresponding data out
architecture behav of Register_Bank is
    type ram_type is array (0 to depth-1) of std_logic_vector(width-1 downto 0);
    signal tmp_ram: ram_type;
begin
    -- Store these values into RAM at these addresses
    tmp_ram(conv_integer(0)) <="00";
    tmp_ram(conv_integer(1)) <="01";
    tmp_ram(conv_integer(2)) <="10";
    tmp_ram(conv_integer(3)) <="11";

    process(Clock)
    begin
        if (Clock'event and Clock='1') then
            if Enable='1' then
                Data_out_A <= tmp_ram(conv_integer(Reg_Addr_A));
                Data_out_B <= tmp_ram(conv_integer(Reg_Addr_B));
            end if;
        end if;
    end process;
end behav;
