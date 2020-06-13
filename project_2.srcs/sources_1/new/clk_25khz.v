`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2020 07:57:39 AM
// Design Name: 
// Module Name: clk_comp
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


module clk_25khz(
    input wire FPGAclk,
    output wire signal
    );
    
    reg [11:0] counter;
    reg newClk;

    parameter [11:0] MAX_COUNT = 1961;
    
    
    
    always @(posedge FPGAclk)
    begin
    if (counter==MAX_COUNT) begin
       counter<=12'd0;
       newClk=~newClk;
    end else begin
       counter<= counter+12'd1;
    end
    end
    
    initial begin
    counter = 12'd0;
    newClk = 1'd0;
    end
    
    assign clk25khz = newClk;
    
endmodule

