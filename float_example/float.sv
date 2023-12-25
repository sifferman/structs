/*
 * File: float_example/float.sv
 * Author: Ethan Sifferman
 * Description: Module that demonstrates the float_pkg struct and functions
 */

module float (
    input   logic               clk_i,
    input   logic               rst_i,
    input   logic               wen_i,
    input   float_pkg::float_t  wdata_i,

    output  float_pkg::float_t  data_plus1_o,

    output logic                                       sign_o,
    output logic [float_pkg::MantissaWidth:0]          significand_o,
    output logic [float_pkg::BiasedExponentWidth-1:0]  exponent_o
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

    `ifndef SYNTHESIS
    always_comb begin
        logic [float_pkg::MantissaWidth+1:0] temp_sum = 'x;
        data_plus1_o = data_q;
        if (data_q.biased_exponent > (float_pkg::Bias + 32)) begin // numbers greater than 2^32
            data_plus1_o = data_q; // round off +1
        end else if (data_plus1_o.biased_exponent < (float_pkg::Bias)) begin // numbers less than 1
            data_plus1_o.mantissa = {1'b1, data_q.mantissa} >> (float_pkg::Bias - data_plus1_o.biased_exponent);
            data_plus1_o.biased_exponent = float_pkg::Bias;
        end else begin
            temp_sum = {2'b1, data_q.mantissa} + ({2'b1, float_pkg::MantissaWidth'(0)} >> (data_plus1_o.biased_exponent - float_pkg::Bias));
            if (temp_sum[float_pkg::MantissaWidth+1]) begin // renormalizing needed
                data_plus1_o.mantissa = (temp_sum >> 1);
                data_plus1_o.biased_exponent = (data_q.biased_exponent + 1);
            end else begin // no renormalizing
                data_plus1_o.mantissa = temp_sum;
                data_plus1_o.biased_exponent = data_q.biased_exponent;
            end
        end
    end
    `endif

endmodule
