module ALU(input  wire clk,
           input  wire [3:0] in1,
           input  wire [3:0] in2,
           input  wire [1:0] sel,
           output reg        carry,
           output reg  [3:0] out);

    reg [7:0] tmp;

    always @ (posedge clk)
    begin
        case (sel)
            2'b00: tmp <= in1 + in2;
            2'b01: tmp <= in1 - in2;
            2'b10: tmp <= in1 * in2;
        endcase
        carry <= tmp[4] | tmp[5] | tmp[6] | tmp[7];
        out   <= tmp[3:0];
    end
endmodule



module main;
    reg        clk;
    reg  [3:0] in1;
    reg  [3:0] in2;
    wire [3:0] out;
    wire       carry;
    reg  [1:0] sel;

    always #5 clk = ~clk;

    ALU alu(.clk(clk), .in1(in1), .in2(in2), .sel(sel), .carry(carry), .out(out));

    initial
    begin
        $monitor("clk:%0b in1:%0h in2:%0h sel:%0h carry:%0h out:%0h", clk, in1, in2, sel, carry, out);
        clk   <= 0;
        in1   <= 1'h0;
        in2   <= 1'h0;
        sel   <= 2'b10;

        #10 in1 <= 4'h2;
            in2 <= 4'h2;

        #10 in1 <= 4'h6;
            in2 <= 4'ha;
        #30 $finish;

    end
endmodule
