`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/27/2020 01:39:57 PM
// Design Name: 
// Module Name: toggleMotorDriver_tb
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


module toggleMotorDriver_tb(

    );
    
    reg sw12, sw13, sw14, sw15, clk;
    wire ENA, ENB, IN1, IN2, IN3, IN4, LED12, LED13, LED14, LED15; 
    
    initial begin
    sw12 = 1;
    sw13 = 0;
    sw14 = 0;
    sw15 = 1;
    clk = 0; 
    end
    
    always begin
    #5 
    clk = ~clk;
    end
    
    toggleMotorDriver motorDriver ( .sw12(sw12),
                                    .clk(clk),
                                    .sw13(sw13),
                                    .sw14(sw14),
                                    .sw15(sw15),
                                    .ENA(ENA),
                                    .ENB(ENB),
                                    .IN1(IN1),
                                    .IN2(IN2),
                                    .IN3(IN3),
                                    .IN4(IN4),
                                    .LED12(LED12),
                                    .LED13(LED13),
                                    .LED14(LED14),
                                    .LED15(LED15)  );   
    
    
endmodule
