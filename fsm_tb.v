`timescale 1ns / 1ps

module fsm_tb;
    reg clk;
    reg reset;
    wire clken_1hz;
    reg start_pulse,done_pulse,mode_pulse;
    
    wire [2:0] mode;
    wire [1:0] field;
    wire edit_enable,start_action,reset_action,hund;
    wire [3:0] tens,ones;
    wire load;
    
    tick_1hz #(.SYS_CLK_FREQ(20)) U1 (
        .clk(clk),
        .reset(reset),
        .clken_1hz(clken_1hz)
    );
    
    mode_controller U2 (.clk(clk),.reset(reset),.clken_1hz(clken_1hz),.start_pulse(start_pulse),
        .done_pulse(done_pulse),.mode_pulse(mode_pulse),.mode(mode),.field(field),.edit_enable(edit_enable),
        .start_action(start_action),.reset_action(reset_action),.load(load),.hund(hund),.tens(tens),.ones(ones));
    
    always #5 clk=~clk;
    
    initial begin
        // Initialise signals
        clk=0;
        reset=1;
        start_pulse=0;done_pulse=0;mode_pulse=0;
        $monitor("mode=%b,field=%b,edit_enable=%b,hund=%d,tens=%d,ones=%d,start_action=%b,reset_action=%b",mode,field,
            edit_enable,hund,tens,ones,start_action,reset_action);
        #100;
        
        reset=0;
        //Mode change to Set time
        mode_pulse=1;#10;
        mode_pulse=0;
        //field change to set hours
        done_pulse=1;#10;
        done_pulse=0;
        //starts incrementing hours
        start_pulse=1;#10;
        start_pulse=0;#10;    
        start_pulse=1;#10;
        start_pulse=0;#10; 
        start_pulse=1;#10;
        start_pulse=0;#10; 
        start_pulse=1;#10;
        start_pulse=0;#10;
        //field change to set minutes
        done_pulse=1;#10;
        done_pulse=0;
        //incrementing minutes
        start_pulse=1;#10;
        start_pulse=0;#10;    
        start_pulse=1;#10;
        start_pulse=0;#10; 
        start_pulse=1;#10;
        start_pulse=0;#10; 
        start_pulse=1;#10;
        start_pulse=0;#10;
        //field change to set seconds
        done_pulse=1;#10;
        done_pulse=0;
        //incrementing seconds
        start_pulse=1;#10;
        start_pulse=0;#10;    
        start_pulse=1;#10;
        start_pulse=0;#10; 
        start_pulse=1;#10;
        start_pulse=0;#10; 
        start_pulse=1;#10;
        start_pulse=0;#10; #100;
        
        //Mode change to ALARM
        mode_pulse=1;#10;
        mode_pulse=0;#10;  #100;
        //field change to set hours
        done_pulse=1;#10;
        done_pulse=0;
        //starts incrementing hours
        start_pulse=1;#10;
        start_pulse=0;#10;    
        start_pulse=1;#10;
        start_pulse=0;#10; 
        start_pulse=1;#10;
        start_pulse=0;#10; 
        start_pulse=1;#10;
        start_pulse=0;#10;
        //field change to set minutes
        done_pulse=1;#10;
        done_pulse=0;
        //incrementing minutes
        start_pulse=1;#10;
        start_pulse=0;#10;    
        start_pulse=1;#10;
        start_pulse=0;#10; 
        start_pulse=1;#10;
        start_pulse=0;#10; 
        start_pulse=1;#10;
        start_pulse=0;#10;
        //field change to set seconds
        done_pulse=1;#10;
        done_pulse=0;
        //incrementing seconds
        start_pulse=1;#10;
        start_pulse=0;#10;    
        start_pulse=1;#10;
        start_pulse=0;#10; 
        start_pulse=1;#10;
        start_pulse=0;#10; 
        start_pulse=1;#10;
        start_pulse=0;#10; #100;
        
        
        //Mode change to TIMER
        mode_pulse=1;#10;
        mode_pulse=0;#10;   #100;
        
        done_pulse=1;#10;
        done_pulse=0;#10;
        done_pulse=1;#10;
        done_pulse=0;#10;
        start_pulse=1;#10;
        start_pulse=0;#10;
        
        
        
        //Mode change to STOPWATCH
        mode_pulse=1;#10;
        mode_pulse=0;#10;
        
        
        //Start stopwatch
        start_pulse=1;#10;
        start_pulse=0;#10;  #100;
        
        
        //Mode change to COUNTRY SELECT
        mode_pulse=1;#10;
        mode_pulse=0;#10; 
        //field change to set hundreds
        done_pulse=1;#10;
        done_pulse=0;
        //starts incrementing
        start_pulse=1;#10;
        start_pulse=0;#10;    
        start_pulse=1;#10;
        start_pulse=0;#10; 
        start_pulse=1;#10;
        start_pulse=0;#10; 
        start_pulse=1;#10;
        start_pulse=0;#10;
        //field change to set tens
        done_pulse=1;#10;
        done_pulse=0;
        //incrementing tens
        start_pulse=1;#10;
        start_pulse=0;#10;    
        start_pulse=1;#10;
        start_pulse=0;#10; 
        start_pulse=1;#10;
        start_pulse=0;#10; 
        start_pulse=1;#10;
        start_pulse=0;#10;
        //field change to set ones
        done_pulse=1;#10;
        done_pulse=0;
        //incrementing ones
        start_pulse=1;#10;
        start_pulse=0;#10;    
        start_pulse=1;#10;
        start_pulse=0;#10; 
        start_pulse=1;#10;
        start_pulse=0;#10; 
        start_pulse=1;#10;
        start_pulse=0;#10; #2000;
        $finish;
        end 
endmodule
