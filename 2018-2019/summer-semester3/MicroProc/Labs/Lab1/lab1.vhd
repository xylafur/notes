------------------------------------------
-- Lab 1 ---------------------------------
------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
port(
    -- we have both a and be stored as signed numbers, this
    -- will allow us to do signed arithmetic
    sel : in std_logic_vector (3 downto 0);
    inp_a : in signed(3 downto 0);
    inp_b : in signed(3 downto 0);

    out_alu : out signed(3 downto 0)
);
end ALU;

architecture Behavioral of ALU is
begin
process(inp_a, inp_b, sel)
begin
    case sel is
        when "0000" =>
            out_alu <= inp_a + inp_b;
        when "0001" =>
            out_alu <= inp_a - inp_b; --subtraction
        when "0010" =>
            out_alu <= inp_a - 1; --sub 1
        when "0011" =>
            out_alu <= inp_a + 1; --add 1
        when "0100" =>
            out_alu <= inp_a and inp_b; --AND gate
        when "0101" =>
            out_alu <= inp_a or inp_b; --OR gate
        when "0110" =>
            out_alu <= not inp_a ; --NOT gate
        when "0111" =>
            out_alu <= inp_a xor inp_b; --XOR gate
        when "1000" =>
            out_alu <= inp_a sll 2; -- left shift by 2
        when "1001" =>
            out_alu <= inp_b srl 3; --right logical shift
        when "1010" =>
            out_alu <= inp_a rol 1; --Rotate left logical
        when "1011" =>
            out_alu <= inp_b ror 2; --Rotate right logical
        when others =>
            NULL;
    end case;
end process;
end Behavioral;

