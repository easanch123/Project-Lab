`timescale 1ns / 1ps
`default_nettype none

module irTop(

    input wire clk,
    input wire remoteSensor,
    output wire remoteReady,
    output wire [3:0] remoteInputs,
    output wire LED0
    
     );

    wire remoteBuffer;

    wire remoteInput; // This is the IR input that we want to be reading

    wire clk100khz; // Clock used for the IR input

    wire ready;

    wire [11:0] remoteReading;

    newClk #(500) clkNew (          .FPGAclk(clk), 
                                    .signal(clk100khz));

    d_ff d_ff_irSensor1 (           .inpSignal(remoteSensor), 
                                    .clk(clk100khz), 
                                    .outpSignal(remoteBuffer)) ;

    inverter signalInvert (         .clk100khz(clk100khz),
                                    .inputSignal(remoteBuffer), 
                                    .invertedInput(remoteInput)) ;
                                    
    assign LED0 = remoteInput ; 
    
    irSensor irSensorLogic (        .clk100khz(clk100khz), 
                                    .remoteInput(remoteInput), 
                                    .remoteReading(remoteReading),
                                    .ready(ready)
    ); 
                                    

    remoteEncoder interpretRemote ( .clk100khz(clk100khz),
                                    .remoteReading(remoteReading),
                                    .ready(ready),
                                    .remoteInputs(remoteInputs),
                                    .remoteReady(remoteReady)
    );
    
endmodule
