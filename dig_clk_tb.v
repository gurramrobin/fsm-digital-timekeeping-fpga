module dig_clk_tb;

reg clk;
reg reset,load;
reg [5:0]load_sec,load_min;
reg [4:0]load_hrs;

wire clken_1hz;
wire [5:0] dsec, dmin;
wire [4:0] dhrs;


tick_1hz #(.SYS_CLK_FREQ(20)) U1 (
    .clk(clk),
    .reset(reset),
    .clken_1hz(clken_1hz)
);

dig_clk U2 (
    .clk(clk),
    .reset(reset),
    .load(load),.load_sec(load_sec),.load_min(load_min),.load_hrs(load_hrs),
    .clken_1hz(clken_1hz),
    .dsec(dsec),
    .dmin(dmin),
    .dhrs(dhrs)
);

// Clock generation

always #5 clk = ~clk;   // 10ns clock


initial begin
    //Initialize signals
    clk = 0;
    reset = 1;
    load=0;
    load_sec=0;load_min=0;load_hrs=0;
    
    //Deassert reset
    #20 reset = 0;
    
    //Clock runs normally
    #3000;
    //Apply load values
    load_sec=6'd23;
    load_min=6'd44;
    load_hrs=4'd3;
    //Apply load values by making the load signal high
    load=1;#10;
    load=0;
    #4000;
    //Apply reset
    reset=1;
    #30;
    reset=0;
    #5000;
    

    #1500 $finish;
end
//Display values
initial begin
    $monitor("Time=%0t | %0d:%0d:%0d",
              $time, dhrs, dmin, dsec);
end

endmodule
