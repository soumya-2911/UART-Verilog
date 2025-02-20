module uart_rx(
    input clk_3125,
    input rx,
    output reg [7:0] rx_msg,
    output reg rx_parity,
    output reg rx_complete
);

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////
parameter IDLE       = 0;
parameter START_BIT  = 1;
parameter DATA_BIT_0 = 2;
parameter DATA_BIT_1 = 3;
parameter DATA_BIT_2 = 4;
parameter DATA_BIT_3 = 5;
parameter DATA_BIT_4 = 6;
parameter DATA_BIT_5 = 7;
parameter DATA_BIT_6 = 8;
parameter DATA_BIT_7 = 9;
parameter PARITY_BIT = 10;
parameter STOP_BIT   = 11;
parameter DONE       = 12;

reg [3:0] current_state;
reg [3:0] bit_duration_counter;
reg [7:0] data_storage;
reg parity_storage;
reg rx_sync1;
reg rx_sync2;
reg rx_stable;
//reg calculated_parity;
localparam BIT_DURATION = 14;
reg flag;
initial begin
    rx_msg = 0;
    rx_parity = 0;
    rx_complete = 0;
    data_storage = 0;
    parity_storage = 0;
    current_state = IDLE;
    bit_duration_counter = 0;
	 flag=0;
end
always @(posedge clk_3125) begin
    rx_sync1 = rx;       // First flip-flop for buffering
    rx_stable = rx_sync1; // Second flip-flop for additional stability
	 rx_sync2 = rx_stable;
end
always @(posedge clk_3125) begin
	
    case (current_state)
        IDLE: begin
            rx_complete = 0;
            data_storage = 0;
            parity_storage = 0;
            bit_duration_counter = 0; // Reset counter in IDLE state
            if (rx_sync2 == 0) begin
                current_state = START_BIT;
            end
        end
        START_BIT: begin
            rx_complete = 0;
            if (bit_duration_counter == BIT_DURATION - 1-flag) begin
                current_state = DATA_BIT_0;
                bit_duration_counter = 0;
            end else begin
                bit_duration_counter = bit_duration_counter + 1;
            end
        end
        DATA_BIT_0: begin
		  if(bit_duration_counter == 7) begin
            data_storage[7] = rx_sync2; // Store LSB first
				end
            if (bit_duration_counter == BIT_DURATION - 1) begin
                current_state = DATA_BIT_1;
                bit_duration_counter = 0;
            end else begin
                bit_duration_counter = bit_duration_counter + 1;
            end
        end
        DATA_BIT_1: begin
			if(bit_duration_counter == 7) begin
            data_storage[6] = rx_sync2;
				end
            if (bit_duration_counter == BIT_DURATION - 1) begin
                current_state = DATA_BIT_2;
                bit_duration_counter = 0;
            end else begin
                bit_duration_counter = bit_duration_counter + 1;
            end
        end
        DATA_BIT_2: begin
		  if(bit_duration_counter == 7) begin
            data_storage[5] = rx_sync2;
				end
            if (bit_duration_counter == BIT_DURATION - 1) begin
                current_state = DATA_BIT_3;
                bit_duration_counter = 0;
            end else begin
                bit_duration_counter = bit_duration_counter + 1;
            end
        end
        DATA_BIT_3: begin
		  if(bit_duration_counter == 7) begin
            data_storage[4] = rx_sync2;
				end
            if (bit_duration_counter == BIT_DURATION - 1) begin
                current_state = DATA_BIT_4;
                bit_duration_counter = 0;
            end else begin
                bit_duration_counter = bit_duration_counter + 1;
            end
        end
        DATA_BIT_4: begin
		  if(bit_duration_counter == 7) begin
            data_storage[3] = rx_sync2;
				end
            if (bit_duration_counter == BIT_DURATION - 1) begin
                current_state = DATA_BIT_5;
                bit_duration_counter = 0;
            end else begin
                bit_duration_counter = bit_duration_counter + 1;
            end
        end
        DATA_BIT_5: begin
		  if(bit_duration_counter == 7) begin
            data_storage[2] = rx_sync2;
				end
            if (bit_duration_counter == BIT_DURATION - 1) begin
                current_state = DATA_BIT_6;
                bit_duration_counter = 0;
            end else begin
                bit_duration_counter = bit_duration_counter + 1;
            end
        end
        DATA_BIT_6: begin
		  if(bit_duration_counter == 7) begin
            data_storage[1] = rx_sync2;
				end
            if (bit_duration_counter == BIT_DURATION - 1) begin
                current_state = DATA_BIT_7;
                bit_duration_counter = 0;
            end else begin
                bit_duration_counter = bit_duration_counter + 1;
            end
        end
        DATA_BIT_7: begin
		  if(bit_duration_counter == 7) begin
            data_storage[0] = rx_sync2; // Store MSB last
				end
            if (bit_duration_counter == BIT_DURATION - 1) begin
                current_state = PARITY_BIT;
                bit_duration_counter = 0;
            end else begin
                bit_duration_counter = bit_duration_counter + 1;
            end
        end
        PARITY_BIT: begin
		  if(bit_duration_counter == 7) begin
            parity_storage = rx_sync2;
				end
            if (bit_duration_counter == BIT_DURATION - 1) begin
                current_state = STOP_BIT;
                bit_duration_counter = 0;
            end else begin
                bit_duration_counter = bit_duration_counter + 1;
            end
        end
        STOP_BIT: begin
            if (bit_duration_counter == BIT_DURATION - 1) begin
                rx_complete = 1;
                //calculated_parity = ^data_storage; // XOR all bits to get parity

                if (^data_storage == parity_storage) begin
                    rx_msg = data_storage; // No error, assign received data
						  $display("Received data: %b with correct parity", data_storage);

                end else begin
                    rx_msg = 8'h3F; // Parity error, assign '?'
						    $display("Parity error! Data: %b, Expected Parity: %b, Received Parity: %b", data_storage, ^data_storage, parity_storage);

                end
                
                rx_parity = parity_storage;
                current_state = IDLE;
					 flag=1;
            end else begin
                bit_duration_counter = bit_duration_counter + 1;
            end
        end
    endcase
end

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////

endmodule
