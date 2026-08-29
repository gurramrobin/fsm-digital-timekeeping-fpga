`timescale 1ns / 1ps

module stopwatch_tb;

    reg clk;
    reg reset;
    reg mode_pulse,done_pulse,start_pulse;

    wire clken_1hz,edit_enable,start_action,reset_action;
    wire [2:0] mode;
    wire [1:0] field;
    wire [5:0] swsec, swmin;
    wire [4:0] swhrs;

    // 20 clock cycles = 1 "second" in simulation
    tick_1hz #(.SYS_CLK_FREQ(20)) U1 (
        .clk(clk),
        .reset(reset),
        .clken_1hz(clken_1hz)
    );

    stopwatch U2 (
        .clk(clk),
        .clken_1hz(clken_1hz),
        .reset(reset),
        .start_action(start_action),
        .reset_action(reset_action),
        .swsec(swsec),
        .swmin(swmin),
        .swhrs(swhrs)
    );
    
    mode_controller U3 (.clk(clk),.reset(reset),.clken_1hz(clken_1hz),.mode_pulse(mode_pulse),.start_pulse(start_pulse),.done_pulse(done_pulse),
    .mode(mode),.field(field),.edit_enable(edit_enable),.start_action(start_action),.reset_action(reset_action),.hund(),.ones(),.tens());

    // 100MHz style clock (10ns period)
    always #5 clk = ~clk;
    
    task do_reset;
        begin
            reset=1;#20;reset=0;#10;
        end
    endtask
    
    task press_mode;
        begin
            mode_pulse=1;#10;mode_pulse=0;#10;
        end      
    endtask
    task press_done;
        begin
            done_pulse=1;#10;done_pulse=0;#10;
        end      
    endtask
    task press_start;
        begin
            start_pulse=1;#10;start_pulse=0;#10;
        end      
    endtask
    initial begin
        //Initialise signals
        clk=0;
        reset=0;
        mode_pulse=0;
        done_pulse=0;
        start_pulse=0;
        
        do_reset;
        // Go to Stop watch mode
        press_mode;press_mode;press_mode;press_mode;
        //Start the Stopwatch
        press_start;
        #3000;
        //Stopw the stopwatch
        press_start;
        #2000;
        //Again start the stopwatch
        press_start;
        #2000;
        //Reset the stopwatch
        press_done;
        
        //Reset while running (global reset)
        do_reset;
        
        //Go to stopwatch mode
        press_mode;press_mode;press_mode;press_mode;
        //Start the stopwatch
        press_start;
        #3000;
 
        //Stopwatch reset
        do_reset;
        press_mode;press_mode;press_mode;press_mode;
        press_start;
        #3000;
        //Reset while running
        press_done;
        #300;
        $finish;
    end

endmodule
