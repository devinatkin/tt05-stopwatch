`timescale 1ns / 1ps

module tb_blinking_display;

  logic [3:0] anode_in; // 4-bit anode input
  logic clk;            // System clock
  logic rst_n;          // Active-low reset
  logic blink;          // Blink control bit
  logic clk_1hz;        // 1Hz clock
  logic [3:0] anode_out; // 4-bit anode output

  // Instantiate the DUT (Device Under Test)
  blinking_display uut (
    .anode_in(anode_in),
    .clk(clk),
    .rst_n(rst_n),
    .blink(blink),
    .clk_1hz(clk_1hz),
    .anode_out(anode_out)
  );

  // Clock generation for clk
  always begin
    #5 clk = ~clk;
  end

  // Clock generation for 1Hz clock
  always begin
    #500 clk_1hz = ~clk_1hz;
  end

  // Testbench stimulus
  initial begin
    // Initialize signals
    clk = 0;
    clk_1hz = 0;
    rst_n = 0;
    blink = 0;
    anode_in = 4'b0000;
    
    #2; // Small delay to move transitions away from clock edges

    #10 rst_n = 1; // De-assert reset

    // Test case 1: Blink off, pass anode_in through
    blink = 0;
    anode_in = 4'b1010;
    #20;

    // Test case 2: Blink on, anode_out should toggle between anode_in and 4'b1111
    blink = 1;
    #2000;

    // Test case 3: Blink off, pass anode_in through
    blink = 0;
    #20;

    // Test case 4: Blink on, new anode_in value
    blink = 1;
    anode_in = 4'b0101;
    #100;

    // End of test
    $finish;
  end

  // Monitor to observe the output
  initial begin
    $monitor("Time: %0d, anode_in: %b, anode_out: %b, blink: %b, blink_state: %b",
             $time, anode_in, anode_out, blink, uut.blink_state);
  end
endmodule
