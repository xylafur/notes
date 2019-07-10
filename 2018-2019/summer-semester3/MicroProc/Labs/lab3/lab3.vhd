
library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

---------------------------------------------------

entity reg is
generic(n: natural :=2);
port(
    I:      in std_logic_vector(n-1 downto 0);
    clock:  in std_logic;
    load:   in std_logic;
    clear:  in std_logic;
    Q:      out std_logic_vector(n-1 downto 0)
);
end reg;

----------------------------------------------------

architecture behv of reg is
    signal Q_tmp: std_logic_vector(n-1 downto 0);
begin
    process(clock, I, clear)
    begin
        if clear = '0' then
                -- use 'range in signal assigment 
                Q_tmp <= (Q_tmp'range => '0');
        elsif (clock='1' and clock'event) then
            if load = '1' then
                Q_tmp <= I;-------------------------------- Fill This
            end if;
        end if;
    end process;
    -- concurrent statement
    Q <= Q_tmp;
end behv;\

-----------------------------------------------------------------------------
-- lab 3 b 
-----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ShiftRegister is
    Port ( CLK : in  STD_LOGIC;
           Data   : in  STD_LOGIC;
           Output: out STD_LOGIC_VECTOR(7 downto 0));
end ShiftRegister ;
    
architecture Behavioral of ShiftRegister is
    signal shift_reg : STD_LOGIC_VECTOR(7 downto 0) := X"00";
begin
process (CLK,Data)
    begin
    if(CLK='1' and CLK'event) then
            shift_reg(7) <= Data;
            shift_reg(6) <= shift_reg(7);
            shift_reg(5) <= shift_reg(6);
            shift_reg(4) <=shift_reg (5);
            shift_reg(3) <= shift_reg(4);
            shift_reg(2) <= shift_reg(3);
            shift_reg(1) <= shift_reg(2);
            shift_reg(0) <= shift_reg(1);
        end if;
    end process;
    Output <= shift_reg;
end Behavioral;

-----------------------------------------------------------------------------
-- lab 3 c
-----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity clock is
  port (
    clk_50Mhz : in  std_logic;
    rst       : in  std_logic;
    clk_2Hz   : out std_logic);
end clock;

architecture Behavioral of clock is
    signal prescaler : unsigned(23 downto 0);
    signal clk_2Hz_i : std_logic;
begin
    gen_clk : process (clk_50Mhz, rst)
    begin
        -- if the user wants to reset, we don't care about it hapening on a
        -- clock edge, it is an async event
        if rst = '1' then
          clk_2Hz_i   <= '0';
          prescaler   <= (others => '0');

        elsif rising_edge(clk_50Mhz) then   -- rising clock edge
            -- ifthis is a rising clock edge, and we've gong through the
            -- correct amount of clock systems, we want to toggle the pin which
            -- represents our new clock signal
            if prescaler = X"BEBC20" then     -- 12 500 000 in hex
                prescaler   <=(others => '0');
                clk_2Hz_i   <=not clk_2Hz_i;
            else
                prescaler <= prescaler+"1";
            end if;
        end if;
    end process gen_clk;

    -- just use a concurrent statement
    clk_2Hz <= clk_2Hz_i;
end Behavioral;

-----------------------------------------------------------------------------
-- lab 3 d
-----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

use IEEE.NUMERIC_STD.all;

entity Frequency_Divider is
    port (
        clk_50Mhz :     in  std_logic;
        rst :           in  std_logic;
        clk_4Hz :       out std_logic;
        STATUS_LED :    out std_logic;
        HEX :           out std_logic_vector(6 downto 0);
        HEX1 :          out std_logic_vector(6 downto 0);
        DIR :           in std_logic
    );
end Frequency_Divider;

architecture Behavioral of Frequency_Divider is
    -- the scale for out second clock
    signal prescaler :  unsigned(23 downto 0);
    -- the input signal for our main clock
    signal clk_4Hz_i :  std_logic;

    -- these are used to hold the values for the digits we increment
    signal counter :    integer range 0 to 9 := 0;
    signal counter1 :   integer range 0 to 9 := 0;
begin


  -- in this case we have three seperate processes.
  -- One generates the second clock based of off the original one
  -- the second increments out counters based on those clocks
  -- the third encodes that number into a value that is applied to the 7
  -- segment displays
  gen_clk : process (clk_50Mhz, rst)
  begin
    if rst = '1' then
      clk_4Hz_i   <= '0';
      prescaler   <= (others => '0');
    elsif rising_edge(clk_50Mhz) then   -- rising clock edge
      -- same as before, only toggle out second clock after enough iterations
        -- of the original clock
      if prescaler = X"BEBC20" then     -- 12 500 000 in hex
        prescaler   <= (others => '0');
        clk_4Hz_i   <= not clk_4Hz_i;
      else
        prescaler <= prescaler + "1";
      end if;
    end if;
  end process gen_clk;
  
  process (clk_4Hz_i)
    begin
    if (clk_4Hz_i = '1') then
        if (DIR = '0') then
            if (counter < 9) then
                counter <= counter + 1;
            else
                counter <= 0;
                if (counter1 < 9) then
                    counter1 <= counter1 + 1;
                else 
                    counter1 <= 0 ;
                end if;
            end if;
            if (counter = 9 and counter1 = 9) then
                STATUS_LED <= '1';
            end if; 
        elsif (DIR = '1') then
            if (counter > 0) then
                counter <= counter - 1;
            else
                counter <= 9;
                if (counter1 > 0) then
                    counter1 <= counter1 - 1;
                else 
                    counter1 <= 9 ;
                end if;
            end if;
            if (counter = 0 and counter1 = 0) then
                STATUS_LED <= '0' ;
            end if;
        end if;
    end if;
   end process; 

   process(counter,counter1)    
    begin
    case counter is
        when 0 => HEX <= "0000001";
        when 1 => HEX <= "1001111";
        when 2 => HEX <= "0010010";
        when 3 => HEX <= "0000110";            
        when 4 => HEX <= "1001100";
        when 5 => HEX <= "0100100";
        when 6 => HEX <= "0100000";
        when 7 => HEX <= "0001111";
        when 8 => HEX <= "0000000";
          when 9 => HEX <= "0000100";
    end case; 
    case counter1 is
        when 0 => HEX1 <= "0000001";
        when 1 => HEX1 <= "1001111";
        when 2 => HEX1 <= "0010010";
        when 3 => HEX1 <= "0000110";            
        when 4 => HEX1 <= "1001100";
        when 5 => HEX1 <= "0100100";
        when 6 => HEX1 <= "0100000";
        when 7 => HEX1 <= "0001111";
         when 8 => HEX1 <= "0000000";
         when 9 => HEX1 <= "0000100";
    end case; 
   end process;

    clk_4Hz <= clk_4Hz_i;
    
end Behavioral;
