`default_nettype none

module tt_um_pqc_aishu (
    input  wire [7:0] ui_in,    // Input A (4 bits) and Input B (4 bits)
    output wire [7:0] uo_out,   // Result (Sum or Diff)
    input  wire [7:0] uio_in,   
    output wire [7:0] uio_out,  
    output wire [7:0] uio_oe,   
    input  wire       ena, clk, rst_n     
);

    // We split the 8-bit input: 4 bits for 'a' and 4 bits for 'b'
    // We keep omega (the twiddle factor) as a constant 2 for the test
    wire [15:0] a_val = {12'b0, ui_in[7:4]};
    wire [15:0] b_val = {12'b0, ui_in[3:0]};
    wire [15:0] omega = 16'd2;

    wire [15:0] out_a, out_b;

    // Direct instantiation of your NTT Butterfly Unit
    butterfly_unit ntt_core (
        .a(a_val),
        .b(b_val),
        .omega(omega),
        .out_a(out_a),
        .out_b(out_b)
    );

    // Output the transformed 'A' result to the pins
    assign uo_out = out_a[7:0]; 

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
