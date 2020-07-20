`timescale 1ns / 1ps
`default_nettype none

module irTop(

    input wire clk,
    input wire irSensor,
    output wire stateReady,
    output wire [3:0] outpState
    
     );

    reg [3:0] rState ; // final output state

    wire irBuffer;
    wire irBuffer2;
    wire irInput; // This is the IR input that we want to be reading
    wire clk100khz; // Clock used for the IR input

    wire ready;

    wire [11:0] remoteReading;

    newClk #(500) clkNew (          .FPGAclk(clk), 
                                    .signal(clk100khz));

    d_ff d_ff_irSensor1 (           .inpSignal(irSensor), 
                                    .clk(clk100khz), 
                                    .outpSignal(irBuffer)) ;

    inverter signalInvert (         .clk100khz(clk100khz),
                                    .inputSignal(irBuffer2), 
                                    .invertedInput(irInput)) ;

    irSensor irSensorLogic (        .clk100khz(clk100khz), 
                                    .irInput(irInput), 
                                    .remoteReading(remoteReading),
                                    .ready(ready)); 

    stateEncoder changeState (      .clk100khz(clk100khz),
                                    .remoteReading(remoteReading),
                                    .ready(ready),
                                    .outpState(outpState),
                                    .stateReady(stateReady));
    
endmodule
