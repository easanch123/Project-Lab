`timescale 1ns / 1ps
`default_nettype none

//////////////////////////////////////////////////////////////////////////////////
// Company: Texas Tech University
// Engineer: Edward Sanchez
// 
// Create Date: 06/27/2020 04:38:53 PM
// Design Name: Arche
// Module Name: stateSensors
// Project Name: Synchronous State Machine: Rover
// Target Devices: Xilinx Artix-7, Basys3 Board
// Tool Versions: Xilinx 2020.1
// Description: Arche is a Greek for "beginning," and the name of the Design.
// As the first digital design FPGA project with sensors created by the team
// we believed it was a fitting name. 
// The purpose of this rover is to serve as a cool toy that can be controlled by 
// a remote control. It is also able to stay within on a metal path.  
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////
//
//
//
// PURPOSE: Purpose of this module is to intake all of the different sensor inputs 
// present in the design (IR sensors, metal sensors, distance sensors, and stall sensor)
// and output an appropriate state for the machine. 
//
//
module stateSensors(

       input wire clk,
       input wire lSensor, mSensor, rSensor,
       input wire distanceSensor,
       input wire [3:0] remoteInputs,
       input wire remoteReady,
       input wire motorReady,
       
       output wire LED2, LED3, LED4,
       output wire [4:0] state,
       output wire stateReady
       
    );

        wire [2:0] sensorBuffer;
        wire [2:0] sensorBuffer2;
        
        wire [4:0] state;
        wire stateReady;
        
        wire [2:0] metalInputs; // This is the IR input that we want to be reading
        
        wire distanceInput;
        
        assign metalInputs[0] = ~sensorBuffer2[0];
        assign metalInputs[1] = ~sensorBuffer2[1];
        assign metalInputs[2] = ~sensorBuffer2[2];
        
        d_ff_vector d_ff_vector0 (          .lSensor(lSensor), 
                                            .mSensor(mSensor),
                                            .rSensor(rSensor),
                                            .clk(clk), 
                                            .lSensorBuffer(sensorBuffer[0]),
                                            .mSensorBuffer(sensorBuffer[1]),
                                            .rSensorBuffer(sensorBuffer[2])
        );

        d_ff_vector d_ff_vector1 (          .lSensor(sensorBuffer[0]), 
                                            .mSensor(sensorBuffer[1]),
                                            .rSensor(sensorBuffer[2]),
                                            .clk(clk), 
                                            .lSensorBuffer(sensorBuffer2[0]),
                                            .mSensorBuffer(sensorBuffer2[1]),
                                            .rSensorBuffer(sensorBuffer2[2])
        );
        
        assign LED2 = metalInputs[0];
        assign LED3 = metalInputs[1];
        assign LED4 = metalInputs[2];

        setState SetState (                 .clk(clk),
                                            .metalInputs(metalInputs),
                                            .distanceInput(distanceInput),
                                            .remoteInputs(remoteInputs),
                                            .remoteReady(remoteReady),
                                            .motorReady(motorReady),
                                            .state(state),
                                            .stateReady(stateReady)      
        );

    
endmodule
