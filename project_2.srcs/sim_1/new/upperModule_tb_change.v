`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/19/2020 01:27:59 PM
// Design Name: 
// Module Name: upperModule_tb_change
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


module upperModule_tb_change(

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
    
    reg [7:0] changeCounter;
    wire changeClk;
    reg changeClkOut;
    
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
    
    changeCounter = 0;
    changeClkOut = 0;
    end
    
    newClk #(1953) clkNew (.FPGAclk(inp_clk), .signal(clk25khz));
    newClk #(29402) clkNews (.FPGAclk(inp_clk), .signal(changeClk));
    
    always @(posedge changeClk) begin
    
    changeCounter <= changeCounter + 1;
    
    if (changeCounter==30) begin
        switches<= switches + 20;
    end
    
    if (changeCounter==60) begin
    switches<= switches - 50;
    end
    
    if (changeCounter==90) begin
    switches<= switches - 50;
    end
    
    if (changeCounter==120) begin
    switches<= switches + 200;
    end
    
    if (changeCounter==150) begin
    switches<= 0;
    changeCounter<=0;
    end
    
    end
    
    
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

