`timescale 1ns / 1ps
`default_nettype none

module inverter(

   input wire clk100khz,
   input wire inputSignal,
   output wire invertedInput

    );

   reg rInvertedInput;

   always @ (posedge clk100khz)
   begin
      rInvertedInput <= ~inputSignal;
   end

   assign invertedInput = rInvertedInput;

endmodule
