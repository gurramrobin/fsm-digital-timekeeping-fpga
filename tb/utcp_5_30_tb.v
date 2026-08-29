`timescale 1ns / 1ps

module utc_5_30_tb;
    reg clk;
    reg reset;
    reg start_pulse,done_pulse,mode_pulse;
    wire clken_1hz;
    wire [2:0] mode;
    wire [1:0] field;
    wire edit_enable;
    wire load;
    
    wire [5:0] sec,min;
    wire [4:0] hrs;
    
    integer i=0;
    
    tick_1hz #(.SYS_CLK_FREQ(20)) U1 (
    .clk(clk),
    .reset(reset),
    .clken_1hz(clken_1hz)
    );
    mode_controller U2 (.clk(clk),.reset(reset),.clken_1hz(clken_1hz),.start_pulse(start_pulse),
        .done_pulse(done_pulse),.mode_pulse(mode_pulse),.mode(mode),.field(field),.edit_enable(edit_enable),
        .start_action(),.reset_action(),.load(load),.hund(),.tens(),.ones());
    utcp_5_30 U3 (.clk(clk),.reset(reset),.clken_1hz(clken_1hz),.edit_enable( edit_enable && (mode==3'b001)),
            .field(field),.inc_pulse(start_pulse),.load(load),.sec(sec),.min(min),.hrs(hrs));
    always #5 clk=~clk;
    initial begin
        //Display the values
        $monitor("mode=%b,field=%b,edit_enable=%b,hrs=%d,min=%d,sec=%d",mode,field,edit_enable,hrs,min,sec);
        //Initialize the signals
        clk=0;
        reset=1;
        start_pulse=0;
        done_pulse=0;
        mode_pulse=0;
        #50;
        //Deassert reset
        reset=0;
        #5000;
        //Set time mode
        mode_pulse=0;#10;
        mode_pulse=1;#10;
        mode_pulse=0;
        //Invokes hour setting
        done_pulse=0;#10;
        done_pulse=1;#10;  
        done_pulse=0;
        
        for (i=0;i<5;i=i+1) begin
            start_pulse=0;#10;
            start_pulse=1;#10;
            start_pulse=0; end 
        //Invokes minutes setting
        done_pulse=0;#10;
        done_pulse=1;#10; 
        done_pulse=0;#10; 
        for (i=0;i<5;i=i+1) begin
            start_pulse=0;#10;
            start_pulse=1;#10;
            start_pulse=0; end 
        //Invokes seconds setting
        done_pulse=0;#10;
        done_pulse=1;#10;
        done_pulse=0;#10; 
        for (i=0;i<4;i=i+1) begin
            start_pulse=0;#10;
            start_pulse=1;#10;
            start_pulse=0; end  
        #7000;
        
        //Apply reset and chcck if all the signals are gettiing zero or not
        reset=1;#20;
        reset=0;
        #3000;
        $finish;     
        end  
        
endmodule
