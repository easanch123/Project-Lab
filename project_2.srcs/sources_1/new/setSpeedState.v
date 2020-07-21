\`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/20/2020 09:25:56 PM
// Design Name: 
// Module Name: setSpeedState
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


module setSpeedState(

    input wire clk,
    input wire [2:0] sensorInput,
    input wire [3:0] state,

    output wire [1:0] speedState

    );

    reg [1:0] rSpeedState;

    assign speedState = rSpeedState;

    localparam FORWARD = 2'd0 ;
    localparam LEFT = 2'd1 ;
    localparam RIGHT = 2'd2 ;
    localparam STOP = 2'd03 ;

    always @ (posedge clk)
    begin
        if (sensorInput[1]) // if the middle is active
        begin
            if (sensorInput[0] && ~sensorInput[2]) // if the middle and the left is activated, then we need to turn right
            begin
                rSpeedState <= RIGHT;
            end else if (sensorInput[2] && ~sensorInput[0])
            begin
                rSpeedState <= LEFT ;
            end else if (sensorInput[2] && sensorInput[0]) 
            begin
                rSpeedState <= STOP ; 
            end else if (sensorInput[2] && sensorInput[0]) 
            begin
                rSpeedState <= FORWARD ; 
            end
        end else begin
            rSpeedState <= STOP;
        end
    end

endmodule
