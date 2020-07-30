`timescale 1ns / 1ps
`default_nettype none

module stateEncoder(

        input wire clk100khz,
        input wire [11:0] remoteReading,
        input wire ready,

        output wire [3:0] remoteInputs,
        output wire remoteReady

    );

    reg [3:0] rIRInput;
    reg rIRInputReady;
    
    // 

    initial begin
    rIRInput = 0;
    rIRInputReady = 0;
    end
    
    assign remoteReady = rIRInputReady;
    assign remoteInputs = rIRInput;
 
    always @(posedge clk100khz)
    begin
        if (ready) 
        begin
            begin
                case (remoteReading)
                12'b111111101111 : rIRInput <= 4'b0001; //1        
                12'b011111101111 : rIRInput <= 4'b0010; //2
                12'b101111101111 : rIRInput <= 4'b0011; //3
                12'b001111101111 : rIRInput <= 4'b0100; //4
                12'b110111101111 : rIRInput <= 4'b0101; //5
                12'b010111101111 : rIRInput <= 4'b0110; //6
                12'b100111101111 : rIRInput <= 4'b0111; //7
                12'b000111101111 : rIRInput <= 4'b1000; //8
                12'b111011101111 : rIRInput <= 4'b1001; //9
                12'b011011101111 : rIRInput <= 4'b0000; //0
                endcase
                rIRInputReady <= 1; // output bit that tells us that the ir input has now changed
            end
        end else begin
            if (rIRInputReady) begin
                rIRInputReady <= 0;
            end
        end
     end
            
endmodule
