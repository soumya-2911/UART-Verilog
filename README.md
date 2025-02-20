**UART Protocol Simulation in Quartus**

This repository contains the Verilog implementation and simulation of a Universal Asynchronous Receiver-Transmitter (UART) protocol using Quartus. The project includes separate modules for transmission (uart_tx) and reception (uart_rx), along with their respective testbenches.

**Project Structure**

├── UART_TX

│   ├── uart_tx.v        # UART Transmitter Module

│   ├── uart_tx_tb.v     # Testbench for UART Transmitter

│
├── UART_RX

│   ├── uart_rx.v        # UART Receiver Module

│   ├── uart_rx_tb.v     # Testbench for UART Receiver

│
└── README.md            # Project Documentation


**Features**

Implements UART transmission (uart_tx) and reception (uart_rx).

Configurable baud rate.

Uses a standard 8-N-1 format (8 data bits, no parity, 1 stop bit).

Fully testable with provided testbenches.

**Simulation & Testing**

Open Quartus and create a new project.

Add the Verilog files (uart_tx.v, uart_rx.v) to the project.

Run functional simulation using ModelSim or Quartus' built-in simulator.

Verify transmission and reception using the provided testbenches.

Observe the waveform for correct UART behavior.

**Usage**

The transmitter (uart_tx.v) takes input data and sends it serially.

The receiver (uart_rx.v) captures and reconstructs the data.

Testbenches (uart_tx_tb.v and uart_rx_tb.v) validate functionality.
