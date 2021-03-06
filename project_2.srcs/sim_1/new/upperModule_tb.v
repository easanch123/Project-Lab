`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Company: Texas Tech University 
// Engineer: Edward Sanchez
// 
// Create Date: 06/12/2020 08:51:59 AM
// Design Name: Square Pulse
// Module Name: upperModule_tb
// Project Name: Project Lab Mini Project
// Target Devices: FPGA Basys3
// 
//////////////////////////////////////////////////////////////////////////////////
module upperModule_tb(
    );

    wire signal_square_100hz;
    wire clk25khz;
    reg simclk;
    wire inp_clk;
    reg [7:0] switches;
    wire switchWire;
    
    reg [7:0] counter;
    reg [7:0] countCeiling;
    reg squarePulse;
    reg rst;
    
    always begin

    #5 
    simclk = ~simclk;
    
    end
    
    assign inp_clk = (simclk==1'b1);
    
    initial begin 
    simclk = 1'b0;
    switches = 8'b10000000;
    
    squarePulse = 1'd0;
    counter = 8'd0;
    countCeiling = 8'b10000000;
    rst = 1'd1;
    end
    
    newClk #(1961) clkNew (.FPGAclk(inp_clk), .signal(clk25khz));
    
    always @(posedge clk25khz)
    begin
    
    if (switches!=countCeiling && rst!=1'b1) begin
        rst <= 1'b1;
        squarePulse <= 1'd0;
        countCeiling<=switches;
    end
    
    if (rst!=1'd1) begin
    
        squarePulse <= (counter==countCeiling && counter!=8'd255) ? (1'd0) : (squarePulse);
        
        if (counter==8'd255) begin
            counter <= 8'd0;
            squarePulse <= (countCeiling!=1'd0) ? (1'd1) : (1'd0);
        end else begin
            counter <= counter + 1;
        end
    end else begin
        
        counter <= 8'd0;
        squarePulse <= 1'd1;
        rst <= 1'd0;
        countCeiling<=switches;
        
    end
    end 
   
   
endmodule
