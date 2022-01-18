module dff (input   d,
                    rstn,
                    clk,
            output  q);
    reg q;

    always @ (posedge clk) begin
        if (!rstn)
            q <= 0;
        else
            q <= d;
    end
endmodule


// Test bench module
module tb;

    // The input and output variables to drive the design
    reg tb_clk;
    reg tb_d;
    reg tb_rstn;
    reg tb_q;

    // Create an instance of the design
    dff dff0(   .clk    (tb_clk),
                .d      (tb_d),
                .rstn   (tb_rstn),
                .q      (tb_q));

    // drive the tb signals with certain values
    initial begin
        tb_rsnt     <= 1'b0;
        tb_clk      <= 1'b0;
        tb_d        <= 1'b0;

    end
endmodule

