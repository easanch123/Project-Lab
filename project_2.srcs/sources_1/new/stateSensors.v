`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/27/2020 04:38:53 PM
// Design Name: 
// Module Name: stateSensors
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

module stateSensors(
       input wire clk,
       input wire L, M, R, // left middle and right sensor
       
       output wire enable,
       output wire [1:0] sensorState,
       output wire motorEnable,
       output wire velocity
    );
    
    reg rL,rM,rR;
    
    reg en;
    
    reg v; // velocity, 0 slow, 1 fast
    reg motorEn; // enable for motor, 0 stop, 1 go
    reg t; // turn, 0 forward, 1 turn
    reg d; // direction, 0 left, 1 right
    
    always @ (posedge clk) begin
    if ({rL,rM,rR}!={L,M,R}) begin
        en<=1;
        {rL,rM,rR} <= {L,M,R};
    end
    
    v <= (!rL && rM && !rR) ? (1) : (0); // logcal negation and AND statements
    motorEn <= (rL^rM^rR) ? (1) : (0) ; // xor function
    t <= (rL && !rM && !rR || !rL && !rM && rR) ? (1) : (0) ;
    d <= (rL && !rM && !rR) ? (1) : (0); 
    
    if (en==1) begin
        en <= 0;
    end
    
    end
    
    initial begin 
    {rL,rM,rR} = {1'b0,1'b0,1'b0};
    {v,motorEn,t,d} = {1'b0,1'b0,1'b0,1'b0};
    en = 0;
    end
    
    assign enable = en;
    assign velocity = v;
    assign sensorState = {t, d}; 
    assign motorEnable = motorEn;
    
endmodule
