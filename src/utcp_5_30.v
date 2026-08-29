`timescale 1ns / 1ps

module utcp_5_30(
    input wire clk,reset,
    input wire clken_1hz,   //Comes from tick_1hz
    input wire edit_enable, //Comes from fsm
    input wire [1:0] field, //Comes from fsm
    input wire inc_pulse,   //Comes from push button debouncer
    input wire load,        //Comes from fsm
    
    output reg [5:0] sec,min,
    output reg [4:0] hrs

    );
    //Use intermediate wires so that output does not have multiple drivers
    wire [5:0] run_sec,run_min; //
    wire [4:0] run_hrs;  
    
     
    dig_clk run_clock (.clk(clk),.clken_1hz(~edit_enable & clken_1hz),.load(load),.load_sec(sec),.load_min(min),.load_hrs(hrs),
    .reset(reset),.dsec(run_sec),.dmin(run_min),.dhrs(run_hrs));
    
    always @ ( posedge clk or posedge reset )
    begin
        if (reset) begin // To reset the time
            sec<=0;min<=0;hrs<=0; end
        else if (edit_enable && inc_pulse) begin //Editing the default clock 
            case(field)
                2'd1: hrs <= (hrs < 23) ? hrs + 1 : 0;
                2'd2: min <= (min < 59) ? min + 1 : 0;
                2'd3: sec <= (sec < 59) ? sec + 1 : 0;
                default: ;            
            endcase
        end
        else if (!edit_enable && !load) begin  // When not editing, follow run_clockx
            sec <= run_sec;
            min <= run_min;
            hrs <= run_hrs;
        end
    end        
endmodule
