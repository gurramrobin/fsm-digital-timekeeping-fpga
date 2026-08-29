`timescale 1ns / 1ps

module alarm(
    input  wire clk,
    input  wire reset,

    // 1 Hz enable pulse (from tick_1hz)
    input  wire clken_1hz,

    // Alarm time setting
    input  wire edit_enable,
    input  wire inc_pulse,
    input  wire [1:0] field,

    // Current clock time
    input  wire [5:0] sec,
    input  wire [5:0] min,
    input  wire [4:0] hrs,

    // Control
    input  wire alarm_en,      // alarm enable
    input  wire stop_pulse,    // user pressed start/done

    output reg [5:0] asec, amin,
    output reg [4:0] ahrs,
    // Output request to shared buzzer
    
    output wire alarm_req
);

    // Alarm FSM states 
    localparam 
        IDLE     = 2'd0,
        RINGING  = 2'd1,
        SILENCED = 2'd2;

    reg [1:0] state, next_state;

    // STATE REGISTER
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // ALARM TIME SETTING LOGIC
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            asec <= 0;
            amin <= 0;
            ahrs <= 0;
        end
        else if (edit_enable && inc_pulse) begin
            case (field)
                2'd1: ahrs <= (ahrs < 23) ? ahrs + 1 : 0;
                2'd2: amin <= (amin < 59) ? amin + 1 : 0;
                2'd3: asec <= (asec < 59) ? asec + 1 : 0;
                default: ;
            endcase
        end
    end

    // NEXT STATE LOGIC
    always @(*) begin
        next_state = state;

        case (state)

            // Waiting for time match
            IDLE: begin
                if (alarm_en &&
                    (amin == min) &&
                    (ahrs == hrs))
                    next_state = RINGING;
            end

            // Buzzer active
            RINGING: begin
                if (stop_pulse)
                    next_state = SILENCED;
            end

            // Prevent retrigger while time is same
            SILENCED: begin
                if (
                    (amin != min) ||
                    (ahrs != hrs))
                    next_state = IDLE;
            end

            default:
                next_state = IDLE;
        endcase
    end

    // OUTPUT LOGIC
    assign alarm_req = (state == RINGING);

endmodule
