library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity Program_Counter is
    port (
        clk_PC      : in  std_logic;
        Enable_PC   : in  std_logic;
        PC_out      : out std_logic_vector (1 downto 0)
    );
end Program_Counter;

-- Continually increment PC from 0 to 3
architecture Behavioral of Program_Counter is
    signal counter : integer range 0 to 3 := 0;
begin
    process (clk_PC)
    begin
        if (Enable_PC = '1') then
            if (clk_PC = '1') then
                if (counter < 4) then
                    counter <= counter + 1;
                else
                    counter <= 0 ;
                end if;
            end if;
        end if;
    end process;

    PC_out <= std_logic_vector(to_unsigned(counter, PC_out'length));
end Behavioral;
