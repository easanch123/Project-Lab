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
    input wire [3:0] state,
    input wire [1:0] speedState,
    output wire ENA, ENB, IN1, IN2, IN3, IN4
    
    );
    
    wire A; // this is the right motor
    wire B; // this is the left motor
    
    parameter dutyA = 8'd150; 
    parameter dutyB = 8'd150;
    
    reg rENA, rENB, rIN1, rIN2, rIN3, rIN4;
    
    localparam FORWARD = 4'd02 ;
    localparam LEFT = 4'd04 ;
    localparam RIGHT = 4'd06 ;
    localparam BACKWARD = 4'd08 ;
    localparam SURVIVAL = 4'd00 ; 
    
    PWM PWM_A(clk, dutyA, A);
    PWM PWM_B(clk, dutyB, B);

    wire [7:0] survivalDutyA ; 
    wire [7:0] survivalDutyB ;

    wire survivalA, survivalB;

    survivalState survivalInputs (      .clk(clk), 
                                        .survivalA(survivalDutyA),
                                        .survivalB(survivalDutyB), 
                                        .state(state), 
                                        .speedState(speedState)
    ); 

    PWM PWM_A_SURV(clk, survivalDutyA, survivalA );
    PWM PWM_B_SURV(clk, survivalDutyB, survivalB );
    
    assign ENA = (rENA==1);
    assign ENB = (rENB==1);
    assign IN1 = (rIN1==1);
    assign IN2 = (rIN2==1);
    assign IN3 = (rIN3==1); 
    assign IN4 = (rIN4==1); 
    
    always@(posedge clk) 
    begin
        case(state)
        FORWARD:
            begin
            rENA <=  A ; // turn on motor
            rENB <=  B  ;  // turn on motor
            
            rIN1 <= 1; // orient motor A so that it moves forward
            rIN2 <= 0; // orient motor A so that it moves forward 
            
            rIN3 <= 0;// orient motor B so that it moves forward 
            rIN4 <= 1; // orient motor B so that it moves forward 
            end
        LEFT:
            begin
            rENA <=  A ; // turn on motor
            rENB <=  B  ;  // turn on motor
            
            rIN1 <= 1; // orient motor A so that it moves backwards
            rIN2 <= 0; // orient motor A so that it moves backwards 
            
            rIN3 <= 1;// orient motor B so that it moves forward 
            rIN4 <= 0; // orient motor B so that it moves forward 
            end
        RIGHT: 
            begin
            rENA <= A ; // turn on motor
            rENB <=  B  ;  // turn on motor
            
            rIN1 <= 0; // orient motor A so that it moves forward
            rIN2 <= 1; // orient motor A so that it moves forward 
            
            rIN3 <= 0;// orient motor B so that it moves backward 
            rIN4 <= 1; // orient motor B so that it moves backward 
            end
        BACKWARD:
            begin
            rENA <= A ; // turn on motor
            rENB <=  B  ;  // turn on motor
            
            rIN1 <= 0; // orient motor A so that it moves backwards
            rIN2 <= 1; // orient motor A so that it moves backwards 
            
            rIN3 <= 1;// orient motor B so that it moves backwards 
            rIN4 <= 0; // orient motor B so that it moves backwards 
            end
        SURVIVAL:
            begin
            rENA <= survivalA ; // turn on motor
            rENB <=  survivalB  ;  // turn on motor

            rIN1 <= 1; // orient motor A so that it moves forward
            rIN2 <= 0; // orient motor A so that it moves forward 
            
            rIN3 <= 0;// orient motor B so that it moves forward 
            rIN4 <= 1; // orient motor B so that it moves forward 
            
            end
        default:
            begin
            rENA <= 0 ; // turn off motor
            rENB <=  0  ;  // turn off motor
            end
        endcase
        
    end

endmodule
