`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/20/2020 09:41:30 PM
// Design Name: 
// Module Name: survivalState
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


module survivalState(

        input wire clk,
        input wire [7:0] survivalDutyA,
        input wire [7:0] survivalDutyB,
        input wire [3:0] state,
        input wire [1:0] speedState

    );

        localparam SURVIVAL = 4'b0000 ;

        localparam FORWARD = 2'd0 ;
        localparam LEFT = 2'd1 ;
        localparam RIGHT = 2'd2 ;
        localparam STOP = 2'd03 ;

        localparam MAXSPEED = 255 ; 

        reg [7:0] dutyA;
        reg [7:0] dutyB;

        reg speedIncrease;
        reg speedDecrease;

        reg stepR, stepL;

        initial begin
            dutyA = 7'd100 ;
            dutyB = 7'd100 ; 
            speedIncrease = 1 ;
            speedDecrease = 10 ; 
            stepR = 0;
            stepL = 0;
        end

        always @ (posedge clk)
        begin
            if (state==SURVIVAL)
            begin
                case(speedState)

                    FORWARD :  
                    begin
                        stepR <= (dutyA < MAXSPEED-speedIncrease) ? (speedIncrease) : (0);
                        stepL <= (dutyA < MAXSPEED-speedIncrease) ? (speedIncrease) : (0);
                    end

                    LEFT :  
                    begin
                        stepR <= (dutyA < MAXSPEED-speedIncrease) ? (speedIncrease) : (0);
                        stepL <= (dutyA > speedDecrease) ? (-speedDecrease) : (0);
                    end

                    RIGHT :  
                    begin
                        stepR <= (dutyA > speedDecrease) ? (-speedDecrease) : (0);
                        stepL <= (dutyA < MAXSPEED-speedIncrease) ? (speedIncrease) : (0);
                    end

                    STOP :  
                    begin
                        stepR <= (dutyA > speedDecrease) ? (-speedDecrease) : (0);
                        stepL <= (dutyA > speedDecrease) ? (-speedDecrease) : (0);
                    end

                endcase

                dutyA<= dutyA + stepR ;
                dutyB <= dutyB + stepL ; 
            end
            
        end

endmodule
