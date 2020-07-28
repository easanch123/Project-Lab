`timescale 1ns / 1ps
`default_nettype none

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2020 07:31:21 AM
// Design Name: 
// Module Name: setExecuteState
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


module setExecuteState(
    input wire clk,
    input wire [3:0] state,
    input wire [1:0] speedChange,
    output wire [7:0] dutyA,
    output wire [7:0] dutyB
    );

        localparam SURVIVAL = 4'b0000 ;

        localparam FORWARD = 2'd0 ;
        localparam LEFT = 2'd1 ;
        localparam RIGHT = 2'd2 ;
        localparam STOP = 2'd03 ;
        

        localparam MAXSPEED = 8'd160 ; 
        localparam MINSPEED = 8'd135 ; 
        localparam DECREASE_STEP = 8'd1;
        localparam INCREASE_STEP = 8'd1;
        
        wire clk5khz;
        
        newClk #(10000) clkNew (            .FPGAclk(clk), 
                                            .signal(clk5khz));

        reg [7:0] rDutyA;
        reg [7:0] rDutyB;
        
        reg [7:0] rMotorACounter;
        reg [7:0] rMotorBCounter;

        reg [7:0] stepR;
        reg [7:0] stepL;

        initial begin
            rDutyA = 8'd150 ;
            rDutyB = 8'd150 ; 
            rMotorACounter= 0;
            rMotorBCounter = 0;
            stepR = 0;
            stepL = 0;
        end

        assign dutyA = rDutyA;
        assign dutyB = rDutyB;

        always @ (posedge clk5khz)
        begin
            if (state==SURVIVAL)
            begin
                case(speedChange)

                    FORWARD :  
                    begin
                        stepR <= (rDutyA < MAXSPEED) ? (INCREASE_STEP) : (0);
                        stepL <= (rDutyB < MAXSPEED) ? (INCREASE_STEP) : (0);
                        
                        // rDutyA<= 8'd150 ;
                        // rDutyB <= 8'd150 ;
                    end

                    LEFT :  
                    begin
                    // rDutyA<= 8'd150 ;
                    // rDutyB <= 8'd150 ;
                        stepR <= (rDutyA < MAXSPEED) ? (INCREASE_STEP) : (0);
                        stepL <= (rDutyB > MINSPEED) ? (-DECREASE_STEP) : (0);
                    end

                    RIGHT :  
                    begin
                        // rDutyA<= 8'd150 ;
                        // rDutyB <= 8'd150 ;
                        stepR <= (rDutyA > MINSPEED) ? (-DECREASE_STEP) : (0) ;
                        stepL <= (rDutyB < MAXSPEED) ? (INCREASE_STEP) : (0) ;
                    end

                    STOP :  
                    begin
                        // rDutyA<= 8'd0 ;
                        // rDutyB <= 8'd0 ;
                        stepR <= (rDutyA > MINSPEED) ? (-DECREASE_STEP) : (0);
                        stepL <= (rDutyB > MINSPEED) ? (-DECREASE_STEP) : (0);
                    end

                endcase

                if (stepR > 0) 
                begin
                    rDutyA <= ( rDutyA > MAXSPEED) ? (MAXSPEED) : ( rDutyA + stepR ) ; 
                end else if (stepR < 0) 
                begin
                    rDutyA <= ( rDutyA < MINSPEED) ? (MINSPEED) : ( rDutyA + stepR ) ;
                end

                if (stepL > 0) 
                begin
                    rDutyB <= ( rDutyB > MAXSPEED) ? (MAXSPEED) : ( rDutyB + stepL ) ; 
                end else if (stepL < 0) 
                begin
                    rDutyB <= ( rDutyB < MINSPEED) ? (MINSPEED) : ( rDutyB + stepL ) ; 
                end
                
                
                
            end else begin
                rDutyA <= 8'd160 ; 
                rDutyB <= 8'd160;
            end
            
        end









endmodule
