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


module top(

    input wire clk,                         // FPGA internal clock
    input wire remoteSensor,                    // IR sensor input

    input wire lSensor, mSensor, rSensor,   // left middle and right sensors

    
    
    output wire [6:0]seg,                   // 7 segment display
    output wire dp,                         // decimal point on the 7 segment display 
    output wire [3:0] an,                   // anode for the 7 segment display
    
    output wire ENA, ENB, IN1, IN2, IN3, IN4, // used to control the motors]]
    
    output wire LED0,LED2, LED3, LED4,
    output wire LED7, LED8, LED9, LED11
    
    
    );
    


    wire remoteReady;
    wire motorReady;
    wire motorStop;
    wire survivalMode;

    wire [3:0] remoteInputs;
    wire [2:0] metalInputs;

    wire [3:0] state;
    wire stateReady;

    wire [7:0] dutyA ; 
    wire [7:0] dutyB ; 
    
    wire signed [15:0] accelerationA;
    wire signed [15:0] accelerationB;
    wire accelerationReady;
    
    wire [2:0] pathCorrection; 
    
    assign LED2 = metalInputs[0];
    assign LED3 = metalInputs[1];
    assign LED4 = metalInputs[2];
    
    assign LED7 = motorReady;
    assign LED8 = motorStop;
    
    assign LED9 = survivalMode;
    
  
    irTop IRSensorLogic (                   .clk(clk),
                                            .remoteSensor(remoteSensor),
                                            .remoteReady(remoteReady),
                                            .remoteInputs(remoteInputs),
                                            .LED0(LED0)
                                            
    );
    
    cleanInputs inputCleaning   (           .clk(clk),
    
                                            .lSensor(lSensor),
                                            .mSensor(mSensor),
                                            .rSensor(rSensor),
                                            .metalInputs(metalInputs)
    );
    
    sensorTracking pathTracking (           .clk(clk),
                                            .metalInputs(metalInputs), // [2:0]
                                            .pathCorrection(pathCorrection), // [1:0]
                                            .survivalMode(survivalMode),
                                            .motorStop(motorStop)
);
    
    
    
    setState    stateDecision      (        .clk(clk),
                                            .remoteInputs(remoteInputs),
                                            .remoteReady(remoteReady),
                                            .pathCorrection(pathCorrection),
                                            .survivalMode(survivalMode),
                                            .state(state),
                                            .stateReady(stateReady),
                                            .motorStop(motorStop)
    );
    
    sevenSegmentDisplay sevenSegment (      .clk(clk),
                                            .state(state),
                                            .stateReady(stateReady),
                                            .seg(seg),
                                            .dp(dp),
                                            .anode(an)
    );


    executeState stateExecute  (            .clk(clk),

                                            .state(state),
                                            .stateReady(stateReady),
                                            .motorReady(motorReady),
                                            
                                            .motorStop(motorStop),
                                            
                                            .accelerationA(accelerationA),
                                            .accelerationB(accelerationB),
                                            .accelerationReady(accelerationReady)
    );
    
    

    
    motorDriver driverMotor (               .clk(clk), 
                                            .ENA(ENA),
                                            .ENB(ENB),
                                            .IN1(IN1),
                                            .IN2(IN2),
                                            .IN3(IN3),
                                            .IN4(IN4),

                                            .accelerationA(accelerationA),
                                            .accelerationB(accelerationB),
                                            .accelerationReady(accelerationReady),

                                            .motorStop(motorStop),
                                            .state(state)
    );
    
    
    
    
endmodule
