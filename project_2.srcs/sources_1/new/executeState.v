`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/27/2020 04:16:02 PM
// Design Name: 
// Module Name: top
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


module executeState (

    input wire clk,
    input wire [3:0] state,
    input wire stateReady,

    output wire motorReady,
    output wire motorStop,

    input wire distanceSensor,
    input wire [2:0] metalInputs,
    input wire distanceInputs,

    output wire [2:0] accelerationA,
    output wire [2:0] accelerationB,
    output wire accelerationReady 
    
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
    

    localparam survivalRIGHT = 0;
    localparam survivalLEFT = 1;
    localparam survivalSTRAIGHT = 2;
    localparam survivalSTOP = 3;

    localparam ACCELERATIONSPEED = 1;
    localparam DECELERATIONSPEED = -1;
    

    reg rAccelerationReady;
    reg [2:0] rAccelerationA;
    reg [2:0] rAccelerationB;
    
    reg rMotorReady;
    reg rMotorStop;

    reg [32:0] rStateCount;

    reg [32:0] rActionCount;

    assign motorReady = ~rAccelerationReady;
    assign motorStop = rMotorStop;
    
    assign accelerationA = rAccelerationA;
    assign accelerationB = rAccelerationB;

    reg [1:0] rSensorDecision; 
    
 

    initial 
    begin
        rAccelerationReady = 0;
        rMotorReady = 0;
        rMotorStop = 0;
    end
    
    // the point of this module is to be given a state and then to give the outputs for the motor

    always @ (posedge clk)
    begin
        if (metalInputs[1]) // if the middle is active
        begin
            if (metalInputs[0] && ~metalInputs[2]) // if the middle and the left is activated, then we need to turn right
            begin
                rSensorDecision <= survivalRIGHT;
            end else if (metalInputs[2] && ~metalInputs[0])
            begin
                rSensorDecision <= survivalLEFT ;
            end else if (metalInputs[2] && metalInputs[0]) 
            begin
                rSensorDecision <= survivalSTOP ; 
            end else if (metalInputs[2] && metalInputs[0]) 
            begin
                rSensorDecision <= survivalSTRAIGHT ; 
            end
        end else begin
            rSensorDecision <= survivalSTOP;
        end
    end


    always @ (posedge clk) 
    begin

        if (stateReady && ~rAccelerationReady) begin
            case (state)
                STRAIGHT: 
                begin
                    rAccelerationA <= ACCELERATIONSPEED ;
                    rAccelerationB <= ACCELERATIONSPEED ; 
                    rAccelerationReady <= 1;
                    rActionCount <= 1_000_000;
                    rStateCount<= 0;
                end

                TURNLEFT: 
                begin
                    rAccelerationA <= ACCELERATIONSPEED;
                    rAccelerationB <= DECELERATIONSPEED ; 
                    rAccelerationReady <= 1;
                    rActionCount <= 1_000_000;
                    rStateCount<= 0;
                end  

                TURNRIGHT: 
                begin
                    rAccelerationA <= ACCELERATIONSPEED;
                    rAccelerationB <= DECELERATIONSPEED ; 
                    rAccelerationReady <= 1;
                    rActionCount <= 1_000_000;
                    rStateCount<= 0;
                end  

                UTURN: 
                begin
                    rAccelerationA <= ACCELERATIONSPEED;
                    rAccelerationB <= DECELERATIONSPEED ; 
                    rAccelerationReady <= 1;
                    rActionCount <= 1_000_000;
                    rStateCount<= 0;
                end 

                STOP: 
                begin
                    rAccelerationA <= 0;
                    rAccelerationB <= 0 ; 
                    rAccelerationReady <= 1;
                    rMotorStop <= 1;
                    rActionCount <= 1_000_000;
                    rStateCount<= 0;
                end  

                SURVIVAL: 
                begin

                    case (rSensorDecision)

                        survivalRIGHT:
                        begin
                            rAccelerationA <= ACCELERATIONSPEED;
                            rAccelerationB <= ACCELERATIONSPEED ; 
                            rAccelerationReady <= 1;
                            rMotorStop <= 1;
                            rActionCount <= 1_500_000;
                            rStateCount<= 0;
                        end
                        survivalLEFT:
                        begin
                            rAccelerationA <= 0;
                            rAccelerationB <= 0 ; 
                            rAccelerationReady <= 1;
                            rMotorStop <= 1;
                            rActionCount <= 1_000_000;
                            rStateCount<= 0;
                        end
                        survivalSTRAIGHT:
                        begin
                            rAccelerationA <= 0;
                            rAccelerationB <= 0 ; 
                            rAccelerationReady <= 1;
                            rMotorStop <= 1;
                            rActionCount <= 1_000_000;
                            rStateCount<= 0;
                        end
                        survivalSTOP:
                        begin
                            rAccelerationA <= 0;
                            rAccelerationB <= 0 ; 
                            rAccelerationReady <= 1;
                            rMotorStop <= 1;
                            rActionCount <= 1_000_000;
                            rStateCount<= 0;
                        end
                        
                        
                    endcase
                end  

                FORWARD: 
                begin
                    rAccelerationA <= ACCELERATIONSPEED;
                    rAccelerationB <= DECELERATIONSPEED ; 
                    rAccelerationReady <= 1;
                    rActionCount <= 1_000_000;
                    rStateCount<= 0;
                end

                LEFT: 
                begin
                    rAccelerationA <= ACCELERATIONSPEED;
                    rAccelerationB <= DECELERATIONSPEED ; 
                    rAccelerationReady <= 1;
                    rActionCount <= 1_000_000;
                    rStateCount<= 0;
                end  

                RIGHT: 
                begin
                    rAccelerationA <= ACCELERATIONSPEED;
                    rAccelerationB <= DECELERATIONSPEED ; 
                    rAccelerationReady <= 1;
                    rActionCount <= 1_000_000;
                    rStateCount<= 0;
                end  

                BACKWARD: 
                begin
                    rAccelerationA <= ACCELERATIONSPEED;
                    rAccelerationB <= DECELERATIONSPEED ; 
                    rAccelerationReady <= 1;
                    rActionCount <= 1_000_000;
                    rStateCount<= 0;
                end    

            endcase
        end if (rAccelerationReady) begin
            rStateCount <= rStateCount + 1;
            if (rStateCount == rActionCount) begin
                rAccelerationReady <= 0;
            end
        end
    end

    
endmodule
