`timescale 1ns / 1ps

module stopwatch (
    input wire clk,                         //100Mhz clock
    input wire clken_1hz,                   // 1hz clock from tick_1hz
    input wire reset,                       //Global reset
    input wire start_action,reset_action,   // To start pause and reset the stopwatch
    output reg [5:0] swsec,swmin,
    output reg [4:0] swhrs

    );
    reg run;
    wire [5:0] sec,min;
    wire [4:0] hrs;
    wire sw_reset= reset | reset_action;
    
    dig_clk stop_watch(.clk(clk),.reset(sw_reset),.clken_1hz(clken_1hz & run),.load(1'b0),.load_sec(6'd0),.load_min(6'd0),.load_hrs(5'd0),.dsec(sec),.dmin(min),.dhrs(hrs));
    always @ (posedge clk or posedge sw_reset) begin
        if (sw_reset) begin
            run<=1'b0;swsec<=0;swmin<=0;swhrs<=0; end
        else begin
            //Toggle run
            if (start_action) 
                run<=~run;
            //Display continuously while running
            swsec<=sec;swmin<=min;swhrs<=hrs;
        end                         
    end
endmodule
