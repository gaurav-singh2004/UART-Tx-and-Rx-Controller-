`timescale 1ns/1ps

module uart_controller_tb;

  parameter CLOCK_RATE = 100_000_000; // 100 MHz
  parameter BAUD_RATE = 9600;
  parameter RX_OVERSAMPLE = 16;

  reg clk;
  reg reset_n;
  reg [7:0] i_Tx_Byte;
  reg i_Tx_Ready;
  wire o_Rx_Done;
  wire [7:0] o_Rx_Byte;

  // Instantiate UART Controller
  uart_controller #(CLOCK_RATE, BAUD_RATE, RX_OVERSAMPLE) uut (
    .clk(clk),
    .reset_n(reset_n),
    .i_Tx_Byte(i_Tx_Byte),
    .i_Tx_Ready(i_Tx_Ready),
    .o_Rx_Done(o_Rx_Done),
    .o_Rx_Byte(o_Rx_Byte)
  );

  // Clock generation
  always #5 clk = ~clk; // 10ns period (100 MHz clock)

  initial begin
    // Initialize signals
    clk = 0;
    reset_n = 0;
    i_Tx_Byte = 8'b00000000;
    i_Tx_Ready = 0;
    
    // Apply reset
    #20 reset_n = 1;
    
    // Send first byte
    #50 i_Tx_Byte = 8'b10101010;
    i_Tx_Ready = 1;
    #10 i_Tx_Ready = 0;
    
    // Wait for transmission and reception
    #500;
    
    // Send second byte
    #50 i_Tx_Byte = 8'b11001100;
    i_Tx_Ready = 1;
    #10 i_Tx_Ready = 0;
    
    // Wait for completion
    #500;
    
    // End simulation
    $stop;
  end

  // Monitor output signals
  initial begin
    $monitor("Time=%0t, Tx_Byte=%b, Rx_Byte=%b, Rx_Done=%b", 
             $time, i_Tx_Byte, o_Rx_Byte, o_Rx_Done);
  end

endmodule
