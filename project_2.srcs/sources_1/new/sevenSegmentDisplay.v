`timescale 1ns / 1ps
`default_nettype none

module sevenSegmentDisplay(
    input wire clk,
    input wire [3:0] currentState,  // The 4 inputs for each display
    input wire stateReady,

    output wire [6:0] seg, // 7 segment display
    output wire dp, // Decimal point on the 7 segment display 
    output wire [3:0] anode // Anode for the 7 segment display
 
 );
    
    localparam N = 18;
    
    reg [3:0] rAnode; 
    reg [6:0] rSeg;
    reg [N-1:0] COUNTER ;

    assign anode = rAnode;
    assign seg = {rSeg[6], rSeg[5], rSeg[4], rSeg[3], rSeg[2], rSeg[1], rSeg[0]} ;
    assign dp = 1'b1 ; // Since the decimal point is not needed, all 4 of them are turned off

    initial begin
      rAnode = 0;
      rSeg = 0;
      COUNTER = 0;
    end

    always @ (posedge clk) begin
      COUNTER <= COUNTER + 1;

      // Set the anode register which will update the anode output
      case  ( COUNTER[N-1:N-2]) // Using only the 2 MSB's of the counter 
      
        2'b00 :  rAnode <= 4'b1110;  // When the 2 MSB's are 00 enable the fourth display
        2'b01 :  rAnode <= 4'b1101;  // When the 2 MSB's are 01 enable the third display
        2'b10 :  rAnode <= 4'b1011;  // When the 2 MSB's are 10 enable the second display        
        2'b11 :  rAnode <= 4'b0111;  // When the 2 MSB's are 11 enable the first display

      endcase

      // Given the current state, update the segment register
      case (currentState)

        4'd0 : rSeg <= 7'b1000000; // To display 0
        4'd1 : rSeg <= 7'b1111001; // To display 1
        4'd2 : rSeg <= 7'b0100100; // To display 2
        4'd3 : rSeg <= 7'b0110000; // To display 3
        4'd4 : rSeg <= 7'b0011001; // To display 4
        4'd5 : rSeg <= 7'b0010010; // To display 5
        4'd6 : rSeg <= 7'b0000010; // To display 6
        4'd7 : rSeg <= 7'b1111000; // To display 7
        4'd8 : rSeg <= 7'b0000000; // To display 8
        4'd9 : rSeg <= 7'b0010000; // To display 9
        default : rSeg <= 7'b0111111; //dash

      endcase
    end    

endmodule
