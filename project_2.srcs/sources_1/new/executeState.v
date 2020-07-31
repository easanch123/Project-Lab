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
    
    input wire [2:0] metalInputs,
    input wire distanceInput,
    input wire stallInput,

    output wire [2:0] accelerationA,
    output wire [2:0] accelerationB,
    output wire accelerationReady 
    
    );
   
    // User-Input States
    localparam FORWARD = 4'd02 ;
    localparam STOP = 4'd05 ; 
    localparam LEFT = 4'd04 ;
    localparam RIGHT = 4'd06 ;
    localparam BACKWARD = 4'd01 ;
    localparam SURVIVAL = 4'd0 ;
    localparam TRACKING = 4'd3;
    

    localparam survivalRIGHT = 0;
    localparam survivalLEFT = 1;
    localparam survivalSTRAIGHT = 2;
    localparam survivalSTOP = 3;

    localparam ACCELERATIONSPEED = 1;
    localparam DECELERATIONSPEED = -1;
    

    reg rAccelerationReady;
    reg [2:0] rAccelerationA;
    reg [2:0] rAccelerationB;

    reg rMotorStop;

    reg [32:0] rStateCount;
    reg [1:0] rSensorDecision; 
    reg [32:0] rActionCount;

    assign motorReady = ~rAccelerationReady;
    assign motorStop = rMotorStop;
    
    assign accelerationA = rAccelerationA;
    assign accelerationB = rAccelerationB;

    
   
    initial 
    begin
        rAccelerationReady = 0;
        rMotorStop = 0;
    end
    
    // the point of this module is to be given a state and then to give the outputs for the motor

    always @ (posedge clk)
    begin
        if (~rMotorStop) 
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
                end 
            end else begin
                rSensorDecision <= survivalSTOP;
            end
        end
    end


    always @ (posedge clk) 
    begin

        if (stateReady && ~rAccelerationReady) begin
            case (state)
            
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
                            rAccelerationB <= DECELERATIONSPEED ; 
                            rAccelerationReady <= 1;
                            rActionCount <= 1_500_000;
                            rStateCount<= 0;
                            rMotorStop <= 0;
                        end
                        survivalLEFT:
                        begin
                            rAccelerationA <= DECELERATIONSPEED ;
                            rAccelerationB <= ACCELERATIONSPEED ; 
                            rAccelerationReady <= 1;
                            rMotorStop <= 0;
                            rActionCount <= 1_000_000;
                            rStateCount<= 0;
                        end
                        survivalSTRAIGHT:
                        begin
                            rAccelerationA <= ACCELERATIONSPEED ;
                            rAccelerationB <= ACCELERATIONSPEED ; 
                            rAccelerationReady <= 1;
                            rMotorStop <= 0;
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
                    rAccelerationB <= ACCELERATIONSPEED ; 
                    rAccelerationReady <= 1;
                    rActionCount <= 1_000_000;
                    rStateCount<= 0;
                    rMotorStop <= 0;
                end

                LEFT: 
                begin
                    rAccelerationA <= DECELERATIONSPEED;
                    rAccelerationB <= ACCELERATIONSPEED ; 
                    rAccelerationReady <= 1;
                    rActionCount <= 1_000_000;
                    rStateCount<= 0;
                    rMotorStop <= 0;
                end  

                RIGHT: 
                begin
                    rAccelerationA <= ACCELERATIONSPEED;
                    rAccelerationB <= DECELERATIONSPEED ; 
                    rAccelerationReady <= 1;
                    rActionCount <= 1_000_000;
                    rStateCount<= 0;
                    rMotorStop <= 0;
                end  

                BACKWARD: 
                begin
                    rAccelerationA <= DECELERATIONSPEED;
                    rAccelerationB <= DECELERATIONSPEED ; 
                    rAccelerationReady <= 1;
                    rActionCount <= 1_000_000;
                    rStateCount<= 0;
                    rMotorStop <= 0;
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
