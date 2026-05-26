`default_nettype none

module tt_um_pqc_aishu (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path
    input  wire       ena,      // always 1
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // Tiny Tapeout uses Active Low reset, so we invert it for our code
    wire reset_high = !rst_n;

    // We don't use the bidirectional pins, so set them to 0
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    // Instantiate your working 8-bit PQC core
    pqc_top my_core (
        .clk(clk),
        .reset(reset_high),
        .start(ui_in[7]),       // We use bit 7 as the 'start' signal
        .data_in(ui_in[6:0]),   // We use bits 0-6 for data
        .data_out(uo_out),
        .done()                 
    );

endmodule
