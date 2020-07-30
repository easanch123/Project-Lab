`timescale 1ns / 1ps
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
    input wire accelerationA,
    input wire accelerationB,
    input wire accelerationReady,
    input wire motorStop,
    output wire ENA, ENB, IN1, IN2, IN3, IN4
    );

    localparam FORWARD = 4'd02 ;
    localparam LEFT = 4'd04 ;
    localparam RIGHT = 4'd06 ;
    localparam BACKWARD = 4'd08 ;
    localparam SURVIVAL = 4'd00 ; 
    
    localparam survivalFORWARD = 2'd0 ;
    localparam survivalRIGHT= 2'd1 ;
    localparam survivalLEFT = 2'd2 ;
    localparam survivalSTOP = 2'd03 ;
    
    localparam MAXSPEED = 200;

    wire A; // this is the right motor
    wire B; // this is the left motor
    
    reg rENA, rENB, rIN1, rIN2, rIN3, rIN4;

    reg [7:0] rVelocityA;
    reg [7:0] rVelocityB;
    reg [7:0] rAccelerationA;
    reg [7:0] rAccelerationB; 

    wire [7:0] dutyA;
    wire [7:0] dutyB;

    PWM PWM_A(clk, dutyA, A);
    PWM PWM_B(clk, dutyB, B);
    
    assign ENA = (rENA==1);
    assign ENB = (rENB==1);
    assign IN1 = (rIN1==1);
    assign IN2 = (rIN2==1);
    assign IN3 = (rIN3==1); 
    assign IN4 = (rIN4==1); 

    assign dutyA = (rVelocityA>=0) ? (rVelocityA) : (-rVelocityA);
    assign dutyB = (rVelocityB>=0) ? (rVelocityB) : (-rVelocityB);
    
    always@(posedge clk) 
    begin
        
        if (motorStop) 
        begin
            if (rVelocityA < 0) 
            begin
                rIN1 <= 1;
                rIN2 <= 0;
                if (rVelocityA > -MAXSPEED)
                begin
                    rVelocityA <= rVelocityA + accelerationA;
                end
            end else begin
                rIN1 <= 0;
                rIN2 <= 1;
                if (rVelocityA < MAXSPEED)
                begin
                    rVelocityA <= rVelocityA + accelerationA;
                end
            end

            if (rVelocityB < 0) 
            begin
                rIN3 <= 1;
                rIN4 <= 0;
                if (rVelocityB > -MAXSPEED)
                begin
                    rVelocityB <= rVelocityB + accelerationB;
                end
            end else begin
                rIN3 <= 0;
                rIN4 <= 1;
                if (rVelocityB < MAXSPEED)
                begin
                    rVelocityB <= rVelocityB + accelerationB;
                end
            end
        end else begin
            rVelocityB = 0 ;
            rVelocityA = 0 ;
        end
        

        if (accelerationReady)
        begin
            rAccelerationA <= accelerationA;
            rAccelerationB <= accelerationB;
        end

        rENA <= A;
        rENB <= B;
        
    end

endmodule
