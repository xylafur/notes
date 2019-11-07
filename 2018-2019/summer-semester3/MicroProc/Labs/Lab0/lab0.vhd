library ieee;
use ieee.std_logic_1164.all;
use work.all;

-- Create an entity with 4 inputs and one output
-- name it 'Combinational Logic'
entity Combinational_Circuit is
    port(
        A: in std_logic;
        B: in std_logic;
        C: in std_logic;
        D: in std_logic;
        Y: out std_logic
    );
end Combinational_Circuit;

-- Define the behavior of the entity defined above
Architecture Behavior of Combinational_Circuit is
Begin
    -- The Architrcture contains a single process
    -- which uses all of the inputs
    Process(A,B,C,D)
    Begin
        Y <= ((A or B) and not ( C and D));
    End Process;
End Behavior;



