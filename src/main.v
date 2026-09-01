`timescale 1ns / 1ps
// ============================================================================
// TOP MODULE - Digital Clock System
// Target: Basys 3 (XC7A35T) - 100 MHz clock
// ============================================================================
module main #(
    // Override these in testbench for fast simulation
    // e.g. SYS_CLK_FREQ=100 makes 1Hz tick fire every 100 cycles
    parameter integer SYS_CLK_FREQ = 100_000_000,
    parameter integer DEBOUNCE_MS  = 20
)(
    input  wire        clk,
    input  wire        reset,          // BTNC - center button
    input  wire        mode_sw,        // BTNL
    input  wire        start_sw,       // BTNU
    input  wire        done_sw,        // BTNR
    input  wire        silence_sw,     // BTND
    input  wire        alarm_en,       // SW0
    // Onboard 4-digit 7-segment display
    output wire [6:0]  seg,            // segments a-g (active low on Basys3)
    output wire        dp,             // decimal point (active low)
    output wire [3:0]  an,             // digit anodes (active low)
    // LEDs for debug
    output wire [2:0]  led_mode,       // LD2-LD0: current mode
    output wire        led_edit,       // LD3: editing active
    output wire        led_clken,      // LD4: 1Hz heartbeat
    output wire        led_alarm,      // LD5: alarm firing
    output wire        led_timer,      // LD6: timer firing
    output wire        led_buzzer,     // LD7: buzzer active
    output wire [4:0]  led_hrs,        // LD12-LD8: current hours in binary
    // Buzzer - connect to JA pmod pin 1
    output wire        buzzer
);

    // =========================================================================
    // 1. CLOCK DIVIDER
    // =========================================================================
    wire clken_1hz;

    tick_1hz #(.SYS_CLK_FREQ(SYS_CLK_FREQ)) tick_1hertz (
        .clk      (clk),
        .reset    (reset),
        .clken_1hz(clken_1hz)
    );

    // =========================================================================
    // 2. PUSH BUTTON DEBOUNCERS
    // =========================================================================
    wire mode_pulse, start_pulse, done_pulse, stop_pulse;

    push_button_debouncer #(
        .CLK_FREQ_HZ(SYS_CLK_FREQ),
        .DEBOUNCE_MS(DEBOUNCE_MS)
    ) mode_button (
        .clk      (clk),   .reset(reset),
        .btn_raw  (mode_sw),
        .btn_pulse(mode_pulse)
    );

    push_button_debouncer #(
        .CLK_FREQ_HZ(SYS_CLK_FREQ),
        .DEBOUNCE_MS(DEBOUNCE_MS)
    ) start_button (
        .clk      (clk),   .reset(reset),
        .btn_raw  (start_sw),
        .btn_pulse(start_pulse)
    );

    push_button_debouncer #(
        .CLK_FREQ_HZ(SYS_CLK_FREQ),
        .DEBOUNCE_MS(DEBOUNCE_MS)
    ) done_button (
        .clk      (clk),   .reset(reset),
        .btn_raw  (done_sw),
        .btn_pulse(done_pulse)
    );

    push_button_debouncer #(
        .CLK_FREQ_HZ(SYS_CLK_FREQ),
        .DEBOUNCE_MS(DEBOUNCE_MS)
    ) silence_button (
        .clk      (clk),   .reset(reset),
        .btn_raw  (silence_sw),
        .btn_pulse(stop_pulse)
    );

    // =========================================================================
    // 3. FSM - MODE CONTROLLER
    // =========================================================================
    localparam CLOCK=3'd0, SET_TIME=3'd1, ALARM=3'd2,
               TIMER=3'd3, STOPWATCH=3'd4, COUNTRY_SELECT=3'd5;

    wire [2:0] mode;
    wire [1:0] field;
    wire       edit_enable, start_action, reset_action, load;
    wire       hund;
    wire [3:0] tens, ones;

    mode_controller fsm (
        .clk         (clk),
        .reset       (reset),
        .clken_1hz   (clken_1hz),
        .mode_pulse  (mode_pulse),
        .start_pulse (start_pulse),
        .done_pulse  (done_pulse),
        .mode        (mode),
        .field       (field),
        .edit_enable (edit_enable),
        .start_action(start_action),
        .reset_action(reset_action),
        .load        (load),
        .hund        (hund),
        .tens        (tens),
        .ones        (ones)
    );

    // =========================================================================
    // 4. DEFAULT CLOCK
    // =========================================================================
    wire       edit_settime = edit_enable && (mode == SET_TIME);
    wire       load_settime = load        && (mode == SET_TIME);
    wire [5:0] clock_sec, clock_min;
    wire [4:0] clock_hrs;

    utcp_5_30 default_clock (
        .clk        (clk),
        .reset      (reset),
        .clken_1hz  (clken_1hz),
        .edit_enable(edit_settime),
        .field      (field),
        .inc_pulse  (start_pulse),
        .load       (load_settime),
        .sec        (clock_sec),
        .min        (clock_min),
        .hrs        (clock_hrs)
    );

    // =========================================================================
    // 5. ALARM
    // =========================================================================
    wire       edit_alarmtime = edit_enable && (mode == ALARM);
    wire       alarm_req;
    wire [5:0] alarm_sec, alarm_min;
    wire [4:0] alarm_hrs;

    alarm alarm_inst (
        .clk        (clk),
        .clken_1hz  (clken_1hz),
        .reset      (reset),
        .inc_pulse  (start_pulse),
        .edit_enable(edit_alarmtime),
        .field      (field),
        .sec        (clock_sec),
        .min        (clock_min),
        .hrs        (clock_hrs),
        .alarm_en   (alarm_en),
        .stop_pulse (stop_pulse),
        .asec       (alarm_sec),
        .amin       (alarm_min),
        .ahrs       (alarm_hrs),
        .alarm_req  (alarm_req)
    );

    // =========================================================================
    // 6. TIMER
    // =========================================================================
    wire       edit_timertime = edit_enable && (mode == TIMER);
    wire       timer_req;
    wire [5:0] timer_sec, timer_min;
    wire [4:0] timer_hrs;

    timer timer_inst (
        .clk         (clk),
        .clken_1hz   (clken_1hz),
        .reset       (reset),
        .inc_pulse   (start_pulse),
        .mode        (mode),
        .field       (field),
        .edit_enable (edit_timertime),
        .start_action(start_action && (mode == TIMER)),
        .stop_pulse  (stop_pulse),
        .tsec        (timer_sec),
        .tmin        (timer_min),
        .thrs        (timer_hrs),
        .timer_req   (timer_req)
    );

    // =========================================================================
    // 7. STOPWATCH
    // =========================================================================
    wire [5:0] swsec, swmin;
    wire [4:0] swhrs;

    stopwatch stop_watch (
        .clk         (clk),
        .clken_1hz   (clken_1hz),
        .reset       (reset),
        .start_action(start_action && (mode == STOPWATCH)),
        .reset_action(reset_action),
        .swsec       (swsec),
        .swmin       (swmin),
        .swhrs       (swhrs)
    );

    // =========================================================================
    // 8. BUZZER CONTROLLER
    // =========================================================================
    wire buzzer_internal;
    assign buzzer = buzzer_internal;

    buzzer_ctrl buzzer_control (
        .clk       (clk),
        .reset     (reset),
        .alarm_req (alarm_req),
        .timer_req (timer_req),
        .stop_pulse(stop_pulse),
        .buzzer    (buzzer_internal)
    );

    // =========================================================================
    // 9. BCD TO BINARY + TIMEZONE LOOKUP + OFFSET CLOCK
    // =========================================================================
    wire [7:0]        country_id;
    wire signed [4:0] offset_hrs;
    wire signed [5:0] offset_min;
    wire              load_country = load && (mode == COUNTRY_SELECT);
    wire [4:0]        tzhrs;
    wire [5:0]        tzmin, tzsec;

    bcdtobin bcd_to_binary (
        .hund(hund), .tens(tens), .ones(ones),
        .country_id(country_id)
    );

    tzwrtcountry tzwrt_country (
        .country_id(country_id),
        .offset_hrs(offset_hrs),
        .offset_min(offset_min)
    );

    offset_clock offset_clk (
        .clk       (clk),
        .clken_1hz (clken_1hz),
        .reset     (reset),
        .load      (load_country),
        .offset_min(offset_min),
        .offset_hrs(offset_hrs),
        .hrs       (clock_hrs),
        .min       (clock_min),
        .sec       (clock_sec),
        .tzsec     (tzsec),
        .tzmin     (tzmin),
        .tzhrs     (tzhrs)
    );

    // =========================================================================
    // 10. DISPLAY MUX
    // Selects time source based on mode
    // Basys 3 has 4 digits - show MM:SS (most useful for all modes)
    // Hours shown via LEDs since only 4 digits available
    // =========================================================================
    reg [4:0] disp_hrs;
    reg [5:0] disp_min, disp_sec;

    always @(*) begin
        case(mode)
            CLOCK:          begin disp_hrs=clock_hrs; disp_min=clock_min; disp_sec=clock_sec; end
            SET_TIME:       begin disp_hrs=clock_hrs; disp_min=clock_min; disp_sec=clock_sec; end
            ALARM:          begin disp_hrs=alarm_hrs; disp_min=alarm_min; disp_sec=alarm_sec; end
            TIMER:          begin disp_hrs=timer_hrs; disp_min=timer_min; disp_sec=timer_sec; end
            STOPWATCH:      begin disp_hrs=swhrs;     disp_min=swmin;     disp_sec=swsec;     end
            COUNTRY_SELECT: begin disp_hrs=tzhrs;     disp_min=tzmin;     disp_sec=tzsec;     end
            default:        begin disp_hrs=clock_hrs; disp_min=clock_min; disp_sec=clock_sec; end
        endcase
    end

    // =========================================================================
    // 11. BLINK GENERATOR FOR EDITING
    // Toggles at 1Hz - selected field blanks during edit
    // =========================================================================
    reg blink_state;
    always @(posedge clk or posedge reset) begin
        if (reset) blink_state <= 1'b0;
        else if (clken_1hz) blink_state <= ~blink_state;
    end

    // blank the selected field when blink_state=0 and editing
    // value 63 for min/sec and 31 for hrs are out of range -> displays blank
    wire [4:0] show_hrs = (edit_enable && field==2'd1 && !blink_state) ? 5'd31 : disp_hrs;
    wire [5:0] show_min = (edit_enable && field==2'd2 && !blink_state) ? 6'd63 : disp_min;
    wire [5:0] show_sec = (edit_enable && field==2'd3 && !blink_state) ? 6'd63 : disp_sec;

    // =========================================================================
    // 12. DIGIT EXTRACTION
    // Basys 3 has 4 digits - layout: [M1][M0]:[S1][S0]
    // Hours displayed on LEDs LD12-LD8 (binary) since display is only 4 digits
    // =========================================================================
    wire [3:0] dig3 = show_min / 10;   // minutes tens  -> digit 3 (leftmost)
    wire [3:0] dig2 = show_min % 10;   // minutes ones  -> digit 2
    wire [3:0] dig1 = show_sec / 10;   // seconds tens  -> digit 1
    wire [3:0] dig0 = show_sec % 10;   // seconds ones  -> digit 0 (rightmost)

    // =========================================================================
    // 13. 7-SEGMENT DISPLAY CONTROLLER
    // Basys 3 onboard 4-digit multiplexed 7-segment display
    // Multiplexing at ~1kHz (100MHz / 100000)
    // Active LOW segments and anodes on Basys 3
    // =========================================================================
    seg7_controller seg7 (
        .clk  (clk),
        .reset(reset),
        .dig3 (dig3),
        .dig2 (dig2),
        .dig1 (dig1),
        .dig0 (dig0),
        .dp_en(4'b0100),  // decimal point between dig2 and dig1 = MM.SS
        .seg  (seg),
        .dp   (dp),
        .an   (an)
    );

    // =========================================================================
    // 14. DEBUG LED ASSIGNMENTS
    // LD0-LD2:  mode (binary 0-5)
    // LD3:      edit_enable
    // LD4:      clken_1hz heartbeat
    // LD5:      alarm_req
    // LD6:      timer_req
    // LD7:      buzzer
    // LD12-LD8: hours in binary (5 bits) — shows current mode's hours
    // =========================================================================
    assign led_mode   = mode;
    assign led_edit   = edit_enable;
    assign led_clken  = clken_1hz;
    assign led_alarm  = alarm_req;
    assign led_timer  = timer_req;
    assign led_buzzer = buzzer_internal;
    assign led_hrs    = show_hrs;      // 5-bit hours on LD12-LD8

endmodule
