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


module executeState(
    input wire clk,
    input wire [2:0] state,
    input wire enable,
    input wire velocity,
    input wire ENA, ENB, IN1, IN2, IN3, IN4
    );
    
    wire dutyA, dutyB;
    wire A;
    
    reg rENA, rENB, rIN1, rIN2, rIN3, rIN4;
    
    localparam SURVIVAL = 3'b001;
    localparam FORWARD = 3'b010;
    localparam STOP = 3'b011;
    localparam LEFT = 3'b100; 
    localparam RIGHT = 3'b101;
    localparam BACKWARD = 3'b110;
    
    PWM PWM_A(clk, dutyA, A);
    PWM PWM_B(clk, dutyB, A);
    
    assign ENA = (rENA==1);
    assign ENB = (rENB==1);
    assign IN1 = (rIN1==1);
    assign IN2 = (rIN2==1);
    assign IN3 = (rIN3==1); 
    assign IN4 = (rIN4==1); 
    
    always@(posedge clk) 
    begin
        if (enable==1) begin
            case(state)
            FORWARD:
                begin
                rENA <= A ; // turn on motor
                rENB <=  A  ;  // turn on motor
                
                rIN1 <= 0; // orient motor A so that it moves forward
                rIN2 <= 1; // orient motor A so that it moves forward 
                
                rIN3 <= 0;// orient motor B so that it moves forward 
                rIN4 <= 1; // orient motor B so that it moves forward 
                end
            LEFT:
                begin
                rENA <= A ; // turn on motor
                rENB <=  A  ;  // turn on motor
                
                rIN1 <= 1; // orient motor A so that it moves backwards
                rIN2 <= 0; // orient motor A so that it moves backwards 
                
                rIN3 <= 0;// orient motor B so that it moves forward 
                rIN4 <= 1; // orient motor B so that it moves forward 
                end
            RIGHT: 
                begin
                rENA <= A ; // turn on motor
                rENB <=  A  ;  // turn on motor
                
                rIN1 <= 0; // orient motor A so that it moves forward
                rIN2 <= 1; // orient motor A so that it moves forward 
                
                rIN3 <= 1;// orient motor B so that it moves backward 
                rIN4 <= 0; // orient motor B so that it moves backward 
                end
            BACKWARD:
                begin
                rENA <= A ; // turn on motor
                rENB <=  A  ;  // turn on motor
                
                rIN1 <= 1; // orient motor A so that it moves backwards
                rIN2 <= 0; // orient motor A so that it moves backwards 
                
                rIN3 <= 1;// orient motor B so that it moves backwards 
                rIN4 <= 0; // orient motor B so that it moves backwards 
                end
            STOP:
                begin
                rENA <= 0 ; // turn off motor
                rENB <=  0  ;  // turn off motor
                end
            endcase
        end
        
    end

endmodule
