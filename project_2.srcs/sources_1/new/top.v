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
    input wire distanceSensor,
    input wire lSensor, mSensor, rSensor,   // left middle and right sensors
    input wire stallSensor,
    
    
    output wire [6:0]seg,                   // 7 segment display
    output wire dp,                         // decimal point on the 7 segment display 
    output wire [3:0] an,                   // anode for the 7 segment display
    
    output wire ENA, ENB, IN1, IN2, IN3, IN4, // used to control the motors]]
    
    output wire LED0, LED2, LED3, LED4, LED5, LED6
    
    );


    wire remoteReady;
    wire motorReady;
    wire motorStop;
    wire survivalMode;

    wire [3:0] remoteInputs;
    wire [2:0] metalInputs;
    wire stallInput; 
    wire distanceInput;

    wire [4:0] state;
    wire stateReady;

    wire [7:0] dutyA ; 
    wire [7:0] dutyB ; 
    
    wire [2:0] accelerationA;
    wire [2:0] accelerationB;
    wire accelerationReady;


    irTop IRSensorLogic (                   .clk(clk),
                                            .remoteSensor(remoteSensor),
                                            .remoteReady(remoteReady),
                                            .remoteInputs(remoteInputs),
                                            .LED0(LED0)
    );
    
    
    
    
    
    setState    stateDecision      (        .clk(clk),
                                            .remoteInputs(remoteInputs),
                                            .remoteReady(remoteReady),
                                            .motorReady(motorReady),
                                            .motorStop(motorStop),
                                            .survivalMode(survivalMode),
                                            .state(state),
                                            .stateReady(stateReady)
    );
    
    

    sevenSegmentDisplay sevenSegment (      .clk(clk),
                                            .state(state),
                                            .stateReady(stateReady),
                                            .seg(seg),
                                            .dp(dp),
                                            .anode(an)
    );

    


    cleanInputs inputCleaning   (           .clk(clk),
    
                                            .lSensor(lSensor),
                                            .mSensor(mSensor),
                                            .rSensor(rSensor),
                                            .metalInputs(metalInputs),
                                            
                                            .distanceSensor(distanceSensor),
                                            .distanceInput(distanceInput),
                                            
                                            .stallSensor(stallSensor),
                                            .stallInput(stallInput),
                                            
                                            .LED2(LED2), // lsensor 
                                            .LED3(LED3), // msensor
                                            .LED4(LED4), // rsensor
                                            .LED5(LED5), // distance sensor
                                            .LED6(LED6) // stall sensor
    );


    executeState stateExecute  (            .clk(clk),

                                            .stateReady(stateReady),
                                            .state(state),

                                            .motorReady(motorReady),
                                            .motorStop(motorStop),
                                            
                                            .distanceInput(distanceInput),
                                            .metalInputs(metalInputs),
                                            .stallInput(stallInput),
                                            
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

                                            .motorStop(motorStop)
    );
    
    
    
    
endmodule
