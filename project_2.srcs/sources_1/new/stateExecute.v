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


module stateExecute (

    input wire clk,
    input wire [3:0] state,
    input wire stateReady,

    output wire motorReady,
    output wire motorStop,

    input wire distanceSensor,
    input wire [2:0] metalInputs,
    input wire distanceInputs,

    output wire accelerationA,
    output wire accelerationB,
    output wire accelerationReady 
    
    );

    reg rAccelerationReady;
    reg rMotorReady;
    reg rMotorStop;

    reg [32:0] rStateCount;

    reg [32:0] rActionCount;

    assign motorReady = ~rAccelerationReady;
    assign motorStop = rMotorStop;

    reg [1:0] rSensorDecision; 

    localparam moveRIGHT = 0;
    localparam moveLEFT = 1;
    localparam moveSTRAIGHT = 2;

    localparam ACCELERATIONSPEED = 1;
    localparam DECELERATIONSPEED = -1;

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
                rSensorDecision <= RIGHT;
            end else if (metalInputs[2] && ~metalInputs[0])
            begin
                rSensorDecision <= LEFT ;
            end else if (metalInputs[2] && metalInputs[0]) 
            begin
                rSensorDecision <= STOP ; 
            end else if (metalInputs[2] && metalInputs[0]) 
            begin
                rSensorDecision <= FORWARD ; 
            end
        end else begin
            rSensorDecision <= STOP;
        end
    end


    always @ (posedge clk) 
    begin

        if (stateReady && ~rAccelerationReady) begin
            case (state)
                STRAIGHT: 
                begin
                    accelerationA <= ACCELERATIONSPEED ;
                    accelerationB <= ACCELERATIONSPEED ; 
                    rAccelerationReady <= 1;
                    rActionCount <= 1_000_000;
                    rStateCount<= 0;
                end

                TURNLEFT: 
                begin
                    accelerationA <= ACCELERATIONSPEED;
                    accelerationB <= DECELERATIONSPEED ; 
                    rAccelerationReady <= 1;
                    rActionCount <= 1_000_000
                    rStateCount<= 0;
                end  

                TURNRIGHT: 
                begin
                    accelerationA <= ACCELERATIONSPEED;
                    accelerationB <= DECELERATIONSPEED ; 
                    rAccelerationReady <= 1;
                    rActionCount <= 1_000_000
                    rStateCount<= 0;
                end  

                UTURN: 
                begin
                    accelerationA <= ACCELERATIONSPEED;
                    accelerationB <= DECELERATIONSPEED ; 
                    rAccelerationReady <= 1;
                    rActionCount <= 1_000_000
                    rStateCount<= 0;
                end 

                STOP: 
                begin
                    accelerationA <= 0;
                    accelerationB <= 0 ; 
                    rAccelerationReady <= 1;
                    rMotorStop <= 1;
                    rActionCount <= 1_000_000
                    rStateCount<= 0;
                end  

                SURVIVAL: 
                begin

                    case (rSensorDecision)

                        moveRIGHT:
                        begin
                            accelerationA <= ACCELERATIONSPEED;
                            accelerationB <= ACCELERATIONSPEED ; 
                            rAccelerationReady <= 1;
                            rMotorStop <= 1;
                            rActionCount <= 1_500_000
                            rStateCount<= 0;
                        end
                        moveLEFT:
                        begin
                            accelerationA <= 0;
                            accelerationB <= 0 ; 
                            rAccelerationReady <= 1;
                            rMotorStop <= 1;
                            rActionCount <= 1_000_000
                            rStateCount<= 0;
                        end
                        moveSTRAIGHT:
                        begin
                            accelerationA <= 0;
                            accelerationB <= 0 ; 
                            rAccelerationReady <= 1;
                            rMotorStop <= 1;
                            rActionCount <= 1_000_000
                            rStateCount<= 0;
                        end
                        
                    endcase
                end  

                FORWARD: 
                begin
                    accelerationA <= ACCELERATIONSPEED;
                    accelerationB <= DECELERATIONSPEED ; 
                    rAccelerationReady <= 1;
                    rActionCount <= 1_000_000
                    rStateCount<= 0;
                end

                LEFT: 
                begin
                    accelerationA <= ACCELERATIONSPEED;
                    accelerationB <= DECELERATIONSPEED ; 
                    rAccelerationReady <= 1;
                    rActionCount <= 1_000_000
                    rStateCount<= 0;
                end  

                RIGHT: 
                begin
                    accelerationA <= ACCELERATIONSPEED;
                    accelerationB <= DECELERATIONSPEED ; 
                    rAccelerationReady <= 1;
                    rActionCount <= 1_000_000
                    rStateCount<= 0;
                end  

                BACKWARD: 
                begin
                    accelerationA <= ACCELERATIONSPEED;
                    accelerationB <= DECELERATIONSPEED ; 
                    rAccelerationReady <= 1;
                    rActionCount <= 1_000_000
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
