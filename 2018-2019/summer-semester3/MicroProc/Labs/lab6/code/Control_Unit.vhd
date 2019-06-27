library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity Control_Unit is
port(
    Op          : in std_logic_vector(5 downto 0);
    RegDst      : out std_logic;
    Branch      : out std_logic;
    MemRead     : out std_logic;
    MemtoReg    : out std_logic;
    ALUOp       : out std_logic_vector(1 downto 0);
    MemWrite    : out std_logic;
    ALUSrc      : out std_logic;
    RegWrite    : out std_logic
);
end Control_Unit;

architecture behav of Control_Unit is
    signal Rformat, lw,sw,beq : std_logic;
begin
    -- Assign all of the outputs based on the operation
    -- The operation is determined by the first 6 bits of the instruction

    Rformat     <= ((not op(5)) and (not op(4))
                    and(not op(3)) and (not op(2))
                    and (not op(1))and (not op(0)));

    lw          <= ((op(5)) and (not op(4))and(not op(3))
                    and (not op(2))and (op(1))and (op(0)));

    sw          <= ((op(5)) and (not op(4))and(op(3))
                    and (not op(2))and (op(1))and (op(0)));

    beq         <= ((not op(5)) and (not op(4)) and (not op(3))
                    and (op(2))and (not op(1))and (not op(0)));

    RegDst      <= Rformat;
    ALUSrc      <= (lw or sw);
    MemtoReg    <= lw;
    RegWrite    <= (Rformat or lw);
    MemRead     <= lw;
    MemWrite    <= sw;
    Branch      <= beq;
    ALUOp(1)    <= Rformat;
    ALUOp(0)    <= beq;
end behav;
