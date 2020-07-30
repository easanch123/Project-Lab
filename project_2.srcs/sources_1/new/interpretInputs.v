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


module interpretInputs(
    input wire clk,
    input wire [2:0] metalInputs,
    input wire distanceInput,
    input wire [4:0] remoteInputs,
    input wire remoteReady,
    input wire motorReady, // input that comes from the executing model which tells us if the execution has completed

    output wire [4:0] state,
    output wire ready
    );


    localparam SURVIVAL = 5'd00 ; 
    localparam OFF_SURVIVAL = 5'd01 ;
    localparam FORWARD = 5'd02 ;
    localparam STOP = 5'd03 ;
    localparam LEFT = 5'd04 ;
    localparam ABOUTFACE = 5'd05 ;
    localparam RIGHT = 5'd06 ;
    localparam BACKWARD = 5'd08 ;

    localparam TRACK = 5'd07;
    localparam TURNLEFT = 5'd09;
    localparam TURNRIGHT = 5'd10;
    localparam UTURN = 5'd11;
    
    reg [4:0] rState ;

    reg rReady;
    reg rSurvivalActivate;

    assign ready = rReady ;
    assign state = rState ; 
    
    initial 
    begin
        rState = 3;
        rReady = 0;
        rSurvivalActivate = 0;
    end

    always @ (posedge clk) 
    begin
        if (rReady) 
        begin
            rReady <= 0 ;
        end
        // motorReady --> the action saying it is ready for a new action
        // ready --> a signal telling us if a current state is being read 
        // remoteReady --> a ready signal from remote
        // rSurvivalActivate --> tells us if we are in survival mode

        // If the motor is ready for a new action, 
        // and we havnt just put a new state out,
        // and our remote is ready,
        // and we arent in survival mode
        // and we are waiting for input

        if (motorReady && ~rReady && remoteReady && ~rSurvivalActivate)
        begin
            case (remoteInputs) 

                    OFF_SURVIVAL: 
                    begin
                        rSurvivalActivate <= 0;
                        rState <= STOP ;
                        rReady <= 1;
                    end 

                    FORWARD: 
                    begin
                        rState <= FORWARD;
                        rReady <= 1;
                    end

                    LEFT: 
                    begin
                        rState <= LEFT ; 
                        rReady <= 1;
                    end  

                    RIGHT: 
                    begin
                        rState <= RIGHT;
                        rReady <= 1;
                    end  

                    BACKWARD: 
                    begin
                        rState <= BACKWARD;
                        rReady <= 1;
                    end    

                    STOP: 
                    begin
                        rState <= STOP;
                        rReady <= 1;
                    end  

                    SURVIVAL: 
                    begin
                        rSurvivalActivate <= 1;
                    end  

            endcase

        end

        // in this case, our motor is ready for more input
        // we havent put a new state in a previous cycle
        // the remote signal is ready to read
        // and we are in survival mode
        if (motorReady && ~rReady && remoteReady && rSurvivalActivate)
        begin
            case (remoteInputs) 

                    TRACK: 
                    begin
                        rState <= TRACK;
                        rReady <= 1;
                    end

                    TURNLEFT: 
                    begin
                        rState <= TURNLEFT ; 
                        rReady <= 1;
                    end  

                    TURNRIGHT: 
                    begin
                        rState <= TURNRIGHT;
                        rReady <= 1;
                    end  

                    UTURN: 
                    begin
                        rState <= UTURN;
                        rReady <= 1;
                    end 

            endcase
        end
    end




endmodule
