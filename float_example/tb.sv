/*
 * File: float_example/tb.sv
 * Author: Ethan Sifferman
 * Description: Basic testbench that displays float values in a wave-dump
 */

module tb;

logic               clk_i;
logic               rst_i;
logic               wen_i;
float_pkg::float_t  wdata_i;

float float (
    .clk_i,
    .rst_i,
    .wen_i,
    .wdata_i
);

// For pretty dumping of float.data_q after synthesis
float_pkg::float_t data_q;
assign data_q = float.data_q;

initial begin
    clk_i = 1;
    forever begin
        #1;
        clk_i = ~clk_i;
    end
end

initial begin
    $dumpfile("dump.fst");
    $dumpvars;
    rst_i = 0;
    wen_i = 1;
    wdata_i = '0;
    for (integer i = 0; i < 35; i++) begin
        wdata_i.biased_exponent = float_pkg::Bias + i-3;
        @(posedge clk_i);
    end
    $finish;
end

endmodule
