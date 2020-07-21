`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/20/2020 08:35:08 PM
// Design Name: 
// Module Name: distanceSensor
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


module distanceSensor(
    input wire distanceSensor,
    output wire LED0
    );
    
    assign LED0 = (distanceSensor>1);
    
    
endmodule