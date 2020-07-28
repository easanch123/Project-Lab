`timescale 1ns / 1ps
`default_nettype none

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
    output wire [1:0] speedChange

    );

    reg [1:0] rSpeedChange;
    
    localparam SURVIVAL = 4'd00 ; 

    assign speedChange = rSpeedChange;
    
    initial begin
    rSpeedChange = 0;
    end
    

    localparam FORWARD = 2'd0 ;
    localparam RIGHT= 2'd1 ;
    localparam LEFT = 2'd2 ;
    localparam STOP = 2'd03 ;

    always @ (posedge state) 
    begin
        rSpeedChange <= 0; 
    end

    always @ (posedge clk)
    begin
        if (state == SURVIVAL) 
        begin
            if (rSpeedChange!= STOP)
            begin
                if (sensorInput[1]) // if the middle is active
                begin
                    if (sensorInput[0] && ~sensorInput[2]) 
                    begin
                        rSpeedChange <= RIGHT; // if the middle and the left is activated, then we need to turn right
                        
                    end else if (sensorInput[2] && ~sensorInput[0]) 
                    begin
                        rSpeedChange <= LEFT ; // if the middle and the right is activated, then we need to turn left
        
                    end else if (sensorInput[2] && sensorInput[0])  
                    begin
                        rSpeedChange <= STOP ; // if all are active, we need to stop
                        
                    end else if (~sensorInput[2] && ~sensorInput[0]) begin
                        rSpeedChange <= FORWARD ; // if the middle and the right & left is is un-activated, then we need to go forward
                    end
                end else begin
                    if (sensorInput[0] && ~sensorInput[2]) 
                    begin
                        rSpeedChange <= RIGHT; // if the left is activated, then we need to turn right
                        
                    end else if (sensorInput[2] && ~sensorInput[0]) 
                    begin
                        rSpeedChange <= LEFT ; // if the middle and the right is activated, then we need to turn left
                    end else begin
                    rSpeedChange <= STOP ;
                    end
                end
            end
        end
    end
endmodule
