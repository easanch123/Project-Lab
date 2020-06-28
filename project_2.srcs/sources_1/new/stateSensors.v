`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/27/2020 04:38:53 PM
// Design Name: 
// Module Name: stateSensors
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module stateSensors(
       input wire clk,
       output wire [2:0] newState
    );
    
    reg state;
    
    wire sensorLeft, sensorMiddle, sensorRight; // these should not be very spread apart
    
    always @ (clk) begin
    
    if (sensorRight==1) begin
    end
    
    
    end
    
    // the overall logic here is that if the sensorMiddle==1, then we move forward
    
    // if sensorRight==1, then we turn left
    
    // if sensorLeft==1, then we turn right
    
    //if sensoRight==1 and sensorLeft==1, // should we have any interesting logic for the intersections?
    
    // Here we need logic where basically the output of this tells us which state we should be in
    
    
    
    
endmodule
