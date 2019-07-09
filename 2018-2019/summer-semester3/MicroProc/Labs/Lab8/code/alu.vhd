library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
    Port (
        Clock       : in std_logic;
        inp_a       : in std_logic_vector(1 downto 0);
        inp_b       : in std_logic_vector(1 downto 0);
        sel         : in std_logic_vector (1 downto 0);
        out_alu_m   : out std_logic_vector(1 downto 0)
    );
end alu;

architecture Behavioral of alu is
    signal out_alu : signed (1 downto 0);
begin
    process(inp_a, inp_b, sel)
    begin
        if (Clock'event and Clock='1') then
            case sel is
                when "00" =>
                    out_alu <= signed(inp_a) + signed(inp_b); --addition
                when "01" =>
                    out_alu <= signed(inp_a) - signed(inp_b); --subtraction
                when "10" =>
                out_alu <= signed(inp_a) or signed(inp_b); --OR
                when "11" =>
                out_alu <= signed(inp_a) and signed(inp_b); --AND
            end case;
        end if;
    end process;

out_alu_m <= std_logic_vector(out_alu);

end Behavioral;
