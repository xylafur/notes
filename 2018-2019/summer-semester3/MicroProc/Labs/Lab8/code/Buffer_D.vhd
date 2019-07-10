library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Buffer_D is
    Port (
        CLK : in  STD_LOGIC;
        Data_in: in std_LOGIC_VECTOR (1 downto 0);
        Data_out: out std_LOGIC_VECTOR (1 downto 0)
    );
end Buffer_D;

architecture Behavioral of Buffer_D is
    signal buff : STD_LOGIC_VECTOR(1 downto 0);
begin
    process (CLK)
    begin
        --if (clock_div(4)'event and clock_div(4) = '1') then

        -- On rising clock edge move data into buffer
        if(CLK='1' and CLK'event) then
            buff <= Data_in ;

        end if;
    end process;

    Data_out <= buff;

end Behavioral;
