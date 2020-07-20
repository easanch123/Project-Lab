`timescale 1ns / 1ps
`default_nettype none

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

    input wire clk,                         // FPGA internal clock
    input wire irSensor,                    // IR sensor input

    output wire [6:0]seg,                   // 7 segment display
    output wire dp,                         // decimal point on the 7 segment display 
    output wire [3:0] an                 // anode for the 7 segment display
//    input wire L, M, R,
//    output wire ENA, ENB, IN1, IN2, IN3, IN4
    
    
    
    );
    
//    wire [2:0] state;
//    wire enable;
//    wire velocity;
    
//    setState stateSet ( .clk(clk),
//                        .L(L),
//                        .R(R),
//                        .M(M),
//                        .state(state),
//                        .velocity(velocity),
//                        .enable(enable) );
                        
   
                                 
//    executeState executingState (   .clk(clk), 
//                                    .state(state),
//                                    .enable(enable),
//                                    .velocity(velocity),
//                                    .ENA(ENA),
//                                    .ENB(ENB),
//                                    .IN1(IN1),
//                                    .IN2(IN2),
//                                    .IN3(IN3),
//                                    .IN4(IN4) ) ;


    wire stateReady;
    wire [3:0] currentState;

    irTop IRSensorLogic (                   .clk(clk),
                                            .irSensor(irSensor),
                                            .outpState(currentState),
                                            .stateReady(stateReady) 
    );

    sevenSegmentDisplay sevenSegment (      .clk(clk),
                                            .stateReady(stateReady),
                                            .currentState(currentState),
                                            .seg(seg),
                                            .dp(dp),
                                            .anode(an)
    );
endmodule
