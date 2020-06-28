`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/27/2020 04:35:59 PM
// Design Name: 
// Module Name: topFile
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


module topFile(

    );
    
    wire clk;
    wire [2:0] state;
    wire [2:0] currentState;
    
    assign currentState = state;
    
    setState settingState (.clk(clk), .currentState(currentState), .state(state) );
    executeState executingState (.clk(clk), .state(state));
    
endmodule
