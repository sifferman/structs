
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

// Pretty-printing of float.data_q after synthesis
float_pkg::float_t  data_q;
assign data_q = float.data_q;

initial begin
    clk_i = 1;
    forever begin
        #1;
        clk_i = ~clk_i;
    end
end

initial begin
    $dumpfile( "dump.fst" );
    $dumpvars;
    wen_i = 1;
    for (integer i = 0; i < 5; i++) begin
        wdata_i = $random;
        @(posedge clk_i);
    end
    $finish;
end

endmodule
