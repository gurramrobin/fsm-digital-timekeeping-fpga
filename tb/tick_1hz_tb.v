module tick_1hz_tb;
    reg clk,reset;
    wire clken_1hz;
    
    tick_1hz #(.SYS_CLK_FREQ(10)) uut (.clk(clk),.reset(reset),.clken_1hz(clken_1hz));
    
initial begin
    //Initialize signals
    clk=0;
    reset=0;
    #100;
    //Apply reset
    reset=1;
    #200;
    //Check the working of the clk_en signal
    reset=0;
    #5000;
    //Check if the enable signal is high when the reset is high
    reset=1;#200;
    
    reset=0;
    #3000;
    $finish;
    end
always #5 clk=~clk;        
endmodule
