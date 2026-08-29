`timescale 1ns / 1ps

// ============================================================================
// TOP MODULE TESTBENCH - Digital Clock System
// SYS_CLK_FREQ=1000 → 1Hz tick fires every 1000 cycles
// DEBOUNCE_MS=1     → debounce settles in 1ms (1 cycle at 1kHz)
// ============================================================================

module main_tb;

    // -------------------------------------------------------------------------
    // DUT signals
    // -------------------------------------------------------------------------
    reg        clk, reset;
    reg        mode_sw, start_sw, done_sw, silence_sw;
    reg        alarm_en;

    wire [2:0] led_mode;
    wire       led_edit, led_clken, led_alarm, led_timer, led_buzzer;
    wire       buzzer;

    // -------------------------------------------------------------------------
    // DUT instantiation
    // -------------------------------------------------------------------------
    main #(
        .SYS_CLK_FREQ(1000),
        .DEBOUNCE_MS (1)
    ) dut (
        .clk        (clk),
        .reset      (reset),
        .mode_sw    (mode_sw),
        .start_sw   (start_sw),
        .done_sw    (done_sw),
        .silence_sw (silence_sw),
        .alarm_en   (alarm_en),

        .seg        (),
        .dp         (),
        .an         (),

        .led_mode   (led_mode),
        .led_edit   (led_edit),
        .led_clken  (led_clken),
        .led_alarm  (led_alarm),
        .led_timer  (led_timer),
        .led_buzzer (led_buzzer),
        .buzzer     (buzzer)
    );

    // -------------------------------------------------------------------------
    // Clock : 1kHz (period = 10ns, matches SYS_CLK_FREQ=1000)
    // -------------------------------------------------------------------------
    initial clk = 0;
    always #5 clk = ~clk;

    // -------------------------------------------------------------------------
    // Utility Tasks
    // -------------------------------------------------------------------------
    task wait_cycles;
        input integer n;
    begin
        repeat(n) @(posedge clk);
    end
    endtask

    // With SYS_CLK_FREQ=1000, 1 simulated second = 1000 clock cycles
    task wait_seconds;
        input integer n;
    begin
        repeat(n * 1000) @(posedge clk);
    end
    endtask

    // -------------------------------------------------------------------------
    // Button Press Tasks
    // Hold for 30 cycles (satisfies DEBOUNCE_MS=1 → 1 cycle threshold)
    // -------------------------------------------------------------------------
    task press_mode;
    begin
        @(posedge clk);
        mode_sw = 1;
        wait_cycles(30);
        mode_sw = 0;
        wait_cycles(20);
    end
    endtask

    task press_start;
    begin
        @(posedge clk);
        start_sw = 1;
        wait_cycles(30);
        start_sw = 0;
        wait_cycles(20);
    end
    endtask

    task press_done;
    begin
        @(posedge clk);
        done_sw = 1;
        wait_cycles(30);
        done_sw = 0;
        wait_cycles(20);
    end
    endtask

    task press_silence;
    begin
        @(posedge clk);
        silence_sw = 1;
        wait_cycles(30);
        silence_sw = 0;
        wait_cycles(20);
    end
    endtask

    // -------------------------------------------------------------------------
    // PASS / FAIL checker
    // -------------------------------------------------------------------------
    task check_signal;
        input       actual;
        input       expected;
        input [63:0] test_num;
        input [127:0] label;
    begin
        if (actual === expected)
            $display("PASS | Test %0d | %0s = %b", test_num, label, actual);
        else
            $display("FAIL | Test %0d | %0s = %b (expected %b)", test_num, label, actual, expected);
    end
    endtask

    // -------------------------------------------------------------------------
    // MAIN TEST SEQUENCE
    // -------------------------------------------------------------------------
    initial begin

        // Initialize all inputs
        reset      = 1;
        mode_sw    = 0;
        start_sw   = 0;
        done_sw    = 0;
        silence_sw = 0;
        alarm_en   = 0;

        // Apply reset
        wait_cycles(20);
        reset = 0;
        wait_cycles(50);

        // =====================================================================
        $display("\n=== TEST 1: CLOCK MODE - verify clock counts ===");
        // Should be in CLOCK mode (mode=0) after reset
        check_signal(led_mode == 3'd0, 1, 1, "CLOCK mode active");
        wait_seconds(5);
        $display("Clock ran for 5 simulated seconds");

        // =====================================================================
        $display("\n=== TEST 2: SET_TIME MODE - set 12:30:00 ===");
        press_mode;   // CLOCK(0) -> SET_TIME(1)
        check_signal(led_mode == 3'd1, 1, 2, "SET_TIME mode");
        check_signal(led_edit, 1, 2, "edit_enable asserted");

        press_done;              // select HRS field
        repeat(12) press_start;  // increment to 12

        press_done;              // select MIN field
        repeat(30) press_start;  // increment to 30

        press_done;              // select SEC field (skip - leave at 0)
        press_done;              // save / exit edit

        check_signal(led_edit, 0, 2, "edit_enable cleared after save");
        wait_seconds(3);
        $display("Clock running from 12:30:00");

        // =====================================================================
        $display("\n=== TEST 3: ALARM MODE - set alarm at 12:30:10 ===");
        alarm_en = 1;
        press_mode;   // SET_TIME(1) -> ALARM(2)
        check_signal(led_mode == 3'd2, 1, 3, "ALARM mode");

        press_done; repeat(12) press_start;   // set alarm HRS = 12
        press_done; repeat(30) press_start;   // set alarm MIN = 30
        press_done; repeat(10) press_start;   // set alarm SEC = 10
        press_done;                            // save

        $display("Alarm set to 12:30:10 - waiting for trigger...");
        wait_seconds(15);
        check_signal(led_alarm, 1, 3, "alarm_req fired");
        check_signal(led_buzzer, 1, 3, "buzzer active on alarm");

        press_silence;
        wait_cycles(50);
        check_signal(led_buzzer, 0, 3, "buzzer silenced");

        // =====================================================================
        $display("\n=== TEST 4: TIMER MODE - countdown 10 seconds ===");
        press_mode;   // ALARM(2) -> TIMER(3)
        check_signal(led_mode == 3'd3, 1, 4, "TIMER mode");

        press_done;              // skip HRS field
        press_done;              // skip MIN field
        press_done;              // select SEC field
        repeat(10) press_start;  // set 10 seconds
        press_done;              // save

        press_start;             // start countdown
        $display("Timer started - waiting 12 seconds...");
        wait_seconds(12);

        check_signal(led_timer,  1, 4, "timer_req asserted at zero");
        check_signal(led_buzzer, 1, 4, "buzzer active on timer");

        press_silence;
        wait_cycles(50);
        check_signal(led_buzzer, 0, 4, "buzzer silenced after timer");

        // =====================================================================
        $display("\n=== TEST 5: STOPWATCH MODE ===");
        press_mode;   // TIMER(3) -> STOPWATCH(4)
        check_signal(led_mode == 3'd4, 1, 5, "STOPWATCH mode");

        press_start;             // start
        $display("Stopwatch running for 5 seconds...");
        wait_seconds(5);

        press_start;             // pause
        $display("Stopwatch paused - waiting 2 seconds (should not count)...");
        wait_seconds(2);

        press_start;             // resume
        $display("Stopwatch resumed for 5 more seconds...");
        wait_seconds(5);

        press_done;              // reset stopwatch
        wait_cycles(50);
        $display("Stopwatch reset");

        // =====================================================================
        $display("\n=== TEST 6: COUNTRY SELECT MODE - code 176 ===");
        press_mode;   // STOPWATCH(4) -> COUNTRY_SELECT(5)
        check_signal(led_mode == 3'd5, 1, 6, "COUNTRY_SELECT mode");

        // Enter country code 176
        press_done;              // HUND digit
        press_start;             // hund = 1

        press_done;              // TENS digit
        repeat(7) press_start;   // tens = 7

        press_done;              // ONES digit
        repeat(6) press_start;   // ones = 6

        press_done;              // load / confirm
        $display("Country code 176 loaded");
        wait_seconds(5);

        // =====================================================================
        $display("\n=== TEST 7: EDIT TIMEOUT - no activity for 7 seconds ===");
        press_mode;   // COUNTRY_SELECT(5) -> CLOCK(0)
        press_mode;   // CLOCK(0) -> SET_TIME(1)
        press_done;   // enter edit
        check_signal(led_edit, 1, 7, "edit active before timeout");

        $display("Waiting 7 seconds for timeout...");
        wait_seconds(7);
        check_signal(led_edit, 0, 7, "edit timed out");

        // =====================================================================
        $display("\n=== TEST 8: GLOBAL RESET ===");
        reset = 1;
        wait_cycles(20);
        reset = 0;
        wait_cycles(50);

        check_signal(led_mode   == 3'd0, 1, 8, "mode reset to CLOCK");
        check_signal(led_edit,           0, 8, "edit_enable cleared");
        check_signal(led_alarm,          0, 8, "alarm_req cleared");
        check_signal(led_timer,          0, 8, "timer_req cleared");
        check_signal(led_buzzer,         0, 8, "buzzer cleared");

        // =====================================================================
        $display("\n=== ALL TESTS COMPLETE ===");
        #100;
        $finish;
    end

    // -------------------------------------------------------------------------
    // MONITOR - prints whenever any signal changes
    // -------------------------------------------------------------------------
    initial begin
        $monitor("t=%0t | mode=%0d field=%0d edit=%b | disp=%0d:%0d:%0d | show=%0d:%0d:%0d | alarm=%b timer=%b buzzer=%b",
            $time,
            dut.mode,
            dut.field,
            dut.edit_enable,
            dut.disp_hrs,
            dut.disp_min,
            dut.disp_sec,
            dut.show_hrs,
            dut.show_min,
            dut.show_sec,
            led_alarm,
            led_timer,
            led_buzzer
        );
    end

endmodule
