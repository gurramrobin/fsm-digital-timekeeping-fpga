`timescale 1ns / 1ps

module alarm_tb;
    reg clk,reset,alarm_en;
    reg mode_pulse,done_pulse,start_pulse;
    wire clken_1hz;
    wire edit_enable,alarm_req;
    wire [1:0] field;
    wire [2:0] mode;
    wire [5:0] sec,min,asec,amin;
    wire [4:0] hrs,ahrs;
    wire alarm_stop;
    
    assign alarm_stop=start_pulse | done_pulse;
    
    
    
    tick_1hz  #(.SYS_CLK_FREQ(10)) U1 (.clk(clk),.reset(reset),.clken_1hz(clken_1hz));
    
    mode_controller U2 (.clk(clk),.reset(reset),.clken_1hz(clken_1hz),.mode_pulse(mode_pulse),.start_pulse(start_pulse),.done_pulse(done_pulse),.mode(mode),
    .field(field),.edit_enable(edit_enable),.start_action(),.reset_action(),.hund(),.tens(),.ones());
    
    utcp_5_30 U3 (.clk(clk),.reset(reset),.clken_1hz(clken_1hz),.edit_enable( edit_enable && (mode==3'b001)),
            .field(field),.inc_pulse(start_pulse),.sec(sec),.min(min),.hrs(hrs));
            
    alarm U4 (clk,reset,clken_1hz,edit_enable,start_pulse,field,sec,min,hrs,alarm_en,alarm_stop,asec,amin,ahrs,alarm_req);
    
    //Clock Generation
    always #5 clk=~clk;
    task press_done;
        begin done_pulse=1;#10;done_pulse=0;#10; end
    endtask
    
    task press_mode;
        begin mode_pulse=1;#10;mode_pulse=0; #10; end
    endtask
    
    task press_start;
        begin start_pulse=1;#10;start_pulse=0; #10; end
    endtask        
    initial begin  
        //Initialise signals
        clk=0;
        reset=1;
        alarm_en=0;
        mode_pulse=0;
        start_pulse=0;
        done_pulse=0;
        #150;
        reset=0;
        
        //Going to alarm mode
        press_mode;
        press_mode;
        
        //set time to 00:01
        press_done;
        press_done;
        press_start;
        press_done;
        press_done;
        
        #20;
        alarm_en=1;
        
        #7000;
        //Stopping the alarm
        press_start;
        #100;
        #12000;
        $finish;
        end
endmodule
