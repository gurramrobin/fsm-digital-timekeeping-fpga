`timescale 1ns / 1ps

module dig_clk(
    input wire clk,reset,clken_1hz,
    input wire load,
    input wire [5:0] load_sec,load_min,
    input wire [4:0] load_hrs,
    output reg [5:0]dsec,dmin,
    output reg [4:0]dhrs

    );
    
always @ (posedge clk or posedge reset) 
 begin
    if (reset) begin
        dsec<=0;dmin<=0;dhrs<=0; end
    else if (load) begin
        dsec<=load_sec;dmin<=load_min;dhrs<=load_hrs; end    
    else if (clken_1hz)
        begin
        if (dsec==59) 
            begin
            dsec<=0;
            if (dmin==59) 
                begin
                dmin<=0;  
                if (dhrs==23) begin
                    dhrs<=0;  end 
                else begin
                    dhrs<=dhrs+1; end
                end    
            else begin
                dmin<=dmin+1; end
           end
        else begin
            dsec<=dsec+1; end 
        end  
 end              
endmodule