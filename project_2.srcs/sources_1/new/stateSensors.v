`timescale 1ns / 1ps
`default_nettype none

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
       input wire lSensor, mSensor, rSensor,
       input wire [3:0] state,
       output wire [1:0] speedState


    );

        wire [2:0] sensorBuffer;
        wire [2:0] sensorInput; // This is the IR input that we want to be reading

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
                                            .lSensorBuffer(sensorInput[0]),
                                            .mSensorBuffer(sensorInput[1]),
                                            .rSensorBuffer(sensorInput[2])
        );

        setSpeedState setSpeed (            .clk(clk),
                                            .sensorInput(sensorInput),
                                            .state(state),
                                            .speedState(speedState)        
        );

    
endmodule
