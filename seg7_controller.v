// =============================================================================
// 7-SEGMENT DISPLAY CONTROLLER
// Basys 3 onboard 4-digit multiplexed display
// Digits refreshed in round-robin at ~1kHz total, 250Hz per digit
// Segments and anodes are ACTIVE LOW on Basys 3
// =============================================================================
module seg7_controller (
    input  wire        clk,
    input  wire        reset,
    input  wire [3:0]  dig3,    // leftmost digit value  0-15
    input  wire [3:0]  dig2,
    input  wire [3:0]  dig1,
    input  wire [3:0]  dig0,    // rightmost digit value 0-15
    input  wire [3:0]  dp_en,   // decimal point enable per digit (bit3=dig3)
    output reg  [6:0]  seg,     // active low segments {g,f,e,d,c,b,a}
    output reg         dp,      // active low decimal point
    output reg  [3:0]  an       // active low anode select
);

    // -------------------------------------------------------------------------
    // Refresh counter - divides 100MHz to ~1kHz digit refresh
    // 100MHz / 100000 = 1kHz total, 250Hz per digit
    // $clog2 auto-sizes the counter width for any REFRESH_COUNT value
    // -------------------------------------------------------------------------
    localparam REFRESH_COUNT = 100_000;
    reg [$clog2(REFRESH_COUNT)-1:0] refresh_cnt;
    reg [1:0]  digit_sel;  // which digit is currently active 0-3

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            refresh_cnt <= 0;
            digit_sel   <= 0;
        end
        else if (refresh_cnt == REFRESH_COUNT - 1) begin
            refresh_cnt <= 0;
            digit_sel   <= digit_sel + 1;
        end
        else
            refresh_cnt <= refresh_cnt + 1;
    end

    // -------------------------------------------------------------------------
    // Digit and anode selection
    // -------------------------------------------------------------------------
    reg [3:0] current_digit;

    always @(*) begin
        case(digit_sel)
            2'd3: begin an = 4'b0111; current_digit = dig3; dp = ~dp_en[3]; end
            2'd2: begin an = 4'b1011; current_digit = dig2; dp = ~dp_en[2]; end
            2'd1: begin an = 4'b1101; current_digit = dig1; dp = ~dp_en[1]; end
            2'd0: begin an = 4'b1110; current_digit = dig0; dp = ~dp_en[0]; end
            default: begin an = 4'b1111; current_digit = 4'd0; dp = 1'b1; end
        endcase
    end

    // -------------------------------------------------------------------------
    // Segment decoder - active low on Basys 3
    // Segment order: {g, f, e, d, c, b, a}
    // -------------------------------------------------------------------------
    always @(*) begin
        case(current_digit)
            4'd0:    seg = 7'b1000000; // 0
            4'd1:    seg = 7'b1111001; // 1
            4'd2:    seg = 7'b0100100; // 2
            4'd3:    seg = 7'b0110000; // 3
            4'd4:    seg = 7'b0011001; // 4
            4'd5:    seg = 7'b0010010; // 5
            4'd6:    seg = 7'b0000010; // 6
            4'd7:    seg = 7'b1111000; // 7
            4'd8:    seg = 7'b0000000; // 8
            4'd9:    seg = 7'b0010000; // 9
            default: seg = 7'b1111111; // blank for out-of-range
        endcase
    end

endmodule
