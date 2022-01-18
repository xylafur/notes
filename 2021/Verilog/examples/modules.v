module dff (input       d,
            input       clk,
            input       rstn,
            output reg  q);
    always @ (posedge clk) begin
        if (!rstn)
            q <= 0;
        else
            q <= d;
    end
endmodule


module shift_reg(input d,
                 input clk,
                 input rstn,
                 output q);
    wire [2:0] q_net;
    dff u0 (.d(d),        .clk(clk), .rstn(rstn), .q(q_net[0]));
    dff u1 (.d(q_net[0]), .clk(clk), .rstn(rstn), .q(q_net[1]));
    dff u2 (.d(q_net[1]), .clk(clk), .rstn(rstn), .q(q_net[2]));
    dff u3 (.d(q_net[2]), .clk(clk), .rstn(rstn), .q(q));
endmodule


module behave;
    wire i1, i2;
    wire out;

    // Whenever i1 or i2 is changed, out is updated
    assign out = i1 & i2;
endmodule;
