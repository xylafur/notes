library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity FSM_RRLorRLL is
    Generic(N : INTEGER:= 3);               -- Number of Input/output Bits
    port(
        W : in STD_LOGIC;                   -- RRL OR RLL logic
        Clk: in STD_LOGIC;                  -- Clock
        Enable: in STD_LOGIC;               -- Enable
        I : in signed(N-1 downto 0);        -- User Input (N bits)
        Z : out signed(N-1 downto 0)        -- User Output (N bits) Rotated
    );
end FSM_RRLorRLL;

architecture Behaviour of FSM_RRLorRLL is
    signal CurrentState: signed(N-1 downto 0); -- CurrentState Signal
begin
    Process(Enable,I,W,CLK)
    begin
        -- If enable is not asserted, set the State to the Input
        If (Enable = '0') then
            CurrentState <=  I;
        -- otherwise if the circuit is enabled
        elsif (Enable = '1') then
            -- On a rising clock edge
            If (CLK'Event AND CLK='1') then
                -- If W is set to 0, we rotate the state left
                If W = '0' then
                    CurrentState<= CurrentState rol 1;
                -- otherwise we rotate the state to the right
                elsif W ='1' then
                    CurrentState<= CurrentState ror 1;
                End if;
            End If;
        End If;
    End Process;
    -- concurrent statement, move out state into out output
    Z <= CurrentState;
end Behaviour;

