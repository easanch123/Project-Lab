`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Company: Texas Tech University 
// Engineer: Edward Sanchez
// 
// Create Date: 06/12/2020 08:51:59 AM
// Design Name: Square Pulse
// Module Name: clk25khz_tb
// Project Name: Project Lab Mini Project
// Target Devices: FPGA Basys3
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
