`timescale 1ns/1ps

module uart_rx_controller_tb;

  parameter RX_OVERSAMPLE = 16; // Example oversampling factor
  reg clk;
  reg reset_n;
  reg i_Rx_Data;
  wire o_Rx_Done;
  wire [7:0] o_Rx_Byte;

  // Instantiate the UART RX Controller module
  uart_rx_controller #(RX_OVERSAMPLE) uut (
    .clk(clk),
    .reset_n(reset_n),
    .i_Rx_Data(i_Rx_Data),
    .o_Rx_Done(o_Rx_Done),
    .o_Rx_Byte(o_Rx_Byte)
  );

  // Clock generation
  always #5 clk = ~clk; // 10ns period (100MHz clock)

  // Task to simulate a UART byte reception
  task send_uart_byte;
    input [7:0] data;
    integer i;
    begin
      // Send start bit
      i_Rx_Data = 0;
      #(RX_OVERSAMPLE * 10);
      
      // Send data bits (LSB first)
      for (i = 0; i < 8; i = i + 1) begin
        i_Rx_Data = data[i];
        #(RX_OVERSAMPLE * 10);
      end
      
      // Send stop bit
      i_Rx_Data = 1;
      #(RX_OVERSAMPLE * 10);
    end
  endtask

  initial begin
    // Initialize inputs
    clk = 0;
    reset_n = 0;
    i_Rx_Data = 1;
    
    // Apply reset
    #20 reset_n = 1;
    
    // Send test bytes
    #50 send_uart_byte(8'b10101010);
    #50 send_uart_byte(8'b11001100);
    
    // Wait and finish test
    #200 $stop;
  end

  // Monitor signals
  initial begin
    $monitor("Time=%0t, Reset=%b, Rx_Data=%b, Rx_Byte=%b, Rx_Done=%b", 
             $time, reset_n, i_Rx_Data, o_Rx_Byte, o_Rx_Done);
  end

endmodule
