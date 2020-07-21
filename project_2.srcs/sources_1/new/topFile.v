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
    output wire [3:0] an,                 // anode for the 7 segment display
    
    output wire LED0,
    
    input wire lSensor, mSensor, rSensor,
    
    output wire ENA, ENB, IN1, IN2, IN3, IN4
    
    
    
    );
    wire stateReady;
    wire [3:0] currentState;
    wire [1:0] speedState;

    irTop IRSensorLogic (                   .clk(clk),
                                            .irSensor(irSensor),
                                            .outpState(currentState),
                                            .stateReady(stateReady),
                                            .LED0(LED0)
    );



    sevenSegmentDisplay sevenSegment (      .clk(clk),
                                            .stateReady(stateReady),
                                            .currentState(currentState),
                                            .seg(seg),
                                            .dp(dp),
                                            .anode(an)
    );
    
    // Put a module here which we will pass all of the sensors into. This will then output a specific output for
    // whether or not to increase speed on left motor, right motor, or whether or not to stop
    

    stateSensors getSpeedState(             .clk(clk),
                                            .lSensor(lSensor),
                                            .mSensor(mSensor),
                                            .rSensor(rSensor),
                                            .state(currentState),
                                            .speedState(speedState)

    );
    
    executeState executingState (           .clk(clk), 
                                            .state(currentState),
                                            .speedState(speedState),
                                            .ENA(ENA),
                                            .ENB(ENB),
                                            .IN1(IN1),
                                            .IN2(IN2),
                                            .IN3(IN3),
                                            .IN4(IN4) 
    );


        
//    wire enable;
//    wire velocity;
    
//    setState stateSet ( .clk(clk),
//                        .L(L),
//                        .R(R),
//                        .M(M),
//                        .state(state),
//                        .velocity(velocity),
//                        .enable(enable) );
                        
    
    
    
    
endmodule
