library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
use IEEE.Std_Logic_Arith.all;

entity Reg_Addr_Mode is
    port(
        Clock_m         :   in std_logic;
        Enable_m        :   in std_logic;
        Data_out_m      :   out std_logic_vector(1 downto 0)
        --PC_view         :   out std_logic_vector(1 downto 0);
        --IR_view         :   out std_logic_vector(5 downto 0);
        --Reg_A_Addr_view :   out std_logic_vector(1 downto 0);
        --Reg_B_Addr_view :   out std_logic_vector(1 downto 0);
        --Opcode_view     : out std_logic_vector(1 downto 0);
        --Reg_A_DATA_view :   out std_logic_vector(1 downto 0);
        --Reg_B_DATA_view : out std_logic_vector(1 downto 0)
    );
end Reg_Addr_Mode
;

architecture struct of Reg_Addr_Mode is

-- Perform Mathemetical operations on given registers
component alu
    port(
        Clock       :   in std_logic;
        inp_a       : in std_logic_vector(1 downto 0);
        inp_b       : in std_logic_vector(1 downto 0);
        sel         : in std_logic_vector (1 downto 0);
        out_alu_m   : out std_logic_vector(1 downto 0)
    );
end component;

-- Point to the current frame in IM
component Program_Counter
    port (
        clk_PC      : in  std_logic;
        Enable_PC   : in  std_logic;
        PC_out      : out std_logic_vector (1 downto 0)
   );
end component;

-- Hold up to 4 frames
component Instruction_Memory
    generic(
        width       :   integer:=6; -- size of the vector
        depth       :   integer:=4; -- size of the array
        addr        :   integer:=2  -- size of read/write vector
    );
    port(
        Clock       :   in std_logic;
        Enable      :   in std_logic;
        Addr_Bus    :   in std_logic_vector(addr-1 downto 0);
        Data_out    :   out std_logic_vector(width-1 downto 0)
    );
end component;

-- Take in frame, parse out components
component Decoder
    port(
        clock       : in  std_logic;
        Frame       : in std_logic_vector(5 downto 0);
        RAd1        : out std_logic_vector(1 downto 0);
        RAd2        : out std_logic_vector(1 downto 0);
        Op_code     : out std_logic_vector(1 downto 0)
    );
end component;

-- Stores the contents of the 4, two bit registers
component Register_Bank
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
end component;

-- Don't start pulsing the clock until 'delay' cycles have passed
component Delay_Clock
    Port (
        clock_in    : in std_logic;
        clock_out   : out std_logic;
        delay       : in integer
    );
end component;

-- Hold data for one clock cycle, like a two bit wide D-FF
component Buffer_D
    Port (
        CLK     : in  STD_LOGIC;
        Data_in : in std_LOGIC_VECTOR (1 downto 0);
        Data_out: out std_LOGIC_VECTOR (1 downto 0)
    );
end component;

--
signal Instruction_Address  : std_logic_vector (1 downto 0);
signal Instruction          : std_logic_vector (5 downto 0);
signal Reg_A_Address        : std_logic_vector (1 downto 0);
signal Reg_B_Address        : std_logic_vector (1 downto 0);
signal Opcode               : std_logic_vector (1 downto 0);
signal Data_A               : std_logic_vector (1 downto 0);
signal Data_B               : std_logic_vector (1 downto 0);

signal DCLOCK1              : std_logic;
signal DCLOCK2              : std_logic;
signal DCLOCK3              : std_logic;
signal DCLOCK4              : std_logic;
signal Buffout              : std_LOGIC_VECTOR(1 downto 0);

begin

    D1: Delay_Clock port map(Clock_m,DCLOCK1,1);
    D2: Delay_Clock port map(Clock_m,DCLOCK2,2);
    D3: Delay_Clock port map(Clock_m,DCLOCK3,3);
    D4: Delay_Clock port map(Clock_m,DCLOCK4,4);

    -- Set up the Instruction Memory, Decoder, Buffer_D, register bank and ALU to all run
    -- on clocks that start after different number of cycles
    -- This allows us to 'PipeLine'.  This allows the previous component time to do what
    -- it needs to before the next component starts to do things
    U1: Program_Counter port map(Clock_m,Enable_m,Instruction_Address);
    U2: Instruction_Memory port map (DCLOCK1,Enable_m,Instruction_Address,Instruction);
    U3: Decoder port map (DCLOCK2,Instruction,Reg_A_Address,Reg_B_Address,Opcode);
    U4: Buffer_D port map(DCLOCK3,Opcode,Buffout);
    U5: Register_Bank port map (DCLOCK3,Enable_m,Reg_A_Address,Reg_B_Address,Data_A,Data_B);
    U6: alu port map (DCLOCK4,Data_A,Data_B,Buffout,Data_Out_m);

    --PC_view <= Instruction_Address;
    --IR_view <= Instruction;
    --Reg_A_Addr_view <= Reg_A_Address;
    --Reg_B_Addr_view <= Reg_B_Address;
    --Opcode_view <= Opcode;
    --Reg_A_DATA_view <= Data_A;
    --Reg_B_DATA_view <= Data_B;
end struct;
