`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2020 09:03:06 AM
// Design Name: 
// Module Name: upperModule_tb
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


module upperModule_tb(
    );

    wire signal_square_100hz;
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
    
    upperModule upper ( .clk(inp_clk), 
                        .sw(switches), 
                        .ioPin(signal_square_100hz));
    
endmodule
