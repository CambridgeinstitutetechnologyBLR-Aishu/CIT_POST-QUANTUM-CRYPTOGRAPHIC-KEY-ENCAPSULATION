module pqc_top (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] data_in,     // 8-bit Input
    output reg [7:0] data_out,    // 8-bit Output
    output wire done
);
    wire load_high, load_low;
    reg [15:0] internal_a;
    wire [15:0] res_a, res_b;

// Logic to combine 8-bit chunks into 16-bit math
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            internal_a <= 16'd0;
        end else begin
            if (load_high) internal_a[15:8] <= data_in;
            if (load_low)  internal_a[7:0]  <= data_in;
        end
    end

    pqc_controller brain (
        .clk(clk), .reset(reset), .start(start),
        .load_high(load_high), .load_low(load_low),
        .done(done)
    );

    butterfly_unit unit_0 (
        .a(internal_a), .b(16'd5), .omega(16'd2),
        .out_a(res_a), .out_b(res_b)
    );

// Output only the lower 8 bits for the demo
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 8'h00; // Start at 0 so we don't get 'xx'
        end else if (done) begin
            data_out <= res_a[7:0]; // Capture the result when finished
        end
    end
endmodule
