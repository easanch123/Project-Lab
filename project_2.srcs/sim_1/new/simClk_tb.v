`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/18/2020 09:30:37 PM
// Design Name: 
// Module Name: simClk_tb
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


module simClk_tb(
    );

    wire signal256, signal255;
    wire signal100;
    reg simclk;
    wire inp_clk;
    reg [8:0] counter256;
    reg [31:0] counter;
    
    reg [8:0] counter255;
    reg clk100_256,clk100_255;
    
    wire finalSignal;
    
    always begin
    #5 
    simclk <= ~simclk;
    counter<=counter+1;
    end
   
    initial begin 
    simclk = 1'b0;
    counter255 = 0;
    counter256 = 0;
    clk100_256=0;
    clk100_255=0;
    counter = 0;
    end
    
    always @(posedge finalSignal) begin
    counter256<=counter256+1;
    if (counter256==256) begin
        clk100_256 <= ~clk100_256;
        counter256 <= 0;
    end    
    end
    
    assign inp_clk = simclk;
    
    newClk #(1953) clkNewz (.FPGAclk(inp_clk), .signal(finalSignal));
//    newClk #(977) clkNew (.FPGAclk(inp_clk), .signal(signal256));
//    newClk #(980) clkNews (.FPGAclk(inp_clk), .signal(signal255));
    newClk #(500000) clkNewss (.FPGAclk(inp_clk), .signal(signal100));   
endmodule
