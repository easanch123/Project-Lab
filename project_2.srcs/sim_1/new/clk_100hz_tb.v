`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Company: Texas Tech University 
// Engineer: Edward Sanchez
// 
// Create Date: 06/12/2020 08:51:59 AM
// Design Name: Square Pulse
// Module Name: clk_100hz_tb
// Project Name: Project Lab Mini Project
// Target Devices: FPGA Basys3
// 
//////////////////////////////////////////////////////////////////////////////////
module clk_100hz_tb(

    );
    
    wire signal;
    reg simclk;
    wire altSignal;
    wire clk;
    
    always begin
    #5 
    simclk = ~simclk;
    end
    
    initial begin 
    simclk = 1'b0;
    end
    
    assign clk = (simclk==1'b1);
    
    clk_100hz clk100 (.FPGAclk(clk), .signal(signal));
    newClk #(500000) clkNew (.FPGAclk(clk), .signal(altSignal));
    
endmodule
