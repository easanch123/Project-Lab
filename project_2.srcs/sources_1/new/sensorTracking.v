`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/30/2020 08:35:39 PM
// Design Name: 
// Module Name: sensorTracking
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


module sensorTracking(

    input wire clk,
    input wire [2:0] metalInputs,
    input wire survivalMode,
    input wire motorStop,
    output wire [2:0] pathCorrection

    );

    localparam pathFORWARD = 3'd0 ;
    localparam pathRIGHT = 3'd1 ;
    localparam pathLEFT = 3'd2 ;
    localparam pathSTOP = 3'd03 ;
    localparam pathBACK = 3'd04 ;

    reg [2:0] rPathCorrection;
    reg [31:0] counter;
    reg [27:0] countMove;
    
    reg [21:0] countForward;
    
    initial 
    begin
        rPathCorrection = pathSTOP;
        counter = 0;
        countMove = 0;
        countForward = 0;
    end

    assign pathCorrection = rPathCorrection;

    always @ (posedge clk)
    begin
    
        if (survivalMode)
        begin
        // try to maintain a
            if (metalInputs[1]) // if the middle is active
                begin
                    if (metalInputs[0] && ~metalInputs[2]) // if the middle and the left is activated, then we need to turn right
                    begin
                        rPathCorrection <= pathLEFT;
                        counter <=0;
                        countMove<= 0;
                        countForward<= 0;
                    end else if (~metalInputs[0] && metalInputs[2])
                    begin
                        rPathCorrection <= pathRIGHT ;
                        counter <=0;
                        countMove<= 0;
                        countForward<= 0;
                    end else if (metalInputs[0] && metalInputs[2])
                    begin
                        rPathCorrection <= pathSTOP;
                        counter <=0;
                        countMove<= 0;
                        countForward<= 0;
                    end else if (~metalInputs[0] && ~metalInputs[2])
                    begin
                        rPathCorrection <= pathFORWARD ;
                        counter <=0;
                        countMove<= 0;
                        countForward <= countForward +1 ; 
                    end
            end else begin
            // try to get aligned asap
                if (metalInputs[0] && ~metalInputs[2]) // if the middle and the left is activated, then we need to turn right
                    begin
                        counter <=0;
                        countMove<= countMove+1;
                        countForward<=countForward+1;
                        if (countMove>1000000) begin
                        rPathCorrection <= pathFORWARD ;
                        end else begin
                        rPathCorrection <= pathLEFT;
                        end
                    end else if (~metalInputs[0] && metalInputs[2])
                    begin
                        countMove<= countMove+1;
                        counter <=0;
                        countForward<=countForward+1;
                        if (countMove>1000000) begin
                        rPathCorrection <= pathFORWARD ;
                        end else begin
                        rPathCorrection <= pathRIGHT ;
                        
                        end
                    end else if (metalInputs[0] && metalInputs[2])
                    begin
                        rPathCorrection <= pathRIGHT;
                        countMove<= 0;
                        counter <=0;
                        countForward<=0;
                    end else if (~metalInputs[0] && ~metalInputs[2])
                    begin
                        countMove <=0;
                        counter <=0;
                        countForward <= countForward+1;
                        if (countForward > 0) begin
                            
                        rPathCorrection <= pathRIGHT; 
                        end else begin
                        
                        rPathCorrection <= pathBACK; 
                        end
                    end else begin
                        counter <= counter + 1;
                        countMove <=0;
                        countForward <= countForward+1;
                        if (countForward > 0) begin
                            
                        rPathCorrection <= pathRIGHT; 
                        end else begin
                        
                        rPathCorrection <= pathBACK; 
                        end
                    end
            
                    
                    if (counter>70_000_000) begin
                    rPathCorrection <= pathSTOP;
                    end
            end
        end
    end
endmodule
