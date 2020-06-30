`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/30/2020 08:54:20 AM
// Design Name: 
// Module Name: sensorStateDecoder
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


module sensorStateDecoder(
    input wire [1:0] sensorState,
    input wire en,
    input wire enable,
    output wire [2:0] state
    );
    reg stateReg;
    
    always @(sensorState) begin
        if (enable==1) begin
            if (en==1) begin
                case (sensorState)
                    2'b10: begin stateReg=3'b001; end
                    2'b11: begin stateReg=3'b010; end
                    default: begin stateReg = 3'b000; end
                endcase
            end else begin
                stateReg=3'b100;
            end
        end
    end
    
    initial begin
    stateReg = state;
    end
    
    assign state = stateReg;
    
endmodule
