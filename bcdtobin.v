`timescale 1ns / 1ps

module bcdtobin(
    input wire hund,
    input wire [3:0] tens,
    input wire [3:0] ones,
    output wire [7:0] country_id

    );
    assign country_id=hund*8'd100 + tens*8'd10 + ones;
endmodule
