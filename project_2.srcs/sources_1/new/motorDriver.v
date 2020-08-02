`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/27/2020 04:28:26 PM
// Design Name: 
// Module Name: executeState
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


module motorDriver(
    input wire clk,
    input wire signed [15:0] accelerationA,
    input wire signed [15:0] accelerationB,
    input wire accelerationReady,
    input wire survivalMode,
    input wire motorStop,
    input wire [3:0] state,
    input wire isTurn,
    
    output wire ENA, ENB, IN1, IN2, IN3, IN4
    );

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
    
    localparam fastPWM = 200;
    
    localparam MAXSPEED = 400;

    wire A; // this is the right motor
    wire B; // this is the left motor
    
   wire A_fast;
   wire B_fast;
    
    reg rENA, rENB, rIN1, rIN2, rIN3, rIN4;

    wire [9:0] dutyA;
    wire [9:0] dutyB;
    
    reg signed [31:0] rVelocityA;    
    reg signed [31:0] rVelocityB;     
    
    reg signed [15:0] rAccelerationA; 
    reg signed [15:0] rAccelerationB; 

    reg unsigned [9:0] rDutyA;
    reg unsigned [9:0] rDutyB;
    
    
    PWM PWM_A(clk, dutyA, A);
    PWM PWM_B(clk, dutyB, B);
    
   pwm_fast fastPWM_A (clk, fastPWM, A_fast);
   pwm_fast fastPWM_B (clk, fastPWM, B_fast);
    
    
    assign ENA = (isTurn) ? (A_fast) : (A);
    assign ENB = (isTurn) ? (B_fast) : (B);
    assign IN1 = rIN1;
    assign IN2 = rIN2;
    assign IN3 = rIN3; 
    assign IN4 = rIN4; 

    assign dutyA = rDutyA;
    assign dutyB = rDutyB;

    initial
    begin
        rVelocityA = 0;
        rVelocityB = 0;
        rAccelerationA = 0;
        rAccelerationB = 0;
        rENA = 0; 
        rENB = 0 ;
        rIN1 = 0;
        rIN2 = 1;
        rIN3 = 0;
        rIN4 = 1;
    end
    
    always @ (posedge clk) 
    begin
        
        if (accelerationReady)
        begin

            if (rAccelerationA!=accelerationA) 
            begin
                rAccelerationA <= accelerationA;
            end
            
            if (rAccelerationB!=accelerationB) 
            begin
                rAccelerationB <= accelerationB;
            end
        end
        
        if (~motorStop)
        begin
        if (rVelocityA>=0)
            begin
                rIN1<=1;
                rIN2<=0; 
                if (rAccelerationA<0)
                begin
                    rVelocityA <= rVelocityA+rAccelerationA;
                end else if (rVelocityA < MAXSPEED) begin
                    rVelocityA <= rVelocityA+rAccelerationA;
                end
                rDutyA <= rVelocityA;
            end else begin
                rIN1<=0;
                rIN2<=1;
                if (rAccelerationA>0)
                begin
                    rVelocityA <= rVelocityA+rAccelerationA;
                end else if (-rVelocityA < MAXSPEED) begin
                    rVelocityA <= rVelocityA+rAccelerationA;
                end
                rDutyA <= -rVelocityA ;
            end
            
            if (rVelocityB>=0)
            begin
                rIN3<=0;
                rIN4<=1;
                if (rAccelerationB<0)
                begin
                    rVelocityB <= rVelocityB+rAccelerationB;
                end else if (rVelocityB < MAXSPEED) begin
                    rVelocityB <= rVelocityB+rAccelerationB;
                end
                rDutyB <= rVelocityB;
            end else begin
                rIN3<=1;
                rIN4<=0;
                rDutyB <= -rVelocityB;
                if (rAccelerationB>0)
                begin
                    rVelocityB <= rVelocityB+rAccelerationB;
                end else if (-rVelocityB < MAXSPEED) begin
                    rVelocityB <= rVelocityB+rAccelerationB;
                end
        end

    end

            
        if (motorStop)
        begin
            rVelocityA <= 0;
            rAccelerationA<=0;
            rDutyB<=0;
            rDutyA<=0;
            rVelocityB <= 0;
            rAccelerationB<=0;
        end
        
    
   end

endmodule