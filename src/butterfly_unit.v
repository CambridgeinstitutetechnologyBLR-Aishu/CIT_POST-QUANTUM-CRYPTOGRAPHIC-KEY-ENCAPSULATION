module butterfly_unit (
    input wire [15:0] a,        // Input coefficient A
    input wire [15:0] b,        // Input coefficient B
    input wire [15:0] omega,    // Twiddle factor (constant)
    output wire [15:0] out_a,   // Output A'
    output wire [15:0] out_b    // Output B'
);
    wire [31:0] mult_res;
    wire [11:0] reduced_b;

    // 1. Multiply B by the twiddle factor
    assign mult_res = b * omega;

    // 2. Reduce the result using your Montgomery Reducer
    montgomery_red red_inst (
        .a(mult_res),
        .b(1), // We just want to reduce mult_res
        .result(reduced_b)
    );

    // 3. Butterfly operations: A' = A + (B*W) and B' = A - (B*W)
    assign out_a = (a + reduced_b) % 3329;
    assign out_b = (a >= reduced_b) ? (a - reduced_b) : (a + 3329 - reduced_b);

endmodule
