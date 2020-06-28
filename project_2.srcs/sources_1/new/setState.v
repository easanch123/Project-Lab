`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/27/2020 04:28:26 PM
// Design Name: 
// Module Name: setState
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


module setState(
    input wire clk,    
    output wire [2:0] state
    );
    
    wire [2:0] sensorState;
    wire [2:0] remoteState;
    
    stateSensors sensorsState ( .clk(clk),
                                .stateOutput(sensorState) );
                                
    stateRemote stateRemote (   .clk(clk),
                                 .sensorState(sensorState),
                                 .stateOutput(state) );
    
endmodule
