`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Company: Texas Tech University 
// Engineer: Edward Sanchez
// 
// Create Date: 06/12/2020 08:51:59 AM
// Design Name: Square Pulse
// Module Name: square100hz_tb
// Project Name: Project Lab Mini Project
// Target Devices: FPGA Basys3
// 
//////////////////////////////////////////////////////////////////////////////////
module square100hz_tb(
        

    );
    
    wire signal_100hz, signal_25khz;
    wire signal_square_100hz;
    reg simclk;
    wire clk;
    reg [7:0] sw;
    wire [7:0] switches;
    reg [3:0] count;
    
    always begin
    if (count==4'd3) begin
    sw <= sw + 8'd1;
    count <= 4'd0;
    end
    #5 
    simclk = ~simclk;
    count <= count + 4'd1;
    end
   
    initial begin 
    simclk = 1'b0;
    sw = 8'b00000000;
    count = 4'd0;
    end
    
    assign switches = sw;
    assign clk = (simclk==1'b1);
    
    clk25khz clk25k (.FPGAclk(clk), .signal(signal_25khz));
    clk_100hz clk100 (.FPGAclk(clk), .signal(signal_100hz));
    square100hz square (.switches(switches), .clk100hz(signal_100hz), .clk25khz(signal_25khz), .squarePulse100hz(signal_square_100hz));
    
endmodule
