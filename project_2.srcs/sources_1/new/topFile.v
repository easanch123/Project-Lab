`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/27/2020 04:35:59 PM
// Design Name: 
// Module Name: topFile
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


module topFile(
    input wire clk,
    input wire L, M, R,
    output wire ENA, ENB, IN1, IN2, IN3, IN4
    );
    
    wire [2:0] state;
    wire enable;
    wire velocity;
    
    setState stateSet ( .clk(clk),
                        .L(L),
                        .R(R),
                        .M(M),
                        .state(state),
                        .velocity(velocity),
                        .enable(enable) );
                                 
    executeState executingState (   .clk(clk), 
                                    .state(state),
                                    .enable(enable),
                                    .velocity(velocity),
                                    .ENA(ENA),
                                    .ENB(ENB),
                                    .IN1(IN1),
                                    .IN2(IN2),
                                    .IN3(IN3),
                                    .IN4(IN4) ) ;

endmodule
