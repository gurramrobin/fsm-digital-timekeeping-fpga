`timescale 1ns / 1ps

// ============================================================================
// TIMER MODULE TESTBENCH
// SYS_CLK_FREQ=20 → 1Hz tick fires every 20 cycles
// Clock period = 10ns → 1 simulated second = 200ns
// ============================================================================

module timer_tb;

    // -------------------------------------------------------------------------
    // Signals
    // -------------------------------------------------------------------------
    reg clk, reset;
    reg mode_pulse, start_pulse, done_pulse, stop_pulse;

    wire [5:0] tsec, tmin;
    wire [4:0] thrs;
    wire       timer_req;
    wire       clken_1hz;
    wire [2:0] mode;
    wire [1:0] field;
    wire       edit_enable;
    wire       start_action;
    wire       load;           // ← was undeclared in your original

    // -------------------------------------------------------------------------
    // Module Instantiations
    // -------------------------------------------------------------------------
    tick_1hz #(.SYS_CLK_FREQ(20)) U1 (
        .clk      (clk),
        .reset    (reset),
        .clken_1hz(clken_1hz)
    );

    mode_controller U2 (
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
        .reset_action(),
        .load        (load),
        .hund        (),
        .ones        (),
        .tens        ()
    );

    timer U3 (
        .clk         (clk),
        .clken_1hz   (clken_1hz),
        .reset       (reset),
        .inc_pulse   (start_pulse),
        .field       (field),
        .mode        (mode),
        .edit_enable (edit_enable),
        .start_action(start_action),
        .stop_pulse  (stop_pulse),
        .tsec        (tsec),
        .tmin        (tmin),
        .thrs        (thrs),
        .timer_req   (timer_req)
    );

    // -------------------------------------------------------------------------
    // Clock Generation - 100MHz (period=10ns)
    // -------------------------------------------------------------------------
    initial clk = 0;
    always #5 clk = ~clk;

    // -------------------------------------------------------------------------
    // Tasks
    // -------------------------------------------------------------------------
    task press_mode;
    begin
        mode_pulse = 1; #10;
        mode_pulse = 0; #10;
    end
    endtask

    task press_done;
    begin
        done_pulse = 1; #10;
        done_pulse = 0; #10;
    end
    endtask

    task press_start;
    begin
        start_pulse = 1; #10;
        start_pulse = 0; #10;
    end
    endtask

    task do_reset;
    begin
        reset = 1; #20;
        reset = 0; #20;  // ← added settling time after reset
    end
    endtask

    task timer_mode;
    begin
        press_mode;
        press_mode;
        press_mode;
    end
    endtask

    task press_stop;
    begin
        stop_pulse = 1; #10;
        stop_pulse = 0; #10;
    end
    endtask

    // -------------------------------------------------------------------------
    // PASS/FAIL checker
    // -------------------------------------------------------------------------
    task check;
        input [4:0]  exp_h;
        input [5:0]  exp_m;
        input [5:0]  exp_s;
        input        exp_req;
        input integer test_num;
    begin
        #1; // small settling delay
        if (thrs==exp_h && tmin==exp_m && tsec==exp_s && timer_req==exp_req)
            $display("PASS | Test %0d | %02d:%02d:%02d | timer_req=%b",
                      test_num, thrs, tmin, tsec, timer_req);
        else
            $display("FAIL | Test %0d | Got %02d:%02d:%02d req=%b | Expected %02d:%02d:%02d req=%b",
                      test_num, thrs, tmin, tsec, timer_req,
                      exp_h, exp_m, exp_s, exp_req);
    end
    endtask

    // =========================================================================
    // MAIN TEST SEQUENCE
    // =========================================================================
    initial begin

        // Initialize
        clk        = 0;
        reset      = 0;
        mode_pulse = 0;
        start_pulse= 0;
        done_pulse = 0;
        stop_pulse = 0;
        #20;

        // =====================================================================
        $display("\n--- TEST 1: Start at 00:00:00 - should NOT start ---");
        do_reset;
        timer_mode;
        press_start;       // timer is zero - should not run
        #500;
        check(0, 0, 0, 0, 1);

        // =====================================================================
        $display("\n--- TEST 2: Seconds countdown - 6 seconds ---");
        do_reset;
        timer_mode;
        press_done;        // field -> HRS  (skip)
        press_done;        // field -> MIN  (skip)
        press_done;        // field -> SEC
        repeat(6) press_start;  // set 6 seconds
        press_done;        // save/exit edit
        press_start;       // begin countdown
        #1500;             // wait ~7 simulated seconds (7 * 200ns = 1400ns)
        check(0, 0, 0, 1, 2);  // expect 00:00:00, timer_req=1
        press_stop;

        // =====================================================================
        $display("\n--- TEST 3: Minutes countdown - 2 minutes ---");
        do_reset;
        timer_mode;
        press_done;        // field -> HRS (skip)
        press_done;        // field -> MIN
        repeat(2) press_start;  // set 2 minutes
        press_done;        // field -> SEC (skip)
        press_done;        // save
        press_start;       // begin countdown
        // After 1 tick should borrow: 00:01:59
        #250;
        check(0, 1, 59, 0, 3);
        press_stop;

        // =====================================================================
        $display("\n--- TEST 4: Hours countdown - 1 hour ---");
        do_reset;
        timer_mode;
        press_done;        // field -> HRS
        press_start;       // set 1 hour
        press_done;        // field -> MIN (skip)
        press_done;        // field -> SEC (skip)
        press_done;        // save
        press_start;       // begin countdown
        // After 1 tick should borrow: 00:59:59
        #250;
        check(0, 59, 59, 0, 4);
        press_stop;

        // =====================================================================
        $display("\n--- TEST 5: Edit while countdown - should stop ---");
        do_reset;
        timer_mode;
        press_done;        // field -> HRS (skip)
        press_done;        // field -> MIN (skip)
        press_done;        // field -> SEC
        repeat(5) press_start;  // set 5 seconds
        press_done;        // save
        press_start;       // begin countdown
        #500;              // let it count for ~2 seconds
        press_done;        // re-enter edit - should stop countdown
        press_start;       // increment (editing, not counting)
        #800;              // wait - should NOT continue counting down
        $display("Test 5 | After re-edit, timer should be stopped");
        $display("      | tsec=%0d tmin=%0d thrs=%0d timer_req=%b",
                  tsec, tmin, thrs, timer_req);
        press_stop;

        // =====================================================================
        $display("\n--- TEST 6: timer_req clears on reset ---");
        do_reset;
        timer_mode;
        press_done; press_done;
        press_done;
        repeat(3) press_start;  // set 3 seconds
        press_done;
        press_start;       // begin countdown
        #800;              // wait for expiry
        check(0, 0, 0, 1, 6);  // timer_req should be high
        do_reset;
        timer_mode;
        check(0, 0, 0, 0, 6);  // after reset everything clear

        // =====================================================================
        $display("\n--- TEST 7: SEC wraps at 59 ---");
        do_reset;
        timer_mode;
        press_done; press_done;
        press_done;        // SEC field
        repeat(60) press_start;  // 60 presses → wraps back to 0
        check(0, 0, 0, 0, 7);

        // =====================================================================
        $display("\n--- TEST 8: HRS wraps at 23 ---");
        do_reset;
        timer_mode;
        press_done;        // HRS field
        repeat(24) press_start;  // 24 presses → wraps back to 0
        check(0, 0, 0, 0, 8);

        // =====================================================================
        $display("\n=== ALL TESTS COMPLETE ===");
        #100;
        $finish;
    end

endmodule
