library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Delay_Clock is
    Port (
        clock_in    : in std_logic;
        clock_out   : out std_logic;
        delay       : in integer
    );
end Delay_Clock;



-- Simply wait for 'delay' cycles of the 'clock_in' signal to pass, then start
-- clocking 'clock_out' the same as the input clock
architecture Behavioral of Delay_Clock is
    signal clk : std_logic;
    signal count : integer:=0;
begin
    process(clock_in)
    begin
        if (count < delay) then
            clk <= '0';
            if falling_edge(clock_in) then
                count <= count + 1;
            end if;
        else
            clk <= clock_in;
        end if;
    end process;

    clock_out <= clk;
end Behavioral;
