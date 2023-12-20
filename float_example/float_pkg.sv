
package float_pkg;

// 32-Bit IEEE-754 Float
parameter integer BiasedExponentWidth = 8;
parameter integer MantissaWidth = 23;
localparam integer Bias = (1 << (BiasedExponentWidth-1))-1;

typedef struct packed {
    logic sign;
    logic [BiasedExponentWidth-1:0] biased_exponent;
    logic [MantissaWidth-1:0] mantissa;
} float_t;

function automatic logic float_sign(float_t f);
    return f.sign;
endfunction

function automatic logic [MantissaWidth:0] float_significand(float_t f);
    logic not_subnormal = (f.biased_exponent != 0);
    return {not_subnormal, f.mantissa};
endfunction

function automatic logic signed [BiasedExponentWidth-1:0] float_exponent(float_t f);
    return f.biased_exponent
        + BiasedExponentWidth'(f.biased_exponent == 0)
        - BiasedExponentWidth'(Bias);
endfunction

function automatic float_t neg(float_t f);
    localparam float_t mask = '{sign: 1, default: 0};
    return f ^ mask;
endfunction

`ifndef SYNTHESIS
function automatic real float2real(float_t f);
    real out = float_significand(f) * $pow(2, -MantissaWidth) * $pow(2, float_exponent(f));
    if (f.sign)
        out *= -1;
    return out;
endfunction
`endif

endpackage
