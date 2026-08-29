`timescale 1ns / 1ps

module offset_clk_tb;
    reg clk,reset,mode_pulse,done_pulse,start_pulse;
    wire clken_1hz;
    wire [2:0]    mode; 
    wire [1:0]    field;
    wire          edit_enable,hund;
    wire load;
    wire [3:0]    tens;
    wire [3:0]    ones;
    wire [7:0] country_id;
    wire signed [4:0] offset_hrs;
    wire signed [5:0] offset_min;
    wire [5:0] sec,min,tzsec,tzmin;
    wire [4:0] hrs,tzhrs;
    
    tick_1hz #(.SYS_CLK_FREQ(20)) U1 (.clk(clk),.reset(reset),.clken_1hz(clken_1hz));
    
    mode_controller U2 (.clk(clk),.reset(reset),.clken_1hz(clken_1hz),.mode_pulse(mode_pulse),.done_pulse(done_pulse),
        .start_pulse(start_pulse),.mode(mode),.field(field),.edit_enable(edit_enable),.start_action(),
        .reset_action(),.load(load),.hund(hund),.tens(tens),.ones(ones));
        
    bcdtobin U3 (.hund(hund),.tens(tens),.ones(ones),.country_id(country_id));
    
    tzwrtcountry U4 (.country_id(country_id),.offset_hrs(offset_hrs),.offset_min(offset_min));  
       
    utcp_5_30 U5 (.clk(clk),.reset(reset),.clken_1hz(clken_1hz),.edit_enable(edit_enable && mode==3'b001),.field(field),.inc_pulse(start_pulse),.load(load),.sec(sec),.min(min), //Comes from fsm
            .hrs(hrs));
            
    offset_clock  U7  (.clk(clk),.clken_1hz(clken_1hz),.reset(reset),.load(load),.offset_hrs(offset_hrs),.offset_min(offset_min),.hrs(hrs),.min(min),.sec(sec),.tzhrs(tzhrs),
        .tzmin(tzmin),.tzsec(tzsec));
        
    always #5 clk=~clk;
    
    task press_mode; begin 
        mode_pulse=1;#10;mode_pulse=0;#10; end
    endtask
    
    task press_done; begin 
        done_pulse=1;#10;done_pulse=0;#10; end
    endtask
    
    task press_start; begin 
        start_pulse=1;#10;start_pulse=0;#10; end
    endtask
    
    task do_reset; begin
        reset=1;#20;reset=0;#20;end
    endtask
    
    task country_mode; begin
        press_mode;
        press_mode;
        press_mode;
        press_mode;
        press_mode;
        end
    endtask 
    
    initial begin
        //Initialise signals
        clk=0;reset=0;mode_pulse=0;done_pulse=0;start_pulse=0;
        
        do_reset;
        
        //Setting Indian i.e, default time to 09:00
        
        press_mode; //For set_time mode
        press_done; //For setting hours
        //Press start button 9 times for setting to 09:00
        press_start;press_start;press_start;press_start;press_start;press_start;press_start;press_start;
        press_start;
       
        #1500;
        
        //Go to the country mode
        
        country_mode;
        
        //Now we are in the country select mode
        
               
        //We are selecting number 129 
        
        //For hund field
        press_done;
        //To set hundreds 
        press_start;
        
        //For tens field
        press_done;
        //To set tens
        press_start;press_start;
        
        //For ones field
        press_done;
        //To set ones
        press_start;press_start;press_start;press_start;press_start;press_start;press_start;press_start;press_start;
        
        
        press_done;
        
//        //We are selecting number 64 
        
//        //For hund field
//        press_done;
//        //To set hundreds 
//        //press_start;
        
//        //For tens field
//        press_done;
//        //To set tens
//        press_start;press_start;press_start;press_start;press_start;press_start;
        
//        //For ones field
//        press_done;
//        //To set ones
//        press_start;press_start;press_start;press_start;
        
        
//        press_done;
        
        #5000;
        
//        do_reset;
        
//        //We are selecting another number 077
//        press_mode;#20;press_mode;#20;press_mode;#20;press_mode;#20;press_mode;#20;
        
//        //For hund field
//        press_done;
        
//        //For tens field
//        press_done;
//        //To set tens
//        press_start;press_start;press_start;press_start;press_start;press_start;press_start;
        
//        //For ones field
//        press_done;
//        //To set ones
//        press_start;press_start;press_start;press_start;press_start;press_start;press_start;
        
        
//        press_done;
        
        #2000;
        
        $finish;
        
        end
    
           
            
endmodule
