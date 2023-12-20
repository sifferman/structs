
module float (
    input   logic               clk_i,
    input   logic               rst_i,
    input   logic               wen_i,
    input   float_pkg::float_t  wdata_i

    ,output logic                                       sign_o
    ,output logic [float_pkg::MantissaWidth:0]          significand_o
    ,output logic [float_pkg::BiasedExponentWidth-1:0]  exponent_o
);

    float_pkg::float_t data_q;

    always_comb begin
        sign_o = float_pkg::float_sign(data_q);
        significand_o = float_pkg::float_significand(data_q);
        exponent_o = float_pkg::float_exponent(data_q);
    end

    always_ff @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            data_q <= '0;
        end else if (wen_i) begin
            data_q <= wdata_i;
        end
    end

endmodule
