`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Company: Texas Tech University 
// Engineer: Edward Sanchez
// 
// Create Date: 06/12/2020 08:51:59 AM
// Design Name: Square Pulse
// Module Name: upperModule_tb
// Project Name: Project Lab Mini Project
// Target Devices: FPGA Basys3
// 
//////////////////////////////////////////////////////////////////////////////////
module upperModule_tb(
    );

    wire signal_square_100hz, signal_100hz;
    reg simclk;
    wire inp_clk;
    reg [7:0] switch;
    wire [7:0] switches;
    reg [3:0] count;
    
    always begin

    #5 
    simclk = ~simclk;
    
    end
    
    always @(posedge signal_100hz) begin
    switch <= switch + 8'd8;
    end
   
    initial begin 
    simclk = 1'b0;
    switch = 8'b00000000;
    count = 4'd0;
    end
    
    assign switches = switch;
    assign inp_clk = (simclk==1'b1);
    
    clk_100hz clk100( .FPGAclk(inp_clk), .signal(signal_100hz) );
    
    upperModule upper ( .clk(inp_clk), 
                        .sw(switches), 
                        .ioPin(signal_square_100hz));
    
endmodule
