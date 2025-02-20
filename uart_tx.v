// EcoMender Bot : Task 2A - UART Transmitter
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.

This file is used to generate UART Tx data packet to transmit the messages based on the input data.

Recommended Quartus Version : 20.1
The submitted project file must be 20.1 compatible as the evaluation will be done on Quartus Prime Lite 20.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

/*
Module UART Transmitter

Input:  clk_3125 - 3125 KHz clock
        parity_type - even(0)/odd(1) parity type
        tx_start - signal to start the communication.
        data    - 8-bit data line to transmit

Output: tx      - UART Transmission Line
        tx_done - message transmitted flag
*/

// module declaration
module uart_tx(
    input clk_3125,
    input parity_type,
    input tx_start,
    input [7:0] data,
    output reg tx,
    output reg tx_done
);

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////

// State Encoding
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
reg parity_bit;
reg [3:0] bit_duration_counter; // counter to track bit duration

// Parameters
localparam BIT_DURATION = 14; // 14 clock cycles for 230400 baud

// Initialization
initial begin
    tx = 1; // Idle state for UART is high
    tx_done = 0;
    current_state = IDLE;
    bit_duration_counter = 0;
end

// Parity Calculation
always @(*) begin
    if (parity_type == 1) // Odd parity
        parity_bit = ~^data;
    else // Even parity
        parity_bit = ^data;
end

// State Machine
always @(posedge clk_3125) begin
    case (current_state)
        IDLE: begin
            tx <= 1;
            tx_done <= 0;
            bit_duration_counter <= 0; // Reset counter in IDLE state
            if (tx_start) begin
                tx <= 0; // Set tx low immediately for the start bit
                current_state <= START_BIT;
            end
        end
        START_BIT: begin
            tx <= 0; // Start bit is low
            if (bit_duration_counter == BIT_DURATION - 2) begin
                current_state <= DATA_BIT_0;
                bit_duration_counter <= 0;
            end else begin
                bit_duration_counter <= bit_duration_counter + 1;
            end
        end
        DATA_BIT_0: begin
            tx <= data[7];
            if (bit_duration_counter == BIT_DURATION - 1) begin
                current_state <= DATA_BIT_1;
                bit_duration_counter <= 0;
            end else begin
                bit_duration_counter <= bit_duration_counter + 1;
            end
        end
        DATA_BIT_1: begin
            tx <= data[6];
            if (bit_duration_counter == BIT_DURATION - 1) begin
                current_state <= DATA_BIT_2;
                bit_duration_counter <= 0;
            end else begin
                bit_duration_counter <= bit_duration_counter + 1;
            end
        end
        DATA_BIT_2: begin
            tx <= data[5];
            if (bit_duration_counter == BIT_DURATION - 1) begin
                current_state <= DATA_BIT_3;
                bit_duration_counter <= 0;
            end else begin
                bit_duration_counter <= bit_duration_counter + 1;
            end
        end
        DATA_BIT_3: begin
            tx <= data[4];
            if (bit_duration_counter == BIT_DURATION - 1) begin
                current_state <= DATA_BIT_4;
                bit_duration_counter <= 0;
            end else begin
                bit_duration_counter <= bit_duration_counter + 1;
            end
        end
        DATA_BIT_4: begin
            tx <= data[3];
            if (bit_duration_counter == BIT_DURATION - 1) begin
                current_state <= DATA_BIT_5;
                bit_duration_counter <= 0;
            end else begin
                bit_duration_counter <= bit_duration_counter + 1;
            end
        end
        DATA_BIT_5: begin
            tx <= data[2];
            if (bit_duration_counter == BIT_DURATION - 1) begin
                current_state <= DATA_BIT_6;
                bit_duration_counter <= 0;
            end else begin
                bit_duration_counter <= bit_duration_counter + 1;
            end
        end
        DATA_BIT_6: begin
            tx <= data[1];
            if (bit_duration_counter == BIT_DURATION - 1) begin
                current_state <= DATA_BIT_7;
                bit_duration_counter <= 0;
            end else begin
                bit_duration_counter <= bit_duration_counter + 1;
            end
        end
        DATA_BIT_7: begin
            tx <= data[0];
            if (bit_duration_counter == BIT_DURATION - 1) begin
                current_state <= PARITY_BIT;
                bit_duration_counter <= 0;
            end else begin
                bit_duration_counter <= bit_duration_counter + 1;
            end
        end
        PARITY_BIT: begin
            tx <= parity_bit;
            if (bit_duration_counter == BIT_DURATION - 1) begin
                current_state <= STOP_BIT;
                bit_duration_counter <= 0;
            end else begin
                bit_duration_counter <= bit_duration_counter + 1;
            end
        end
        STOP_BIT: begin
            tx <= 1;
            if (bit_duration_counter == BIT_DURATION - 2) begin
                current_state <= DONE;
					 bit_duration_counter <= 0;
            end else begin
                bit_duration_counter <= bit_duration_counter + 1;
            end
        end
       DONE: begin
            tx_done <= 1;
            current_state <= IDLE;
        end
    endcase
end

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////

endmodule