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
    output wire [2:0] state
    );
    
    wire ENA, ENB, IN1, IN2, IN3, IN4;
    
    parameter dutyA = 8'd255; //domain 0-255, 127 is 50% duty cycle 
   // parameter dutyB = 8'd255; // if we want to use B in a different speed then activate this.
    
    reg rENA, rENB, rIN1, rIN2, rIN3, rIN4;
    
    wire A, B; // A is left and B is right 
    
    assign ENA = (rENA==1);
    assign ENB = (rENB==1);
    assign IN1 = (rIN1==1);
    assign IN2 = (rIN2==1);
    assign IN3 = (rIN3==1); 
    assign IN4 = (rIN4==1); 
    
    //instantiation of submodule PWM
    PWM PWM_A(clk, dutyA, A); 
    //PWM PWM_B(clk, dutyB, B);
    
    always@(posedge clk)
        begin
        if (state==3'b000) begin // forward
            rENA <= A ; // turn on motor
            rENB <=  A  ;  // turn on motor
            
            rIN1 <= 0; // orient motor A so that it moves forward
            rIN2 <= 1; // orient motor A so that it moves forward 
            
            rIN3 <= 0;// orient motor B so that it moves forward 
            rIN4 <= 1; // orient motor B so that it moves forward 
            
        end else if (state===3'b001) begin  // left
            rENA <= A ; // turn on motor
            rENB <=  A  ;  // turn on motor
            
            rIN1 <= 1; // orient motor A so that it moves backwards
            rIN2 <= 0; // orient motor A so that it moves backwards 
            
            rIN3 <= 0;// orient motor B so that it moves forward 
            rIN4 <= 1; // orient motor B so that it moves forward 
            
        end else if (state===3'b010) begin  // right
            rENA <= A ; // turn on motor
            rENB <=  A  ;  // turn on motor
            
            rIN1 <= 0; // orient motor A so that it moves forward
            rIN2 <= 1; // orient motor A so that it moves forward 
            
            rIN3 <= 1;// orient motor B so that it moves backward 
            rIN4 <= 0; // orient motor B so that it moves backward 
            
        end else if (state===3'b011) begin // back
            rENA <= A ; // turn on motor
            rENB <=  A  ;  // turn on motor
            
            rIN1 <= 1; // orient motor A so that it moves backwards
            rIN2 <= 0; // orient motor A so that it moves backwards 
            
            rIN3 <= 1;// orient motor B so that it moves backwards 
            rIN4 <= 0; // orient motor B so that it moves backwards 
            
        end else if (state===3'b100) begin  // stop
        
            rENA <= 0 ; // turn off motor
            rENB <=  0  ;  // turn off motor
        end
        
    end

endmodule
