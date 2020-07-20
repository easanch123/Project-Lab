`timescale 1ns / 1ps
`default_nettype none

module irSensor(

        input wire clk100khz,
        input wire irInput,
        output wire [11:0] remoteReading,
        output wire ready

    );
    
        localparam BIT_THRESHOLD =  100;
        localparam START_THRESHOLD = 200; 
        localparam END_THRESHOLD = 200;   

        reg [9:0] POS_COUNTER ; 
        reg [9:0] NEG_COUNTER ; 
        reg [4:0] LOCATION_COUNTER ;

        reg prevSignal ;
        reg curSignal ; 
        reg rReady;
        

        reg rst ; // when to start counting 

        reg [11:0] rRemoteReading ;

        wire beginCount;

        initial 
        begin
            POS_COUNTER = 10'd0;
            NEG_COUNTER = 10'd0;
            LOCATION_COUNTER = 5'd0;

            prevSignal = 0;
            curSignal = 0;
            rst = 0;
            rRemoteReading = 12'd0;
            rReady = 0;
            
        end

        assign remoteReading = rRemoteReading;
        assign beginCount = (prevSignal && ~curSignal);
        assign ready = rReady;

        always @(posedge clk100khz)
        begin

            if (ready) begin
                
                // If the ready signal is active, then we need to reset all counters, reset ready signal
                POS_COUNTER <= 0;
                NEG_COUNTER <= 0;
                LOCATION_COUNTER <= 0;

                rReady <= 0;

                curSignal <= irInput;

            end 
            else begin

                    // initialize prevSignal and curSignal for edge detection
            curSignal <= irInput;
            prevSignal <= curSignal;

            // Adjust the POS and NEG counters according to the current signal 
            if (curSignal == 0)
                begin
                    POS_COUNTER <= 0; // reset positive counter
                    NEG_COUNTER <= NEG_COUNTER + 1; // begin negative counter
                end
            else
                begin        
                    NEG_COUNTER <= 0 ;
                    POS_COUNTER <= POS_COUNTER+1;
                end
                
            // if the signal has finished and we have processed it up to 12 bits (which means it has been processed correctly)
            if ( (NEG_COUNTER > END_THRESHOLD) && (LOCATION_COUNTER == 12))
            begin
                rst <= 0;
                rReady <= 1; 
            end else begin

            // We will analyze the POS_COUNTER which has been counting during the signals positive cycle. 
            // if the previous signal is active and the current signal is on low, then we have 3 different scenarios:
            // Case 1: (POS_COUNTER > START_THRESHOLD) --> we have a start of a new incoming signal
            // Case 2: (POS_COUNTER > BIT_THRESHOLD) --> we have a 0 for the bit in the location
            // Case 3: (POS_COUNTER < BIT_THRESHOLD) --> we have a 1 for the bit in the location

                if (beginCount) 
                begin
                        
                    NEG_COUNTER <= 0;

                    if (rst) begin

                        if (POS_COUNTER > BIT_THRESHOLD) begin // Case 2
                        
                            rRemoteReading[11-LOCATION_COUNTER] <= 0;
                            LOCATION_COUNTER <= LOCATION_COUNTER + 1;
                        
                        end else if ( POS_COUNTER <= BIT_THRESHOLD ) begin // Case 3

                            rRemoteReading[11-LOCATION_COUNTER] <= 1;
                            LOCATION_COUNTER <= LOCATION_COUNTER + 1;

                        end

                    end else begin
                        if (POS_COUNTER > START_THRESHOLD) // Case 1 
                        begin  
                            rst <= 1;
                            LOCATION_COUNTER <= 0;
                            rRemoteReading = 0;
                        end
                    end
                end 
            end
            end
        end

endmodule