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
    input wire L, M, R,
    output wire [2:0] state,
    output wire velocity,
    output wire enable
    );
    
    wire [1:0] sensorState;
    wire motorEn;
    
    stateSensors sensorsState ( .clk(clk),
                                .L(L),
                                .R(R),
                                .M(M),
                                .motorEnable(motorEn),
                                .velocity(velocity),
                                .sensorState(sensorState),
                                .enable(enable) );
                                 
    sensorStateDecoder decoder (    .sensorState(sensorState), 
                                    .state(state),
                                    .en(motorEn),
                                    .enable(enable) );
    
endmodule
