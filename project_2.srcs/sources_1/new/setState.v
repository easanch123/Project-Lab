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
       
       input wire [2:0] pathCorrection,
       input wire pathReady,

       output wire survivalMode,
       output wire [3:0] state,
       output wire stateReady
       
    );

    // User-Inputs
    localparam FORWARD = 4'd02 ;
    localparam STOP = 4'd05 ; 
    localparam LEFT = 4'd04 ;
    localparam RIGHT = 4'd06 ;
    localparam BACKWARD = 4'd08 ;
    localparam SURVIVAL = 4'd0 ;
    
    // Sensor Inputs
    localparam pathFORWARD = 3'd0 ;
    localparam pathLEFT = 3'd1 ;
    localparam pathRIGHT = 3'd2 ;
    localparam pathSTOP = 3'd03 ;
    localparam pathBACK = 3'd04 ;
    
    // Output States

    reg [3:0] rState ;
    reg rStateReady;
    reg rSurvivalMode ;
 
    // wire Tracking, WaitCondition, WaitSurvival, WaitNormal;

    assign stateReady = rStateReady ;
    assign state = rState ;
    assign survivalMode = rSurvivalMode;

//    wire UserInputReady;

//    assign Tracking = ((rSurvivalMode && motorReady && ~motorStop))  ;
//    assign WaitCondition = (motorStop && remoteReady && motorReady); // ListenCondition
//    assign WaitSurvival = (WaitCondition && rSurvivalMode) ;
//    assign WaitNormal =  (WaitCondition && ~rSurvivalMode) ; 

    initial 
    begin
        rState = STOP;
        rStateReady = 0;
        rSurvivalMode = 0;
    end

    always @ (posedge clk) 
    begin
        
        if (rStateReady)
        begin
            rStateReady<= 0;
        end

        if (~rStateReady)
        begin
            if (rSurvivalMode) // in survival mode and we dont have remote being read
            begin
                if (pathReady && ~remoteReady) begin
                    case (pathCorrection)
                        pathSTOP: 
                        begin
                            rState <= STOP;
                            rStateReady <= 1;
                        end  
                        
                        pathFORWARD: 
                        begin
                            rState <= FORWARD;
                            rStateReady <= 1;
                        end
    
                        pathLEFT: 
                        begin
                            rState <= LEFT ; 
                            rStateReady <= 1;
                        end  
    
                        pathRIGHT: 
                        begin
                            rState <= RIGHT;
                            rStateReady <= 1;
                        end  
    
                        pathBACK: 
                        begin
                            rState <= BACKWARD;
                            rStateReady <= 1;
                        end   
                        
                        default:
                        begin
                            rState <= STOP;
                            rStateReady <= 1;
                        end   
                    endcase
                end 
                
                if (remoteReady)
                begin
                    case (remoteInputs)
                        STOP: 
                        begin
                            rState <= STOP;
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
    
                        SURVIVAL: 
                        begin
                            rState <= SURVIVAL;
                            rStateReady <= 1;
                            rSurvivalMode <= (rSurvivalMode) ? (0) : (1);
                        end   
                        
                        default:
                        begin
                            rState <= STOP;
                            rStateReady <= 1;
                        end   
                            
                    endcase
                end
                
            end

            if (~rSurvivalMode)
            begin
                if (remoteReady)
                begin
                    case (remoteInputs)
                        STOP: 
                        begin
                            rState <= STOP;
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
    
                        SURVIVAL: 
                        begin
                            rState <= SURVIVAL;
                            rStateReady <= 1;
                            rSurvivalMode <= (rSurvivalMode) ? (0) : (1);
                        end   
                        
                        default:
                        begin
                            rState <= STOP;
                            rStateReady <= 1;
                        end   
                            
                    endcase
                end
            end
        end
    end

endmodule
