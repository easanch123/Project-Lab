`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/27/2020 04:35:05 PM
// Design Name: 
// Module Name: PWM
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

// Pulse Width Modulation (PWM) Signal Generator
// ===========================================================================
// Simple module generates a PWM signal using a counter and a comparator. 8-bit
// counter counts positive edges of the clock until it passes the maximum, then
// alternates. The duty cycle in percentage is the duty given / max of the
// counter * 100. So for a duty cycle of 50%, the user would input 128 because
// 128/255*100 is roughly 50%.
// ===========================================================================
module PWM(
	input wire clk,
	input wire [9:0] duty,
	output wire PWM_output
);

     // 8-bit counter can count up to 255
	reg [31:0] count = 0;
	reg outputSignal; 
	
	localparam MAX = 2600;
	
	assign PWM_output = outputSignal;

	initial 
	begin
		outputSignal = 0;
	end

	always@(posedge clk)
	begin
		count <= count + 1;
		// If count is less than duty, then output is 1.
		// Otherwise, it's 0.
		outputSignal <= (count < duty);
		if (count==MAX) 
		begin
		   count<=0;
		end
	end
endmodule