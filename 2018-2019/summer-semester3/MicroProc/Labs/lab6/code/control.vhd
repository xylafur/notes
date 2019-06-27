library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity control is
port(
    Clock_m         :   in std_logic;
    Addr_Bus_m      :   in std_logic_vector(1 downto 0);
    RegDst_m        :   out std_logic;
    Branch_m        :   out std_logic;
    MemRead_m       :   out std_logic;
    MemtoReg_m      :   out std_logic;
    ALUOp_m         :   out std_logic_vector(1 downto 0);
    MemWrite_m      :   out std_logic;
    ALUSrc_m        :   out std_logic;
    RegWrite_m      :   out std_logic
);
end control;

architecture struct of control is

component Register_Bank is
generic(
    width           :   integer:=32;    -- size of the vector
    depth           :   integer:=4;     -- size of the array
    addr            :   integer:=2      -- size of read/write vector
);
port(
    Clock           :   in std_logic;
    Addr_Bus        :   in std_logic_vector(addr-1 downto 0);
    Data_out        :   out std_logic_vector(width-1 downto 0)
);
end component;

component Control_Unit is
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
end component;

signal Op_m : std_logic_vector(31 downto 0);
begin
    -- The instruction is taken from memory
    U1: Register_Bank port map (Clock_m, Addr_Bus_m, Op_m);
    -- and then the instruction is passed to the control unit
    U2: Control_Unit port map (Op_m(31 downto 26), RegDst_m, Branch_m,
                               MemRead_m, MemtoReg_m, ALUOp_m, MemWrite_m,
                               ALUSrc_m, RegWrite_m);
end struct;
