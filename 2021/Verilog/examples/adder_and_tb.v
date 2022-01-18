module adder(input clk, input in1, input in2, output reg [1:0] out);
    always @ (posedge clk) begin
        out <= in1 + in2;
    end
endmodule

module main;
    reg        clk;
    reg  [2:0] in;
    wire [1:0] out;

    adder a0(.clk(clk), .in1(in[0]), .in2(in[1]), .out(out));

    always #5 clk = ~clk;

    initial
    begin
        $monitor("clk:%0b in[0]:%0b in[1]:%0b out:%0h", clk, in[0], in[1], out);
        clk = 0;
        in[1:0] <= 2'b00;
        #10 in[1:0] <= 2'b10;
        #10 in[1:0] <= 2'b11;

        #10 $finish;
    end
endmodule
