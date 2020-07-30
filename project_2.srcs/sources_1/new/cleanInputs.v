
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Company: Texas Tech University 
// Engineer: Edward Sanchez
// 
// Create Date: 06/12/2020 08:51:59 AM
// Design Name: Square Pulse
// Module Name: upperModule
// Project Name: Project Lab Mini Project
// Target Devices: FPGA Basys3
// 
//////////////////////////////////////////////////////////////////////////////////
module cleanInputs (
    input wire clk,
    input wire lSensor, mSensor, rSensor,
    input wire distanceSensor,
    input wire stallSensor

    output wire [2:0] metalInputs,
    output wire distanceInput,
    output wire stallInput

    output wire LED2, LED3, LED4, LED5, LED6;

    );

    wire [2:0] sensorBuffer;
    wire [2:0] sensorBuffer2;
    wire distanceBuffer;
    wire stallInputBuffer;

    assign metalInputs[0] = ~sensorBuffer2[0];
    assign metalInputs[1] = ~sensorBuffer2[1];
    assign metalInputs[2] = ~sensorBuffer2[2];

    assign LED2 = metalInputs[0];
    assign LED3 = metalInputs[1];
    assign LED4 = metalInputs[2];
    assign LED5 = distanceInput;
    assign LED6 = stallInput;
    
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

        d_ff distancedff1 (                 .inpSignal(distanceInput), 
                                            .clk(clk), 
                                            .outpSignal(distanceBuffer)) ;

        d_ff distancedff2 (                 .inpSignal(distanceBuffer), 
                                            .clk(clk), 
                                            .outpSignal(distanceInput)) ;

        d_ff stalldff1 (                    .inpSignal(stallInput), 
                                            .clk(clk), 
                                            .outpSignal(stallInputBuffer)) ;

        d_ff stalldff2 (                    .inpSignal(stallInputBuffer), 
                                            .clk(clk), 
                                            .outpSignal(stallInput)) ;                                           
    
endmodule

