`timescale 1ns / 1ps

module time_counter (
  input wire clk_1khz,       // 1 kHz Clock for millisecond counting
  input wire clk_high_speed, // High-speed clock for general operation
  input wire rst_n,          // Asynchronous reset (active low)
  input wire up_down,        // Up/Down control: 1 for counting up, 0 for counting down
  input wire en,             // Enable signal
  input wire inc_sec,        // Increment/Decrement 1 second
  input wire inc_min,        // Increment/Decrement 1 minute
  output logic [9:0] time_ms, // Time in milliseconds (Max 1 second, will rollover to 0 after 1 second)
  output logic [5:0] time_sec, // Time in seconds (Max 63 seconds, will rollover to 0 after 60 seconds)
  output logic [5:0] time_min  // Time in minutes (Max 63 minutes, will rollover to 0 after 60 minutes)
);

logic clk_1khz_prev = 0;   // Store previous value of clk_1khz for edge detection
logic inc_sec_prev = 0;    // Store previous value of inc_sec for edge detection
logic inc_min_prev = 0;    // Store previous value of inc_min for edge detection

always @(posedge clk_high_speed) begin
    if (~rst_n) begin
      // Asynchronously reset the time counters and previous value registers
      time_ms <= 32'h0;
      time_sec <= 6'h0;
      time_min <= 6'h0;
      clk_1khz_prev <= 0;
      inc_sec_prev <= 0;
      inc_min_prev <= 0;
    end else begin

        if (clk_1khz && ~clk_1khz_prev) begin // Sample the 1kHz clock at the rising edge of the high-speed clock
            // Count milliseconds on a positive edge of the 1kHz clock
            if (en) begin
                if (up_down) begin
                        if(time_ms < 10'h3E7) begin // Count milliseconds on a positive edge of the 1kHz clock if counting up and time_ms is not 999
                            time_ms <= time_ms + 1;
                        end else if (time_sec < 6'h3B) begin // If time_ms is 999, increment time_sec and set time_ms to 0, if time_sec is not 59
                            time_ms <= 0;
                            time_sec <= time_sec + 1;
                        end else if (time_min < 6'h3B) begin // If time_sec is 59, increment time_min and set time_sec to 0, if time_min is not 59
                            time_ms <= 0;
                            time_sec <= 0;
                            time_min <= time_min + 1;
                        end
                end else begin


                    // Decrement, but prevent rollover
                        if(time_ms > 0) begin // Count milliseconds on a positive edge of the 1kHz clock if counting down and time_ms is not 0
                            time_ms <= time_ms - 1;
                        end else if (time_sec > 0) begin // If time_ms is 0, decrement time_sec and set time_ms to 999, if time_sec is not 0
                            time_ms <= 10'h3E7;
                            time_sec <= time_sec - 1;
                        end else if (time_min > 0) begin // If time_sec is 0, decrement time_min and set time_sec to 59, if time_min is not 0
                            time_ms <= 10'h3E7;
                            time_sec <= 6'h3B;
                            time_min <= time_min - 1;
                        end  
                end
            end
        end else begin
            if(up_down) begin 
                if (inc_sec && ~inc_sec_prev) begin // Increment or decrement by 1 second if inc_sec is toggled
                    if(time_sec < 6'h3C) begin
                        time_sec <= time_sec + 1;
                    end else begin
                        time_sec <= 0;
                        time_min <= time_min + 1;
                    end

                end else if (inc_min && ~inc_min_prev) begin // Increment or decrement by 1 minute if inc_min is toggled
                    if (time_min < 6'h3C) begin
                        time_min <= time_min + 1;
                    end
                end 


            end else begin
                // Decrement Second or Minute if inc_sec or inc_min is toggled, but prevent rollover
                if (inc_sec && ~inc_sec_prev) begin // Increment or decrement by 1 second if inc_sec is toggled
                    if(time_sec > 0) begin
                        time_sec <= time_sec - 1;
                    end else if (time_min > 0) begin
                        time_sec <= 6'h3B;
                        time_min <= time_min - 1;
                    end

                end else if (inc_min && ~inc_min_prev) begin // Increment or decrement by 1 minute if inc_min is toggled
                    if(time_min > 0) begin
                        time_min <= time_min - 1;
                    end else begin
                        time_min <= 6'h3B;
                    end
                    

                end
            end

            // Update previous value for edge detection
            inc_sec_prev <= inc_sec;
            // Update previous value for edge detection
            inc_min_prev <= inc_min;

        end
        // Update previous value for edge detection
        clk_1khz_prev <= clk_1khz;

    end
end
endmodule
