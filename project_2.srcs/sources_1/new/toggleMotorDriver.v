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
    input wire sw0, sw1, sw2, sw3, clk,
    output wire ENA, ENB, IN1, IN2, IN3, IN4, LED0, LED1, LED2, LED3,
    
    input wire lSensor, mSensor, rSensor,
    output wire LED15, LED14, LED13
    );
    parameter dutyA = 8'd200; //domain 0-255, 127 is 50% duty cycle
    parameter dutyB = 8'd200;
    
    reg rENA, rENB, rIN1, rIN2, rIN3, rIN4, rLED0, rLED1, rLED2, rLED3;
    
    wire A, B;
    
    
    assign ENA = (rENA==1);
    assign ENB = (rENB==1);
    assign IN1 = (rIN1==1);
    assign IN2 = (rIN2==1);
    assign IN3 = (rIN3==1); 
    assign IN4 = (rIN4==1); 
    assign LED0 = (rLED0==1);
    assign LED1 = (rLED1==1);
    assign LED2 = (rLED2==1);
    assign LED3 = (rLED3==1); 
    
   assign LED15 = (lSensor==0);
   assign LED14 = (mSensor==0);
   assign LED13 = (rSensor==0);
    
    always@(posedge clk)
        begin
        if(sw0)  begin 
            rLED0 <= 1;
            rIN1 <= 0;
            rIN2 <= 1; 
            end 
        else begin 
            rLED0 <= 0;
            rIN1 <= 1;
            rIN2 <= 0;
        end
        
        if(sw1)  begin 
            rLED1 <= 1;
            rIN3 <= 0;
            rIN4 <= 1; 
            end 
        else begin 
            rLED1 <= 0;
            rIN3 <= 1;
            rIN4 <= 0;
        end
        // Ternary Operator forms multiplexer for selection
        // (if true)? execute : else ;
        rENA <= (sw2)? A : 1'b0 ; //issue with the switches 11, 15, 1s
        rLED2 <= sw2;
        rENB <= (sw3)? A : 1'b0 ; //hardware setup note: controls driver ENA // controls left motor
        rLED3 <= sw3;
        end
    //instantiation of submodule PWM
    PWM PWM_A(clk, dutyA, A); 
  //  PWM PWM_B(clk, dutyB, B);
endmodule