`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// 
// Company: Texas Tech University 
// Engineer: Edward Sanchez
// 
// Create Date: 06/12/2020 08:51:59 AM
// Design Name: Square Pulse
// Module Name: newClk
// Project Name: Project Lab Mini Project
// Target Devices: FPGA Basys3
// 
//////////////////////////////////////////////////////////////////////////////////


module newClk(
    input wire FPGAclk,
    output wire signal
    );
    
    parameter MAX_COUNT = 1; // 1961
    
    reg [ $clog2(MAX_COUNT) : 0 ] counter;
    reg newClk;
   
    always @(posedge FPGAclk)
    begin
    if (counter==MAX_COUNT) begin
       counter<=0;
       newClk=~newClk;
    end else begin
       counter<= counter+1;
    end
    end
    
    initial begin
    counter = 0;
    newClk = 0;
    end
    
    assign signal = newClk;
    
endmodule
