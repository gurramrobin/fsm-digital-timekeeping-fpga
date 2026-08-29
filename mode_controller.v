`timescale 1ns / 1ps

module mode_controller(
    input wire          clk, //100Mhz system clock
    input wire          reset, //reset signal
    input wire          clken_1hz, //1hz cycle enable pulse
    input wire          mode_pulse,start_pulse,done_pulse, // One cycle pulses from Push buttons
    //fsm outputs
    output reg [2:0]    mode, //which mode
    output reg [1:0]    field, //sec or min or hrs
    output reg          edit_enable,//setting active
    output reg          start_action,
    output reg          reset_action,
    output wire         load,
    output reg          hund,
    output reg [3:0]    tens,
    output reg [3:0]    ones
    );
    // MODES 
    localparam CLOCK=3'd0,SET_TIME=3'd1,ALARM=3'd2,TIMER=3'd3,
        STOPWATCH=3'd4,COUNTRY_SELECT=3'd5;
    // FIELDS    
    localparam NONE=2'd0,SET_HRS=2'd1,SET_MIN=2'd2,SET_SEC=2'd3;  //Also used for hundreds,Tens,Ones in country selection
    
    reg [2:0]   mode_next;    //Next state register for modes
    reg [1:0]   field_next;   //Next state register for fields
    reg         edit_next;    //Next state register for editing
    reg [2:0]   idle_cnt;     //Counts for 5 seconds
    reg         edit_enable_prev; //Holds previous values of edit_enable
    reg         hund_next;
    reg [3:0]   tens_next;
    reg [3:0]   ones_next;
    
    
    wire timeout_active =
        edit_enable &&
        (mode == SET_TIME ||
         mode == ALARM   ||
         mode == TIMER || mode == COUNTRY_SELECT);
    wire timeout_5s = timeout_active && (idle_cnt >= 3'd5); //Checks only in the setting mode if no button is pressed for 5 sec.
    
    assign load=edit_enable_prev & !edit_enable;   //Detects falling edge for the edit_enable so that we can load
    
    always @(posedge clk or posedge reset) begin
        if (reset)
            edit_enable_prev <= 1'b0;
        else
            edit_enable_prev <= edit_enable;
    end    
    
    //State register
    always @ (posedge clk or posedge reset) begin
        if (reset) begin
            mode<=CLOCK;
            field<=NONE;
            edit_enable<=1'b0;
            
            hund<=1'b0;
            tens<=4'b0;
            ones<=4'b0;
        end
        else begin
            //Next state becomes the present state
            mode<=mode_next;
            field<=field_next;
            edit_enable<=edit_next;
            
            hund<=hund_next;
            tens<=tens_next;
            ones<=ones_next;
            end
        end
        
    // TIMEOUT (5sec inactivity) COUNTER
    always @(posedge clk or posedge reset) begin
        if (reset)
            idle_cnt <= 3'd0;
        else if (!timeout_active)
            idle_cnt <= 3'd0;
        else if (mode_pulse || start_pulse || done_pulse)
            idle_cnt <= 3'd0;
        else if (clken_1hz && idle_cnt < 3'd5)
            idle_cnt <= idle_cnt + 1;
    end    
     
    //Next state logic
    always @ (*) begin
        //Defaults
        //Always read current state and write next state
        mode_next=mode;
        field_next=field;
        edit_next=edit_enable;
        hund_next=hund;
        tens_next=tens;
        ones_next=ones;
        
        start_action=1'b0;
        reset_action=1'b0;
        
        //Time out priority
        
         if (timeout_5s) begin
            mode_next  = CLOCK;
            field_next = NONE;
            edit_next  = 1'b0;
        end 
        
        else begin
        
          case(mode)
            //Default clock display
            CLOCK: begin
                    edit_next=1'b0;
                    field_next=NONE;
                    if (mode_pulse) mode_next=SET_TIME; end
            
            //Set time for default clock
            SET_TIME:
                    begin

                    if (done_pulse) begin
                        case(field)
                                NONE:       field_next= SET_HRS;
                                SET_HRS:    field_next= SET_MIN;
                                SET_MIN:    field_next= SET_SEC;
                                SET_SEC:    begin
                                        field_next= NONE;
                                end
                                default: field_next = NONE;
                        endcase
                    end
                    
                    edit_next=(field_next!=NONE);
                    
                    if (mode_pulse) begin
                        field_next = NONE;
                        edit_next  = 1'b0;
                        mode_next  = ALARM;
                    end
                    end            
            // Alarm mode       
            ALARM: begin
                    
                    if (done_pulse) begin
                        case(field)
                                NONE:       field_next= SET_HRS;
                                SET_HRS:    field_next= SET_MIN;
                                SET_MIN:    field_next= SET_SEC;
                                SET_SEC:    begin
                                        field_next= NONE;
                                end
                                default: field_next = NONE;
                        endcase
                    end
                    
                    edit_next=(field_next!=NONE);

                    if (mode_pulse) begin
                        field_next = NONE;
                        edit_next  = 1'b0;
                        mode_next  = TIMER;
                    end
                  end 
            //Timer mode
            TIMER: begin
                
                if (done_pulse) begin
                    case(field)
                        NONE:       field_next= SET_HRS;
                        SET_HRS:    field_next= SET_MIN;
                        SET_MIN:    field_next= SET_SEC;
                        SET_SEC:    field_next= NONE;
                        default:    field_next= NONE;
                    endcase
                end
            
                edit_next = (field_next != NONE);
            
                if (start_pulse && field==NONE)
                    start_action=1'b1;
            
                if (mode_pulse) begin
                    field_next = NONE;
                    edit_next  = 1'b0;
                    mode_next  = STOPWATCH;
                end
            end
            //Stopwatch mode                   
            STOPWATCH: begin
                   edit_next=1'b0;
                   field_next=NONE;
                   
                   if (start_pulse)
                        start_action=1'b1;// toggle run/pause 
                   
                   if (done_pulse)
                        reset_action=1'b1; // reset stopwatch 
                            
                   if (mode_pulse) mode_next= COUNTRY_SELECT;
                   
                   end
            COUNTRY_SELECT: begin
                    // Move between digits
                    if (done_pulse) begin
                        case(field)
                            NONE:  field_next = 2'd1;  // Hundreds
                            2'd1:  field_next = 2'd2;  // Tens
                            2'd2:  field_next = 2'd3;  // Ones
                            2'd3: begin
                                field_next = NONE;
                                edit_next  = 1'b0;
                                end
                        endcase
                    end
                    edit_next=(field_next!=NONE);
                    //Increment selected digit
                    if (start_pulse) begin
                        case(field)
                            //Hundreds: only 0 or 1
                            2'd1: begin
                                hund_next=~hund; end
                            //Tens: 0 to 9
                            2'd2: begin
                                if (tens==9)
                                    tens_next=0;
                                else
                                    tens_next=tens+1;
                                end
                            2'd3: begin
                                //Limit range to 001-198
                                if (hund==1 && tens==9 && ones>=8) begin
                                    ones_next=1; 
                                    tens_next=0;
                                    hund_next=0; end
                                else if (ones == 9)
                                    ones_next = 0;  // Normal wrap at x99
                                else
                                    ones_next = ones + 1; end
                        endcase
                    end
                    
                    
                        
                    if (mode_pulse) begin
                        field_next = NONE;
                        edit_next  = 1'b0;
                        mode_next  = CLOCK;
                    end                               
            end           
            default: begin
                   mode_next=CLOCK;
                   field_next=NONE;
                   edit_next=1'b0; end      
          endcase            
        
        end
        end                        
endmodule
