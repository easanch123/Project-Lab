`timescale 1ns / 1ps
`default_nettype none

//////////////////////////////////////////////////////////////////////////////////
// Company: Texas Tech University
// Engineer: Edward Sanchez
// 
// Create Date: 06/27/2020 04:38:53 PM
// Design Name: Arche
// Module Name: stateSensors
// Project Name: Synchronous State Machine: Rover
// Target Devices: Xilinx Artix-7, Basys3 Board
// Tool Versions: Xilinx 2020.1
// Description: Arche is a Greek for "beginning," and the name of the Design.
// As the first digital design FPGA project with sensors created by the team
// we believed it was a fitting name. 
// The purpose of this rover is to serve as a cool toy that can be controlled by 
// a remote control. It is also able to stay within on a metal path.  
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////
//
//
//
// PURPOSE: Purpose of this module is to intake all of the different sensor inputs 
// present in the design (IR sensors, metal sensors, distance sensors, and stall sensor)
// and output an appropriate state for the machine. 
//
//
                                            
module setState (

       input wire clk,

       input wire [3:0] remoteInputs,
       input wire remoteReady,
       input wire motorReady,
       input wire motorStop,
       
       output wire survivalMode,   
       output wire [3:0] state,
       output wire stateReady
       
    );

    // User-Input States
    localparam FORWARD = 4'd02 ;
    localparam STOP = 4'd05 ; 
    localparam LEFT = 4'd04 ;
    localparam RIGHT = 4'd06 ;
    localparam BACKWARD = 4'd01 ;
    localparam SURVIVAL = 4'd0 ;
    localparam TRACKING = 4'd3;

    
    reg [3:0] rState ;
    reg rStateReady;
    reg rSurvivalMode ;
    wire Tracking, WaitCondition, WaitSurvival, WaitNormal;

    assign stateReady = rStateReady ;
    assign state = rState ;
    assign survivalMode = rSurvivalMode;

    wire UserInputReady;

    assign Tracking = ((~rStateReady && rSurvivalMode && motorReady && ~motorStop))  ;
    assign WaitCondition = (motorStop && ~rStateReady && remoteReady && motorReady); // ListenCondition
    assign WaitSurvival = (WaitCondition && rSurvivalMode) ;
    assign WaitNormal =  (WaitCondition && ~rSurvivalMode) ; 

    initial 
    begin
        rState = 5;
        rStateReady = 0;
        rSurvivalMode = 0;
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
                    
                    STOP: 
                    begin
                        rState <= STOP;
                        rStateReady <= 1;
                    end  

                    SURVIVAL: 
                    begin
                        rSurvivalMode <= 0 ;
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
                        rSurvivalMode <= 1 ;
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
