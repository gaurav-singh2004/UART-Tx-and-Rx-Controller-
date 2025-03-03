`timescale 1ns/1ps

module uart_tx_controller_tb;

  reg clk;
  reg reset_n;
  reg [7:0] i_Tx_Byte;
  reg i_Tx_Ready;
  wire o_Tx_Done;
  wire o_Tx_Active;
  wire o_Tx_Data;

  // Instantiate the UART TX Controller module
  uart_tx_controller uut (
    .clk(clk),
    .reset_n(reset_n),
    .i_Tx_Byte(i_Tx_Byte),
    .i_Tx_Ready(i_Tx_Ready),
    .o_Tx_Done(o_Tx_Done),
    .o_Tx_Active(o_Tx_Active),
    .o_Tx_Data(o_Tx_Data)
  );

  // Clock generation
  always #5 clk = ~clk; // 10ns period (100MHz clock)

  initial begin
    // Initialize inputs
    clk = 0;
    reset_n = 0;
    i_Tx_Byte = 8'b10101010;
    i_Tx_Ready = 0;
    
    // Apply reset
    #10 reset_n = 1;
    #10 i_Tx_Ready = 1;
    
    // Wait for transmission to complete
    wait(o_Tx_Done);
    
    // Test another byte
    #20 i_Tx_Byte = 8'b11001100;
    i_Tx_Ready = 1;
    #10 i_Tx_Ready = 0;
    
    wait(o_Tx_Done);
    
    // End of test
    #50 $stop;
  end

  // Monitor signals
  initial begin
    $monitor("Time=%0t, Reset=%b, Tx_Ready=%b, Tx_Byte=%b, Tx_Active=%b, Tx_Data=%b, Tx_Done=%b", 
             $time, reset_n, i_Tx_Ready, i_Tx_Byte, o_Tx_Active, o_Tx_Data, o_Tx_Done);
  end

endmodule
