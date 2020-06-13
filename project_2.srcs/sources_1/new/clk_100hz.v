`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2020 08:41:17 AM
// Design Name: 
// Module Name: clk_100hz
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
