`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2020 08:44:02 AM
// Design Name: 
// Module Name: upperModule
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


module upperModule(
    input wire clk,
    input wire [7:0] sw,
    output wire ioPin
    );
    
    wire clk25khz;
    wire clk100hz;
    
    clk25khz clk25k (.FPGAclk(clk), .signal(clk25khz));
    clk_100hz clk100 (.FPGAclk(clk), .signal(clk100hz));
    square100hz square (.switches(sw), .clk100hz(clk100hz), .clk25khz(clk25khz), .squarePulse100hz(ioPin));
    
endmodule
