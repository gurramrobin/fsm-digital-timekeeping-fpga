`timescale 1ns / 1ps

module timer(
    input  wire clk,clken_1hz,
    input  wire reset,
    input wire inc_pulse,
    input wire [2:0] mode,
    input wire [1:0] field,
    input wire edit_enable,
    input wire start_action,
    input wire stop_pulse,
    output reg [5:0] tsec, tmin,
    output reg [4:0] thrs,
    output wire timer_req

);  //Internal control signals
    reg timer_done_flag;    //Prevents downcounting after reaching zero
    reg timer_running;      //Indicates countdown is active
    
    assign    timer_req=((!edit_enable)  && (mode==3'b011) && (tsec==0 && tmin==0 && thrs==0) && timer_done_flag );
    
    always @(posedge clk or posedge reset) begin
        // Reset timer
        if (reset) begin
            tsec   <= 0;
            tmin   <= 0;
            thrs   <= 0;
            timer_done_flag<=0;
            timer_running<=0;
        end
        
        // clear the done flag AND reset counts so it won't re-trigger
        else if (stop_pulse && timer_done_flag) begin
            timer_done_flag <= 0;
            tsec <= 0; tmin <= 0; thrs <= 0;
        end
        
        // Timer setting mode
        else if (edit_enable && inc_pulse)
            begin
                timer_done_flag<=0;
                timer_running<=0;
                case(field)
                    2'd1: thrs <= (thrs<23)? thrs+1 : 0 ;
                    2'd2: tmin <= (tmin<59)? tmin+1 : 0 ;
                    2'd3: tsec <= (tsec<59)? tsec+1 : 0 ;     
                    default: ;
                endcase    
            end
        // Timer starts counting down Start action
        else if (start_action) begin 
            if (tsec!=0 || tmin!=0 || thrs!=0) begin
                timer_done_flag<=0;
                timer_running<=1;   end 
        end        
        else if (!edit_enable && clken_1hz && timer_running) begin
              //If already zero - stop
          if (tsec==0 && tmin==0 && thrs==0) begin
                timer_done_flag<=1;
                timer_running<=0; end
          else if (tsec>0) 
                tsec<=tsec-1;
          else begin
                tsec<=59;
                if (tmin>0)
                     tmin<=tmin-1;
                else if (thrs>0) begin
                     tmin<=59;
                     thrs<=thrs-1; end
              end
               
                            
        end
    end    
        
endmodule                     
                        
