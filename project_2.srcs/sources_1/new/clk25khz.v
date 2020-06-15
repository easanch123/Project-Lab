`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// 
// Company: Texas Tech University 
// Engineer: Edward Sanchez
// 
// Create Date: 06/12/2020 08:51:59 AM
// Design Name: Square Pulse
// Module Name: clk25khz
// Project Name: Project Lab Mini Project
// Target Devices: FPGA Basys3
// 
//////////////////////////////////////////////////////////////////////////////////
module clk25khz(
    input wire FPGAclk,
    output wire signal
    );
    
    reg [10:0] counter;
    reg newClk;

    parameter [10:0] MAX_COUNT = 1961;
   
    always @(posedge FPGAclk)
    begin
    if (counter==MAX_COUNT) begin
       counter<=11'd0;
       newClk=~newClk;
    end else begin
       counter<= counter+11'd1;
    end
    end
    
    initial begin
    counter = 11'd0;
    newClk = 1'd0;
    end
    
    assign signal = newClk;
    
endmodule
