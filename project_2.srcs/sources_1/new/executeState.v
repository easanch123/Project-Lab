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
    
    output wire motorStop,
    output wire motorReady,
    output wire signed [15:0] accelerationA,
    output wire signed [15:0] accelerationB,
    output wire accelerationReady,
    output wire isTurn
    
    );
   
    // User-Input States
    // User-Input States
    localparam FORWARD = 4'd02 ;
    localparam STOP = 4'd05 ; 
    localparam LEFT = 4'd04 ;
    localparam RIGHT = 4'd06 ;
    localparam BACKWARD = 4'd08 ;
    localparam SURVIVAL = 4'd0 ;
    localparam TRACKING = 4'd3;
    
    localparam FORWARD_sensor = 4'd03;
    localparam LEFT_sensor  = 4'd07 ; 
    localparam RIGHT_sensor  = 4'd09 ; 
    
    localparam ACCELERATIONSPEED = 1;
    localparam DECELERATIONSPEED = -1;
    
    localparam FASTSPEED_ACCEL = 15;
    localparam FASTSPEED_DECCEL = -15;
    
//    localparam WAIT_VALUE = 100 ;
//    localparam WAIT_SURVIVAL = 100_000 ;
    
    localparam WAIT_VALUE = 1 ;
    localparam WAIT_SURVIVAL = 1 ;
    
    reg rAccelerationReady;
    reg signed [15:0] rAccelerationA;
    reg signed [15:0] rAccelerationB;

    reg [31:0] rStateCount;
    reg [31:0] rActionCount;
    
    reg rMotorStop;
    reg rIsTurn;

    assign motorStop = rMotorStop;
    assign motorReady = ~rAccelerationReady;

    assign accelerationA = rAccelerationA;
    assign accelerationB = rAccelerationB;
    assign accelerationReady = rAccelerationReady;
    assign isTurn = rIsTurn;
 
    initial 
    begin
        rAccelerationReady = 0;
        rAccelerationA = 0;
        rAccelerationB = 0;
        rStateCount = 0;
        rActionCount = 0;
        rMotorStop = 1;
        rIsTurn = 0;
    end

    always @ (posedge clk) 
    begin

        if (stateReady)
            begin
            if (~rAccelerationReady) 
            begin
                case (state)
                    FORWARD_sensor:
                    begin
                        rAccelerationA <= ACCELERATIONSPEED;
                        rAccelerationB <= ACCELERATIONSPEED ; 
                        rAccelerationReady <= 1;
                        rActionCount <= WAIT_VALUE;
                        rStateCount<= 0;
                        rMotorStop<=0;
                        rIsTurn<= 0;
                    end
                    LEFT_sensor:
                    begin
                        rAccelerationA <=  FASTSPEED_ACCEL  ;
                        rAccelerationB <= FASTSPEED_DECCEL ; 
                        rAccelerationReady <= 1;
                        rActionCount <= WAIT_VALUE;
                        rStateCount<= 0;
                        rMotorStop<=0;
                        rIsTurn<= 1;
                    end
                    RIGHT_sensor:
                    begin
                        rAccelerationA <= FASTSPEED_DECCEL ;
                        rAccelerationB <= FASTSPEED_ACCEL  ; 
                        rAccelerationReady <= 1;
                        rActionCount <= WAIT_VALUE;
                        rStateCount<= 0;
                        rMotorStop<=0;
                        rIsTurn<= 1;
                    end
                    
                    STOP: 
                    begin
                        rAccelerationA <= 0;
                        rAccelerationB <= 0 ; 
                        rAccelerationReady <= 1;
                        rActionCount <= WAIT_SURVIVAL;
                        rStateCount<= 0;
                        rMotorStop<=1;
                        rIsTurn<= 0;
                    end  
    
                    FORWARD: 
                    begin
                        rAccelerationA <= ACCELERATIONSPEED;
                        rAccelerationB <= ACCELERATIONSPEED ; 
                        rAccelerationReady <= 1;
                        rActionCount <= WAIT_SURVIVAL;
                        rStateCount<= 0;
                        rMotorStop<=0;
                        rIsTurn<= 0;
                    end
    
                    LEFT: 
                    begin
                        rAccelerationA <=  ACCELERATIONSPEED  ;
                        rAccelerationB <= DECELERATIONSPEED ; 
                        rAccelerationReady <= 1;
                        rActionCount <= WAIT_SURVIVAL;
                        rStateCount<= 0;
                        rMotorStop<=0;
                        rIsTurn<= 1;
                    end  
    
                    RIGHT: 
                    begin
                        rAccelerationA <= DECELERATIONSPEED ;
                        rAccelerationB <= ACCELERATIONSPEED  ; 
                        rAccelerationReady <= 1;
                        rActionCount <= WAIT_SURVIVAL;
                        rStateCount<= 0;
                        rMotorStop<=0;
                        rIsTurn<= 1;
                    end  
    
                    BACKWARD: 
                    begin
                        rAccelerationA <= DECELERATIONSPEED;
                        rAccelerationB <= DECELERATIONSPEED ; 
                        rAccelerationReady <= 1;
                        rActionCount <= WAIT_SURVIVAL;
                        rStateCount<= 0;
                        rMotorStop<=0;
                        rIsTurn<= 0;
                    end    
    
                    default:
                    begin
                        rAccelerationA <= 0;
                        rAccelerationB <= 0 ; 
                        rAccelerationReady <= 1;
                        rActionCount <= WAIT_SURVIVAL;
                        rStateCount<= 0;
                        rMotorStop<=1;
                    end
    
                endcase
            end
        end



        if (rAccelerationReady) 
        begin
            rStateCount <= rStateCount + 1;
        end

        if (rStateCount == rActionCount) begin
            rAccelerationReady <= 0;
        end

        

    end

    
endmodule
