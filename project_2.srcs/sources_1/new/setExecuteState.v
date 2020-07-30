`timescale 1ns / 1ps
`default_nettype none

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2020 07:31:21 AM
// Design Name: 
// Module Name: setExecuteState
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


module setExecuteState(
    input wire clk,
    input wire [4:0] state,
    input wire stateReady,
    input wire distanceInput,
    input wire [2:0] metalInputs,

    output wire motorReady,

    output wire motorStop
    
    output wire accelerationReady,

    output wire [8:0] accelerationA,
    output wire [8:0] accelerationB,

    output wire velocityReady,

    output wire [8:0] velocityA,
    output wire [8:0] velocityB

);

    // User-Input States
    localparam FORWARD = 5'd02 ;
    localparam STOP = 5'd03 ; // same as wait state
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

    // Movement Controls   
    localparam ACCELERATION = 1;
    localparam DECCELERATION = -1;

    reg [4:0] localState = 3;

    reg [8:0] rAccelerationA;
    reg [8:0] rAccelerationB;

    reg rAccelerationReady;
    reg rStopReady;
    reg rMotorReady;
    reg rMotorStop;
    reg rSurvival; 
    reg rStateReady;

    reg [16:0] rCounter;

    reg rst = 1;

    initial 
    begin
        rAccelerationA = 0 ;
        rAccelerationB = 0 ;
        rAccelerationReady = 0 ;
        rMotorReady = 0 ;
        rStopReady = 0;
    end

    always @ (posedge stateReady) 
    begin


    end

    always @ (posedge clk)
    begin

        // if the state changes in the upper module, then that means a user input has been 
        // given. We only care about a user input if we are ready to execute a new task
        // However, we will only get stateReady = 1 if the motor is Ready
        
        // state gets updated when we have a valid state and when our motor is ready
        // to take in a new state for execution
        if (stateReady) 
        begin
            localState <= state ;
            rCounter <= 1; 
            rst <= 1;
        end
        // if our reset signal is on, this means that we have finished executing a 
        // complete step and so we want to reset the signal. 
        // Purpose: change motor ready to 1 so that we can get a new statready
        if (rst) 
        begin
            rAccelerationReady <= 0;
            rMotorReady <= 1;
            if (~stateReady) // as soon as stateReady goes to 0, then we begin the journey of state execution
            begin
                rst <= 0 ;
            end
        end
        
        // If we have successfully reset the signals. 
        if (~rst)
        begin

            if (~rSurvival)
            begin
                case (localState)

                    FORWARD: 
                    begin
                        rSurvival <= 0;
                        rAccelerationA <= ACCELERATION;
                        rAccelerationB <= ACCELERATION;
                        rAccelerationReady <= 1;
                        rMotorStop<= 0;
                        rst <= 1;
                        
                    end

                    STOP:
                    begin
                        rSurvival <= 0;
                        rMotorStop <= 1;
                        rst <= 1;
                    end

                    SURVIVAL:
                    begin
                        rSurvival <= 1;
                    end

                    LEFT: 
                    begin
                        rSurvival <= 0;
                        rAccelerationA <= ACCELERATION;
                        rAccelerationB <= DECCELERATION;
                        rAccelerationReady <= 1; 
                        rMotorStop <= 0;
                        rst <= 1;
                    end  

                    RIGHT: 
                    begin
                        rSurvival <= 0;
                        rAccelerationA <= DECCELERATION;
                        rAccelerationB <= ACCELERATION;
                        rAccelerationReady <= 1; 
                        rMotorStop <= 0 ;
                        rst <= 1;
                    end  

                    BACKWARD: 
                    begin
                        rSurvival <= 0;
                        rAccelerationA <= DECCELERATION;
                        rAccelerationB <= DECCELERATION;
                        rAccelerationReady <= 1; 
                        rMotorStop <= 0;
                        rst <= 1;
                    end    
                endcase 
            end else begin

                case (localState)
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
                endcase
            end
        end



endmodule
