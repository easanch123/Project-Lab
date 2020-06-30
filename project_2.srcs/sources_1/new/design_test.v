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
    input wire clk
    );
    reg rLED13;
    wire LED13;
    
    assign LED13 = (rLED13==1);
    
    initial begin
    rLED13 = 1;
    end
    
endmodule
