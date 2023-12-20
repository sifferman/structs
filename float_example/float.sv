
module float (
    input   logic               clk_i,
    input   logic               rst_i,
    input   logic               wen_i,
    input   float_pkg::float_t  wdata_i

    ,output float_pkg::float_t                          rdata_o
    ,output logic                                       sign
    ,output logic [float_pkg::MantissaWidth:0]          significand
    ,output logic [float_pkg::BiasedExponentWidth-1:0]  exponent
);

    float_pkg::float_t data_q;

    assign rdata_o = data_q;
    always_comb begin
        sign = float_pkg::float_sign(data_q);
        significand = float_pkg::float_significand(data_q);
        exponent = float_pkg::float_exponent(data_q);
    end

    always_ff @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            data_q <= '0;
        end else if (wen_i) begin
            data_q <= wdata_i;
        end
    end

endmodule
