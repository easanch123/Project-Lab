`timescale 1ns / 1ps
`default_nettype none

/* Purpose: The purpose of this module is a deflipflop for sensor inputs
*/
module d_ff(
    input wire inpSignal,
    input wire clk,
    output wire outpSignal
    );

    reg flipflopReg;
    
always @ (posedge clk)

    begin
        flipflopReg <= inpSignal;    
    end

    assign outpSignal = flipflopReg;

endmodule
