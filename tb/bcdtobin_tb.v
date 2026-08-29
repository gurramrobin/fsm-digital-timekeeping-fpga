
module bcdtobin_tb;
    reg clk,reset,mode_pulse,start_pulse,done_pulse;
    wire          clken_1hz;
    wire [2:0]    mode; 
    wire [1:0]    field;
    wire          edit_enable,hund;
    wire [3:0]    tens;
    wire [3:0]    ones;
    wire [7:0] country_id;
    
    tick_1hz #(.SYS_CLK_FREQ(20)) U1 (.clk(clk),.reset(reset),.clken_1hz(clken_1hz));
    
    mode_controller U2 (.clk(clk),.reset(reset),.clken_1hz(clken_1hz),.mode_pulse(mode_pulse),.done_pulse(done_pulse),
        .start_pulse(start_pulse),.mode(mode),.field(field),.edit_enable(edit_enable),.start_action(),
        .reset_action(),.hund(hund),.tens(tens),.ones(ones));
    
    bcdtobin U3 (.hund(hund),.tens(tens),.ones(ones),.country_id(country_id));
    
    always #5 clk=~clk;
    
    task doreset; 
        begin
            reset=1;#10;reset=0;#10; 
        end
    endtask
    
    task pressdone;
        begin
            done_pulse=1;#10;done_pulse=0;#10;
        end        
    endtask
    
    task pressmode;
        begin
            mode_pulse=1;#10;mode_pulse=0;#10;
        end        
    endtask
    
    task pressstart;
        begin   
            start_pulse=1;#10;start_pulse=0;#10;    
        end
    endtask  
    
    initial begin
        //Initialise signals
        clk=0;reset=0;start_pulse=0;mode_pulse=0;done_pulse=0; 
        
        doreset;#100;
        
        //Go to different modes one by one
        pressmode;#20;pressmode;#20;pressmode;#20;pressmode;#20;pressmode;#20;
        
        //Now we are in the country select mode
        
        //We are selecting number 123
        
        //For hund field
        pressdone;
        //To set hundreds 
        pressstart;
        
        //For tens field
        pressdone;
        //To set tens
        pressstart;pressstart;
        
        //For ones field
        pressdone;
        //To set ones
        pressstart;pressstart;pressstart;
        
        
        pressdone;
        
        #200;
        
        doreset;
        
        //We are selecting another number 077
        pressmode;#20;pressmode;#20;pressmode;#20;pressmode;#20;pressmode;#20;
        
        //For hund field
        pressdone;
        
        //For tens field
        pressdone;
        //To set tens
        pressstart;pressstart;pressstart;pressstart;pressstart;pressstart;pressstart;
        
        //For ones field
        pressdone;
        //To set ones
        pressstart;pressstart;pressstart;pressstart;pressstart;pressstart;pressstart;
        
        
        pressdone;
        
        #200;
        
        $finish;
        
          end
        
        
        
    
endmodule
