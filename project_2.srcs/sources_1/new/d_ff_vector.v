`timescale 1ns / 1ps
`default_nettype none

/* Purpose: The purpose of this module is a deflipflop for the metal detector
*/
module d_ff_vector (
    input wire lSensor, mSensor, rSensor,
    input wire clk,
    output wire lSensorBuffer, mSensorBuffer, rSensorBuffer
    );

    reg rMSensor, rLSensor, rRSensor;
    
always @ (posedge clk)

    begin
        rMSensor <= mSensor;     
        rLSensor <= lSensor;
        rRSensor <= rSensor;
    end

    assign lSensorBuffer = lSensor ;
    assign mSensorBuffer = mSensor ;
    assign rSensorBuffer = rSensor ;

endmodule
