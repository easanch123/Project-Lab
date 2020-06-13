`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Company: Texas Tech University 
// Engineer: Edward Sanchez
// 
// Create Date: 06/12/2020 08:51:59 AM
// Design Name: Square Pulse
// Module Name: clk_100hz
// Project Name: Project Lab Mini Project
// Target Devices: FPGA Basys3
// 
//////////////////////////////////////////////////////////////////////////////////
module clk_100hz(
    input wire FPGAclk,
    output wire signal
    );
    
    reg [18:0] counter;
    reg newClk;

    parameter [18:0] MAX_COUNT = 500000;
   
    always @(posedge FPGAclk)
    begin
    if (counter==MAX_COUNT) begin
       counter<=19'd0;
       newClk=~newClk;
    end else begin
       counter<= counter+19'd1;
    end
    end
    
    initial begin
    counter = 19'd0;
    newClk = 1'd0;
    end
    
    assign signal = newClk;
    
endmodule
