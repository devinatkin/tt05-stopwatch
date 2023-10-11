`timescale 1ns / 1ps

module timer (
  input wire clk,      // Clock input 100Mhz
  input wire clk1k,    // Clock input 1Khz
  input wire rst_n,    // Active low asynchronous reset
  input wire en,       // Enable the timer
  input wire start,    // Start the timer
  input wire stop,     // Stop the timer
  input wire reset,    // Reset the timer
  input wire inc_min,  // Set minutes
  input wire inc_sec,  // Set seconds
  input wire inc,
  output logic [5:0] minutes,  // Minutes
  output logic [5:0] seconds,  // Seconds
  output logic blink          // Blink output
);

  logic running;  // Flag to indicate if the timer is running
  logic set_time; // Flag to indicate if the time is set
  wire [9:0] time_ms;
  wire [5:0] time_sec;
  wire [5:0] time_min;

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
