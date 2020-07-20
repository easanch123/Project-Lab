`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/28/2020 11:49:27 AM
// Design Name: 
// Module Name: design_test
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


module design_test(
    input wire clk,
    input wire lSensor, mSensor, rSensor,
    output wire LED1, LED2, LED3
    );
    
    reg stuff;
    
    always @ (posedge clk) begin
    stuff = ~stuff;
    end
    
    initial begin
    stuff = 0;
    end
   
   assign LED1 = (lSensor==0);
   assign LED2 = (mSensor==0);
   assign LED3 = (rSensor==0);
   
endmodule
