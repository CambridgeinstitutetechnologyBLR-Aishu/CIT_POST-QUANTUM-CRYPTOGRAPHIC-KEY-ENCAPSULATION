module pqc_controller (
    input wire clk,
    input wire reset,
    input wire start,
    output reg load_high, // Signal to grab the first 8 bits
    output reg load_low,  // Signal to grab the second 8 bits
    output reg busy,
    output reg done,
    output reg [2:0] state
);
    localparam IDLE      = 3'b000;
    localparam GET_HIGH  = 3'b001;
    localparam GET_LOW   = 3'b010;
    localparam CALC      = 3'b011;
    localparam SEND_OUT  = 3'b100;
    localparam DONE      = 3'b101;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE; busy <= 0; done <= 0;
            load_high <= 0; load_low <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (start) state <= GET_HIGH;
                end
                GET_HIGH: begin
                    busy <= 1; load_high <= 1;
                    state <= GET_LOW;
                end
                GET_LOW: begin
                    load_high <= 0; load_low <= 1;
                    state <= CALC;
                end
                CALC: begin
                    load_low <= 0;
                    state <= SEND_OUT;
                end
                SEND_OUT: state <= DONE;
                DONE: begin
                    busy <= 0; done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
