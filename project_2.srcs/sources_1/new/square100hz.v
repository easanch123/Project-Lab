`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// 
// Company: Texas Tech University 
// Engineer: Edward Sanchez
// 
// Create Date: 06/12/2020 08:51:59 AM
// Design Name: Square Pulse
// Module Name: square100hz
// Project Name: Project Lab Mini Project
// Target Devices: FPGA Basys3
// 
//////////////////////////////////////////////////////////////////////////////////
module square100hz(
    input wire [7:0] switches,
    input wire clk25khz,
    output wire squarePulse100hz
    );
    
    reg [7:0] counter;
    reg [7:0] countCeiling;
    reg squarePulse;
    reg rst;
    
           
    initial begin
        squarePulse = 1'd1;
        counter = 8'd0;
        countCeiling = 8'b10000000;
        rst = 1'd1;
    end
 
    
    always @(posedge clk25khz)
    begin
    
    if (switches!=countCeiling) begin
        rst <= 1'b1;
        countCeiling<=switches;
    end
    
    if (rst!=1'd1) begin
    
        squarePulse <= (counter==countCeiling && counter!=8'd255) ? (1'd0) : (squarePulse);
        
        if (counter==8'd255) begin
            counter <= 8'd0;
            squarePulse <= (countCeiling!=1'd0) ? (1'd1) : (1'd0);
        end else begin
            counter <= counter + 1;
        end
    end else begin
        
        counter <= 8'd0;
        squarePulse <= 1'd1;
        rst <= 1'd0;
        
    end
    end 
    
    assign squarePulse100hz = squarePulse;
    
endmodule