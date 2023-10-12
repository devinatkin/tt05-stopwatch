`timescale 1ns / 1ps

module timer (
  input logic clk,      // Clock input 100Mhz
  input logic clk1k,    // Clock input 1Khz
  input logic rst_n,    // Active low asynchronous reset
  input logic en,       // Enable the timer
  input logic start,    // Start the timer
  input logic stop,     // Stop the timer
  input logic reset,    // Reset the timer
  input logic inc_min,  // Set minutes
  input logic inc_sec,  // Set seconds
  input logic inc,
  output logic [5:0] minutes,  // Minutes
  output logic [5:0] seconds,  // Seconds
  output logic blink          // Blink output
);

  logic running;  // Flag to indicate if the timer is running
  logic set_time; // Flag to indicate if the time is set
  logic [9:0] time_ms;
  logic [5:0] time_sec;
  logic [5:0] time_min;

  // Assign output values
  assign minutes = time_min;
  assign seconds = time_sec;

  // Instantiate the time_counter module
  time_counter timer (
    .clk_1khz(clk1k),
    .clk_high_speed(clk),
    .rst_n(rst_n && !reset),
    .up_down(inc && !running),  // Count up or down when setting time, 1 = up, 0 = down, but only count down when running
    .en(en && running),
    .inc_sec(inc_sec),
    .inc_min(inc_min),
    .time_ms(time_ms),
    .time_sec(time_sec),
    .time_min(time_min)
  );

  // Manage control logic
  always @(posedge clk) begin
    if (~rst_n) begin
      running <= 1'b0;
      set_time <= 1'b0;
      blink <= 1'b0;
    end else if (reset) begin
      running <= 1'b0;
      set_time <= 1'b0;
      blink <= 1'b0;
    end else if (start) begin
      if (set_time) running <= 1'b1;
      blink <= 1'b0;
    end else if (stop) begin
      running <= 1'b0;
      blink <= 1'b0;
    end else if (inc_min || inc_sec) begin
      set_time <= 1'b1; // Time is set
      blink <= 1'b0;
    end

    if (time_min == 0 && time_sec == 0) begin
      if(set_time) begin
        blink <= 1'b1;  // Toggle blink output
      end else begin
        blink <= 1'b0;
      end
    end
  end

endmodule
