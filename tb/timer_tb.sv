`timescale 1ns / 1ps

// This is a testbench for the timer module
// It sets a 5-second timer and checks if it counts down properly
// This testbench is simple because the primary functionality of the timer is tested in the time counter module testbench
// This testbench only needs to check that the timer can accept a time and then run down. 
module tb_timer;

  logic clk;
  logic clk1k;
  logic rst_n;
  logic en;
  logic start;
  logic stop;
  logic reset;
  logic inc_min;
  logic inc_sec;
  logic [5:0] minutes;
  logic [5:0] seconds;
  logic blink;

  // Instantiate the device under test (DUT)
  timer uut (
    .clk(clk),
    .clk1k(clk1k),
    .rst_n(rst_n),
    .en(en),
    .start(start),
    .stop(stop),
    .reset(reset),
    .inc_min(inc_min),
    .inc_sec(inc_sec),
    .inc(1'b1),
    .minutes(minutes),
    .seconds(seconds),
    .blink(blink)
  );

    // Clock generation for 100MHz
    always begin
        #5 clk = 1;
        #5 clk = 0;
    end

    // Clock generation for 1KHz (Sped up for simulation purposes)
    always begin
        #5000 clk1k = 1;
        #5000 clk1k = 0;
    end


  // Test procedure
  initial begin
    // Initialize signals
    clk = 0;
    clk1k = 0;
    rst_n = 0;
    en = 0;
    start = 0;
    stop = 0;
    reset = 0;
    inc_min = 0;
    inc_sec = 0;

    // Apply reset
    rst_n = 0;
    #12 rst_n = 1;

    // Check if module is properly reset
    if (minutes !== 0 || seconds !== 0 || blink !== 0) begin
      $display("Error: Module not properly reset!");
      $finish;
    end

    // Set 3-second timer
    inc_sec = 1;
    #100 inc_sec = 0;
    #100 inc_sec = 1;
    #100 inc_sec = 0;
    #100 inc_sec = 1;
    #100 inc_sec = 0;
    en = 1;
    #100 inc_sec = 0;
    #100 inc_sec = 1;
    #100 inc_sec = 0;
    #100 inc_sec = 1;
    #100 inc_sec = 0;   
    #100 start = 1;
    #100 start = 0;

    // Check if timer counted down to zero and blink is toggled
    if (minutes !== 0 || seconds !== 5 || blink !== 0) begin
      $display("Error: Timer did not count up properly!");
      $finish;
    end else begin
      $display("Success: The Timer Set Correctly!");
    end

    // Wait for 6 seconds
    #10000000;
    #10000000;
    #10000000;
    #10000000;
    #10000000;
    #10000000;
    if(minutes !== 0 || seconds !== 0 || blink !== 1) begin
      $display("Error: Timer did not count down properly!");
      $display("Current time is %d:%d", minutes, seconds);
      $finish;
    end else begin
      $display("Success: The Timer Counted Correctly!");
    end
    $finish;
  end

endmodule
