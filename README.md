# UART Transmitter and Receiver Controller

## Overview
Implemented a **Universal Asynchronous Receiver-Transmitter (UART)** controller with both **Tx (Transmit)** and **Rx (Receive)** functionalities. The design includes a **Baud Rate Generator**, **UART Tx Controller**, and **UART Rx Controller** to facilitate Asynchronous serial communication.

## Features
- Configurable **Baud Rate**
- Supports both **Tx-only**, **Rx-only**, and **Full-Duplex** modes
- **Baud Rate Generator** for clock signal synchronization
- **Verilog-based implementation**
- Compatible with FPGA and ASIC design workflows

## Module Descriptions
## `uart_controller.sv`
- Top-level module integrating Tx and Rx controllers
- Includes Baud Rate Generator
- Supports conditional compilation for **Tx-only**, **Rx-only**, or **both**

## `baudRateGenerator.sv`
- Generates clock ticks for **Tx and Rx** based on the baud rate
- Ensures proper synchronization between sender and receiver

## `uart_tx_controller.v`
- Handles **serial transmission** of data
- Implements **start, data, and stop bits**
- Supports **asynchronous transmission**

## `uart_rx_controller.sv`
- Handles **serial reception** of data
- Detects **start bit, reads data bits, and checks stop bit**
- Outputs received data **after complete reception**

## `uart_controller_tb.sv`
- **Testbench** to validate Tx and Rx operations
- Simulates transmission and reception of **different byte values**
- Checks correctness of **`o_Rx_Byte`** output
