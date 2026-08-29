`timescale 1ns / 1ps
module buzzer_ctrl_tb;
    reg clk,reset;
    reg start_pulse,done_pulse,mode_pulse,stop_pulse,alarm_en;
    
    wire clken_1hz;
    wire edit_enable,start_action,reset_action;
    wire [1:0] field;
    wire [2:0] mode;
    wire load;
    wire [5:0] sec,min,asec,amin,tmin,tsec;
    wire [4:0] hrs,ahrs,thrs;
    wire alarm_req,timer_req;
    wire buzzer;
    
    tick_1hz #(.SYS_CLK_FREQ(20)) U1 (.clk(clk),.reset(reset),.clken_1hz(clken_1hz));
    
    utcp_5_30 U2 (.clk(clk),.reset(reset),.clken_1hz(clken_1hz),.edit_enable(edit_enable & mode==3'b001),.field(field),
        .inc_pulse(start_pulse),.load(load),.sec(sec),.min(min),.hrs(hrs));
    
    mode_controller U3 (.clk(clk),.reset(reset),.clken_1hz(clken_1hz),.mode_pulse(mode_pulse),
        .start_pulse(start_pulse),.done_pulse(done_pulse),.mode(mode),.field(field),.edit_enable(edit_enable),
        .start_action(start_action),.reset_action(reset_action),.load(load),.hund(),.tens(),.ones());
        
    alarm U4 (.clk(clk),.reset(reset),.clken_1hz(clken_1hz),.edit_enable(edit_enable & mode==3'b010),.inc_pulse(start_pulse),.field(field),
        .sec(sec),.min(min),.hrs(hrs),.alarm_en(alarm_en),.stop_pulse(stop_pulse),.asec(asec),.amin(amin),
        .ahrs(ahrs),.alarm_req(alarm_req));
        
    timer U5 (.clk(clk),.reset(reset),.clken_1hz(clken_1hz),.inc_pulse(start_pulse),.mode(mode),.field(field),
        .edit_enable(edit_enable & mode==3'b011),.start_action(start_action),.stop_pulse(stop_pulse),.tsec(tsec),
        .tmin(tmin),.thrs(thrs),.timer_req(timer_req)); 
        
    buzzer_ctrl U6 (.clk(clk),.reset(reset),.alarm_req(alarm_req),.timer_req(timer_req),.stop_pulse(stop_pulse),
        .buzzer(buzzer));
    
    task do_reset;
        begin
            reset=1;#10;reset=0;#10;
        end
    endtask   
    
    task press_start;
        begin
            start_pulse=1;#10;start_pulse=0;#10;
        end
    endtask 
    
    task press_done;
        begin
            done_pulse=1;#10;done_pulse=0;#10;
        end
    endtask 
    
    task press_mode;
        begin
            mode_pulse=1;#10;mode_pulse=0;#10;
        end
    endtask   
          
    always #5 clk=~clk;
    
    initial begin
        //Initializing signals
        clk=0;reset=0;start_pulse=0;done_pulse=0;mode_pulse=0;stop_pulse=0; 
        alarm_en=0; 
        
        #20;
        //Apply reset
        do_reset;
        
        //Set alarm time to one min and timer to one min so that we can check early
        
        //Setting Alarm time by traversing to alarm mode
        //Alarm mode=2
        
        press_mode;press_mode;
        //Set min to one
        press_done;press_done;
        press_start;
        
        press_mode;press_mode;press_mode;press_mode;
        alarm_en=1;
        #13500;
        
        stop_pulse=1;#10;stop_pulse=0;
        
        //Set timer time by travesing to timer mode
        press_mode;press_mode;press_mode;
        //Set timer min to one
        press_done;press_done;
        press_start;
        press_done;press_done;
        #20;
        //Start timer
        press_start;
        #13500;
        
        stop_pulse=1;#10;stop_pulse=0;#100;
        
        //Now what happens if both requests for buzzer
        
        do_reset;
        
        //Setting alarm and timer at once one after another
        press_mode;press_mode;
        //Set min to one
        press_done;press_done;
        press_start;
        
        press_mode;
        press_done;press_done;
        press_start;
        press_done;press_done;
        #20;
        press_mode;press_mode;press_mode;
        //Start timer
        press_start;
        #15000;
        stop_pulse=1;#10;stop_pulse=0;
        #100;
        
        
        $finish;
        end
          
        

    
    
    
    
    
    
endmodule
