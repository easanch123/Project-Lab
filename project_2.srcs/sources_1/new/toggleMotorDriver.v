`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/27/2020 12:06:52 PM
// Design Name: 
// Module Name: toggleMotorDriver
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

    //Note: On greenboard the ENA pairs with IN3, IN4
    //      On greenboard the ENB pairs with IN1, IN2

module toggleMotorDriver(
    input wire sw12, sw13, sw14, sw15, clk,
    output wire ENA, ENB, IN1, IN2, IN3, IN4, LED12, LED13, LED14, LED15
    );
    parameter dutyA = 8'd100; //domain 0-255, 127 is 50% duty cycle
    parameter dutyB = 8'd100;
    
    reg rENA, rENB, rIN1, rIN2, rIN3, rIN4, rLED12, rLED13, rLED14, rLED15;
    
    wire A, B;
    
    
    assign ENA = (rENA==1);
    assign ENB = (rENB==1);
    assign IN1 = (rIN1==1);
    assign IN2 = (rIN2==1);
    assign IN3 = (rIN3==1); 
    assign IN4 = (rIN4==1); 
    assign LED12 = (rLED12==1);
    assign LED13 = (rLED13==1);
    assign LED14 = (rLED14==1);
    assign LED15 = (rLED15==1); 
    
    always@(posedge clk)
        begin
        if(sw13)  begin 
            rLED13 <= 1;
            rIN1 <= 0;
            rIN2 <= 1; 
            end 
        else begin 
            rLED13 <= 0;
            rIN1 <= 1;
            rIN2 <= 0;
        end
        
        if(sw14)  begin 
            rLED14 <= 1;
            rIN3 <= 0;
            rIN4 <= 1; 
            end 
        else begin 
            rLED14 <= 0;
            rIN3 <= 1;
            rIN4 <= 0;
        end
        // Ternary Operator forms multiplexer for selection
        // (if true)? execute : else ;
        rENA <= (sw15)? A : 1'b0 ; //issue with the switches 11, 15, 1s
        rLED15 <= sw15;
        rENB <= (sw12)? A : 1'b0 ; //hardware setup note: controls driver ENA
        rLED12 <= sw12;
        end
    //instantiation of submodule PWM
    PWM PWM_A(clk, dutyA, A); 
  //  PWM PWM_B(clk, dutyB, B);
endmodule