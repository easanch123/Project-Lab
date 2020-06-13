`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2020 08:51:59 AM
// Design Name: 
// Module Name: clk25khz
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
