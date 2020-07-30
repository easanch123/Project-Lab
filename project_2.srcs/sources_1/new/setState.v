`timescale 1ns / 1ps
`default_nettype none

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/28/2020 07:40:09 PM
// Design Name: 
// Module Name: interpretInputs
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


module setState(
    input wire clk,

    input wire [4:0] remoteInputs,
    input wire remoteReady,
    
    input wire motorReady,
    input wire motorStop, 

    output wire [4:0] state,
    output wire stateReady,
    output wire survivalMode
    );

    // User-Input States
    localparam FORWARD = 5'd02 ;
    localparam STOP = 5'd03 ; 
    localparam LEFT = 5'd04 ;
    localparam ABOUTFACE = 5'd05 ;
    localparam RIGHT = 5'd06 ;
    localparam BACKWARD = 5'd08 ;

    // Survival States
    localparam SURVIVAL = 5'd0 ; 
    localparam TRACKING = 5'd12;
    localparam STRAIGHT = 5'd07;
    localparam TURNLEFT = 5'd09;
    localparam TURNRIGHT = 5'd10;
    localparam UTURN = 5'd11;
    
    reg [4:0] rState ;

    reg rStateReady;

    reg rSurvivalActivate;

    assign stateReady = rStateReady ;
    assign state = rState ;

    wire UserInputReady;

    assign survivalMode = rSurvivalActivate;
    
    wire tracking, WaitCondition, WaitSurvival, WaitNormal;

    assign Tracking = ((rState==STRAIGHT || rState==TURNLEFT || rState==TURNRIGHT || rState==UTURN || rState==SURVIVAL) && (~rStateReady && rSurvivalActivate && motorReady && ~motorStop))  ;
    assign WaitCondition = (motorStop && ~rStateReady && remoteReady && motorReady); // ListenCondition
    assign WaitSurvival = (WaitCondition && rSurvivalActivate) ;
    assign WaitNormal =  (WaitCondition && ~rSurvivalActivate) ; 

    initial 
    begin
        rState = 3;
        rStateReady = 0;
        rSurvivalActivate = 0;
    end

    always @ (posedge clk) 
    begin
        // Reset the state ready output bit
        if (rStateReady) 
        begin
            rStateReady <= 0 ;

        end else begin
            // Tracking means that we are in a position in which we need to update our state to the tracking state because we
            // just finished making an intersection decision and now we are back on autopilot tracking
            if (Tracking) 
            begin
                rState <= TRACKING ;
                rStateReady <= 1;
            
            // if we are in SurvivalWait, then we are awaiting input from the user
            end else if (WaitSurvival)
            begin
                case (remoteInputs)
                    STRAIGHT: 
                    begin
                        rState <= STRAIGHT;
                        rStateReady <= 1;
                    end

                    TURNLEFT: 
                    begin
                        rState <= TURNLEFT;
                        rStateReady <= 1;
                    end  

                    TURNRIGHT: 
                    begin
                        rState <= TURNRIGHT;
                        rStateReady <= 1;
                    end  

                    UTURN: 
                    begin
                        rState <= UTURN;
                        rStateReady <= 1;
                    end 

                    SURVIVAL: 
                    begin
                        rSurvivalActivate <= 0 ;
                        rState <= STOP;
                        rStateReady <= 1;
                    end  
                endcase
            end else if (WaitNormal) 
            begin
                case (remoteInputs) 

                    STOP: 
                    begin
                        rState <= STOP;
                        rStateReady <= 1;
                    end  

                    SURVIVAL: 
                    begin
                        rSurvivalActivate <= 1 ;
                        rState <= SURVIVAL;
                        rStateReady <= 1;
                    end  

                    FORWARD: 
                    begin
                        rState <= FORWARD;
                        rStateReady <= 1;
                    end

                    LEFT: 
                    begin
                        rState <= LEFT ; 
                        rStateReady <= 1;
                    end  

                    RIGHT: 
                    begin
                        rState <= RIGHT;
                        rStateReady <= 1;
                    end  

                    BACKWARD: 
                    begin
                        rState <= BACKWARD;
                        rStateReady <= 1;
                    end    

                endcase
            end
        end
    end
endmodule
