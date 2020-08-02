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
    
    output wire pathReady,
    output wire [2:0] pathCorrection

    );

    localparam pathFORWARD = 3'd0 ;
    localparam pathRIGHT = 3'd1 ;
    localparam pathLEFT = 3'd2 ;
    localparam pathSTOP = 3'd03 ;
    localparam pathBACK = 3'd04 ;
    localparam pathWait = 3'd05 ;

    reg [2:0] rPathCorrection;
    reg rPathReady;
    reg [31:0] counter;
    reg [30:0] countMove;
    
    wire readySignal;
    
    reg [31:0] countRight;
    reg [31:0] countLeft;
    
    reg [31:0] countForward;
    reg [31:0] countBack;
    
    initial 
    begin
        rPathCorrection = pathSTOP;
        counter = 0;
        countMove = 0;
        countForward = 0;
        rPathReady=0;
        countRight=0;
        countLeft=0;
        countBack = 0;
    end

    assign pathCorrection = rPathCorrection;
    assign pathReady = rPathReady;

    always @ (posedge clk)
    begin
    
        if (rPathReady) begin
            rPathReady <= 0;
        end
        
        if (~rPathReady) begin
            
            if (survivalMode)
            begin
            // try to maintain a
                if (metalInputs[1]) // if the middle is active
                    begin
                        if (metalInputs[0] && ~metalInputs[2]) // if the middle and the left is activated, then we need to turn right
                        begin
                            rPathCorrection <= pathLEFT;
                            rPathReady<= 1;
                            counter <=0;
                            countMove<= 0;
                            countForward<= 0;
                            countLeft<=countLeft+1;
//                            countRight<=0;
                        end else if (~metalInputs[0] && metalInputs[2])
                        begin
                            rPathCorrection <= pathRIGHT ;
//                            countLeft<=0;
                            rPathReady<= 1;
                            counter <=0;
                            countMove<= 0;
                            countRight<=countRight+1;
                        end else if (metalInputs[0] && metalInputs[2])
                        begin
                            rPathCorrection <= pathSTOP;
                            rPathReady<= 1;
                            counter <=0;
                            countMove<= 0;
                            countForward<= 0;
                            countRight<=0;
                            countLeft<=0;
                        end else if (~metalInputs[0] && ~metalInputs[2])
                        begin
                            if (countLeft>500000000) begin
                                rPathCorrection <= pathLEFT ;
                                countLeft <= countLeft +1 ; 
//                                countRight<=0;
                            end else if (countRight >500000000 ) begin
                                rPathCorrection <= pathRIGHT ;
                                countRight <= countRight +1 ; 
//                                countLeft<=0;
                            end else begin
                                rPathCorrection <= pathFORWARD ;
                                countForward <= countForward +1 ; 
                            end                            
                            rPathReady<= 1;
                            counter <=0;
                            countMove<= 0;
                            
                        end
                end else begin
                // try to get aligned asap
                    if (metalInputs[0] && ~metalInputs[2]) // if the middle and the left is activated, then we need to turn right
                        begin
                            counter <=0;
                            countMove<= countMove+1;
                            
                            if (countMove>5000000) begin
                                rPathCorrection <= pathFORWARD ;
                                countForward<=countForward+1;
//                                countRight <= 0 ; 
//                                countLeft <= 0 ; 
                            end else begin
                                rPathCorrection <= pathLEFT;
                                countLeft <= countLeft +1 ; 
//                                countRight <= 0 ; 
                            end
                            rPathReady<= 1;
                        end else if (~metalInputs[0] && metalInputs[2])
                        begin
                            countMove<= countMove+1;
                            counter <=0;
                            
                            if (countMove>5000000) begin
                                rPathCorrection <= pathFORWARD ;
//                                countLeft<=0;
//                                countRight<=0;
                                countForward<=countForward+1;
                            end else begin
                                rPathCorrection <= pathRIGHT ;
                                countRight<=countRight+1;
                            end
                            rPathReady<= 1;
                        end else if (metalInputs[0] && metalInputs[2])
                        begin
                            rPathCorrection <= pathRIGHT;
                            countRight<=countRight+1;
                            countMove<= 0;
                            counter <=0;
                            rPathReady<= 1;
                        end else if (~metalInputs[0] && ~metalInputs[2])
                        begin
                            countMove <=0;
                            counter <= counter + 1;
                            if (countForward > 0) begin
                                rPathCorrection <= pathFORWARD; 
                                countForward<=countForward+1;
//                                countLeft<=0;
//                                countRight<=0;
                            end else begin
                                rPathCorrection <= pathBACK; 
                            end
                            rPathReady<= 1;
                        end 
                
                        
                        if (counter>70_000_000) begin
                        rPathCorrection <= pathBACK;
                        rPathReady<= 1;
                        end
                        
                                                
                        if (counter>140_000_000) begin
                        rPathCorrection <= pathSTOP;
                        rPathReady<= 1;
                        end
                end
            end
        end
        
    end
endmodule
