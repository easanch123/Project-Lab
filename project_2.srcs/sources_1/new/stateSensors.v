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
       output wire [1:0] speedChange,
       
       output wire LED2, LED3, LED4


    );

        wire [2:0] sensorBuffer;
        wire [2:0] sensorBuffer2;
        
        wire [2:0] sensorInput; // This is the IR input that we want to be reading
        
        assign sensorInput[0] = ~sensorBuffer2[0];
        assign sensorInput[1] = ~sensorBuffer2[1];
        assign sensorInput[2] = ~sensorBuffer2[2];
        
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
        
        assign LED2 = sensorInput[0];
        assign LED3 = sensorInput[1];
        assign LED4 = sensorInput[2];

        setSpeedState setSpeed (            .clk(clk),
                                            .sensorInput(sensorInput),
                                            .state(state),
                                            .speedChange(speedChange)        
        );

    
endmodule
