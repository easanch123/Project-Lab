`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2020 09:10:20 AM
// Design Name: 
// Module Name: clk25khz_tb
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


module clk25khz_tb(

    );
    
    wire signal;
    reg simclk;
    wire clk;
    
    always begin
    #5 
    simclk = ~simclk;
    end
    
    initial begin 
    simclk = 1'b0;
    end
    
    assign clk = (simclk==1'b1);
    
    clk25khz clk25 (.FPGAclk(clk), .signal(signal));
    
endmodule
