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
    output wire [3:0] an,                   // anode for the 7 segment display
    
    output wire LED0,                       // used to debug the remote signal
    
    input wire lSensor, mSensor, rSensor,   // left middle and right sensors
    
    output wire ENA, ENB, IN1, IN2, IN3, IN4, // used to control the motors]]
    
    input wire sw0, // switch for debugging
    
    output wire LED2, LED3, LED4
    
    );
    wire stateReady;
    wire [3:0] currentState;
    wire [1:0] speedChange;

    wire [7:0] dutyA ; 
    wire [7:0] dutyB ; 
    
    wire [3:0] debugPass;
    
    wire sw0Buffer;
    wire sw0Final;

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
    
    d_ff d_ff1 (                    .inpSignal(sw0), 
                                    .clk(clk), 
                                    .outpSignal(sw0Buffer)) ;
    
    d_ff d_ff2 (                    .inpSignal(sw0Buffer), 
                                    .clk(clk), 
                                    .outpSignal(sw0Final)) ;
    
    assign debugPass = ( sw0Final==1 ) ? (4'd0) : (4'd5) ; 
    
    stateSensors getSpeedState(             .clk(clk),
                                            .lSensor(lSensor),
                                            .mSensor(mSensor),
                                            .rSensor(rSensor),
                                            .state(debugPass),
                                            .speedChange(speedChange),
                                            .LED2(LED2),
                                            .LED3(LED3),
                                            .LED4(LED4)

    );


    // 
    setExecuteState setExecutingState(      .clk(clk),
                                            .state(currentState),
                                            .speedChange(speedChange),
                                            .dutyA(dutyA),
                                            .dutyB(dutyB)


    );
    
    executeState executingState (           .clk(clk), 
                                            .state(currentState),
                                            .speedChange(speedChange),
                                            .dutyA(dutyA),
                                            .dutyB(dutyB),
                                            .ENA(ENA),
                                            .ENB(ENB),
                                            .IN1(IN1),
                                            .IN2(IN2),
                                            .IN3(IN3),
                                            .IN4(IN4) 
    );
    
    
    
    
endmodule
