`timescale 1ns / 1ps

module tick_1hz #(
parameter SYS_CLK_FREQ=100000000 //System clock in hertz
)
(
    input wire clk,reset,
    output reg clken_1hz
);
reg [$clog2(SYS_CLK_FREQ)-1:0] count;
always @ (posedge clk or posedge reset)
    begin
        if (reset) begin
            count<=0;
            clken_1hz<=0; end
        else if (count== SYS_CLK_FREQ -1)begin //For enable based fin/fout-1 and for clock dividing based fin/(fout*2) - 1   
            clken_1hz<=1;
            count<=0; end
        else begin
            count<=count+1;
            clken_1hz<=0; end
    
   end 
endmodule
