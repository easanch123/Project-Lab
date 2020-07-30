`timescale 1ns / 1ps
`default_nettype none

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/20/2020 09:25:56 PM
// Design Name: 
// Module Name: setSpeedState
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


module setSpeedState(

    input wire clk,
    input wire [2:0] sensorInput,
    input wire distanceSensor,
    input wire [3:0] state,
    input wire stateReady,

    output wire survivalActivated, // tells us if we are currently in survival mode. 
    output wire [3:0] stateOut

    );

    reg [1:0] rSpeedChange;
    reg rSurvivalActivate;
    reg rSurvivalStop;
    
    localparam FORWARD = 4'd02 ;
    localparam STOP = 4'd03 ;
    localparam LEFT = 4'd04 ;
    localparam RIGHT = 4'd06 ;
    localparam BACKWARD = 4'd08 ;
    localparam SURVIVAL = 4'd00 ; 
    localparam OFF_SURVIVAL = 4'd01 ;
    
    localparam ACCELERATION_INCREASE = 1;
    localparam ACCELERATION_DECREASE = -1;
    
    reg [7:0] rAccelerationMotorA; 
    reg [7:0] rAccelerationMotorB;
    reg rRemoteStop;
    
    assign speedChange = rSpeedChange;
    
    initial begin
    rSpeedChange = 0;
    rSurvivalActivate = 0;
    rSurvivalStop = 0;
    rAccelerationMotorA = 0;
    rAccelerationMotorB = 0;
    rRemoteStop=0;
    end
    

    always @ (posedge clk)
    begin
    
        if (stateReady)  // when the state is flipped this means that we need to check if we are in survival mode or if we are activating survival mode. Or else we just ignore this module.
        begin
            if (rSurvivalActivate) // if Survival is currently activated
            begin
                case (state)

                    OFF_SURVIVAL: 
                    begin
                        rSurvivalActivate <= 0 ; 
                        rAccelerationMotorA <= 0 ;
                        rAccelerationMotorB <= 0 ;
                    end 

                    FORWARD: 
                    begin
                        if (rRemoteStop && ~distanceSensor) begin
                            rRemoteStop <= 0 ;
                        end
                        rAccelerationMotorA <= rAccelerationMotorA + ACCELERATION_INCREASE  ; 
                        rAccelerationMotorB <= rAccelerationMotorB + ACCELERATION_INCREASE  ; 
                    end

                    LEFT: 
                    begin
                        if (rRemoteStop && ~distanceSensor) begin
                            rRemoteStop <= 0 ;
                        end
                        rAccelerationMotorA <= rAccelerationMotorA + ACCELERATION_INCREASE  ; 
                        rAccelerationMotorB <= rAccelerationMotorB + ACCELERATION_DECREASE  ; 
                    end  

                    RIGHT: 
                    begin
                        if (rRemoteStop && ~distanceSensor) begin
                            rRemoteStop <= 0 ;
                        end
                        rAccelerationMotorA <= rAccelerationMotorA + ACCELERATION_DECREASE  ; 
                        rAccelerationMotorB <= rAccelerationMotorB + ACCELERATION_INCREASE  ; 
                    end  

                    BACKWARD: 
                    begin
                        if (rRemoteStop) begin
                            rRemoteStop <= 0 ;
                        end
                        rAccelerationMotorA <= rAccelerationMotorA + ACCELERATION_DECREASE  ; 
                        rAccelerationMotorB <= rAccelerationMotorB + ACCELERATION_INCREASE  ;  
                    end    

                    STOP: 
                    begin
                        rAccelerationMotorA <= 0  ; 
                        rAccelerationMotorB <= 0  ;  
                        rRemoteStop = 1 ;
                    end  

                    SURVIVAL: 
                    begin
                        if (rRemoteStop && ~distanceSensor) begin
                            rRemoteStop <= 0 ;
                        end
                        rSurvivalActivate <= 1 ;
                    end  

                endcase
            end   
        end
    end
endmodule
