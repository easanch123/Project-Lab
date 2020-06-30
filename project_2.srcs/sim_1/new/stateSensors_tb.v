`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/30/2020 08:15:54 AM
// Design Name: 
// Module Name: stateSensors_tb
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


module stateSensors_tb(

    );

    reg clk;
    reg L,M,R;
    wire [3:0] sensorState ;
    wire newclk;
    reg [32:0] count;
        
    always begin
    #5 
    clk = ~clk;
    count<=count+1;
    if (count==100) begin
        L<=0; 
        M<=0; 
        R<=1;
    end
    if (count==200) begin
        L<=0; 
        M<=1; 
        R<=0;
    end
    if (count==300) begin
        L<=0; 
        M<=1; 
        R<=1;
    end
    if (count==400) begin
        L<=1; 
        M<=0; 
        R<=0;
    end
    if (count==500) begin
        L<=1; 
        M<=0; 
        R<=1;
    end
    if (count==600) begin
        L<=1; 
        M<=1; 
        R<=0;
    end
    if (count==600) begin
        L<=1; 
        M<=1; 
        R<=1;
    end
    if (count==700) begin
        count<=0;
    end
    end
    
    
    stateSensors uut (.clk(clk), .L(L), .M(M), .R(R), .sensorState(sensorState));
    
    initial begin
    clk=0;
    L=0; M=0; R=0;
    count=0;
    end
    
endmodule
