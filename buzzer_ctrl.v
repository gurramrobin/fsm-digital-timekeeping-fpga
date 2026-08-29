module buzzer_ctrl (
    input  wire clk,
    input  wire reset,

    input  wire alarm_req,
    input  wire timer_req,

    input  wire stop_pulse,

    output reg  buzzer
);

    parameter IDLE  = 2'd0,ALARM = 2'd1,TIMER = 2'd2;

    reg [1:0] state, next_state;

    // State register
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        next_state = state;

        case (state)
            IDLE: begin
                if (alarm_req)
                    next_state = ALARM;
                else if (timer_req)
                    next_state = TIMER;
            end

            ALARM: begin
                if (stop_pulse)
                    next_state = IDLE;
            end

            TIMER: begin
                if (stop_pulse)
                    next_state = IDLE;
            end
        endcase
    end

    // Output logic
    always @(*) begin
        buzzer = (state != IDLE);
    end

endmodule
