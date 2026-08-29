`timescale 1ns / 1ps

module push_button_debouncer #(
    parameter integer CLK_FREQ_HZ = 100_000_000,
    parameter integer DEBOUNCE_MS = 20
)(
    input  wire clk,          // 100 MHz system clock
    input  wire reset,
    input  wire btn_raw,       // raw push button
    output wire btn_pulse
);

    // --------------------------------------------------
    // 1. Synchronizer (CDC protection)
    // --------------------------------------------------
    reg btn_ff1, btn_ff2;

    always @(posedge clk or posedge reset) begin
    if (reset) begin
        btn_ff1 <= 0;
        btn_ff2 <= 0;
    end 
    else begin
        btn_ff1 <= btn_raw;
        btn_ff2 <= btn_ff1;
    end
    end

    // --------------------------------------------------
    // 2. Debounce counter
    // --------------------------------------------------
    localparam integer DEBOUNCE_COUNT =
        (CLK_FREQ_HZ / 1000) * DEBOUNCE_MS;

    reg [$clog2(DEBOUNCE_COUNT)-1:0] cnt;
    reg btn_level,btn_level_d; //Present and past versions of Clean signal without debounces and also waited for some time 

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            cnt       <= 0;
            btn_level <= 0;
        end
        else if (btn_ff2 == btn_level) begin
            cnt <= 0;   // stable, reset counter
        end
        else begin
            cnt <= cnt + 1;
            if (cnt == DEBOUNCE_COUNT - 1) begin
                btn_level <= btn_ff2;  // accept new state
                cnt       <= 0;
            end
        end
    end

    // --------------------------------------------------
    // 3. Rising-edge detector (press detection)
    // --------------------------------------------------
    

    always @(posedge clk or posedge reset) begin
        if (reset) 
            btn_level_d<=0; 
        else 
            btn_level_d <= btn_level;
    end
    assign btn_pulse = btn_level & ~btn_level_d;//Produces one pulse for one press 

endmodule
