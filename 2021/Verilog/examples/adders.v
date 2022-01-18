module ha(input  a, b,
          output reg sum, cout);
    always @ (a or b) begin
        {cout, sum} = a + b;
    end
endmodule

module fa(input  a, b, cin,
          output reg sum, cout);
    always @ (a or b or cin) begin
        {cout, sum} = a + b + cin;
    end
endmodule

module adder(input      [3:0] a,
             input      [3:0] b,
             output reg [3:0] out,
             output reg       carry);
    wire [3:0] tmp_carry;
    wire [3:0] sum;

    ha ha1 (.a(a[0]), .b(b[0]), .sum(sum[0]), .cout(tmp_carry[0]));
    fa fa1 (.a(a[1]), .b(b[1]), .cin(tmp_carry[0]), .sum(sum[1]), .cout(tmp_carry[1]));
    fa fa2 (.a(a[2]), .b(b[2]), .cin(tmp_carry[1]), .sum(sum[2]), .cout(tmp_carry[2]));
    fa fa3 (.a(a[3]), .b(b[3]), .cin(tmp_carry[2]), .sum(sum[3]), .cout(tmp_carry[3]));

    always @ (a or b) begin
        out   <= sum;
        carry <= tmp_carry[3];
    end
endmodule


module tb;
    reg  [3:0] in1;
    reg  [3:0] in2;
    wire [3:0] out;
    wire       carry;

    adder my_adder (.a(in1), .b(in2), .out(out), .carry(carry));

    initial begin

        $monitor("in1:%0h, in2:%0h, out:%0h, carry:%0h", in1, in2, out, carry);

        in1 <= 4'h0;
        in2 <= 4'h0;
        #5

        #5 in1 <= 4'h5;
        #5 in2 <= 4'h5;

        #5 in1 <= 4'ha;
        #5
        #5 $finish;

    end


endmodule
