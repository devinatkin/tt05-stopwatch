`timescale 1ns/1ps

module tb_pwm_module;

  // Parameters
  localparam bit_width = 10;                                // Instantiation parameter for the PWM module, sets the bit width of the PWM counter
  localparam CLK_PERIOD = 10;                               // Time period of the clock (in simulation time units) 10ns = 100MHz
  localparam [bit_width-1:0] max_value = (1<<bit_width)-2;  // Maximum value of the PWM counter, this sets the period of the PWM signal
  // Inputs
  logic clk;                                                // Clock input
  logic rst_n;                                              // Reset input (active-low)
  logic [bit_width-1:0] duty = 1;                               // Duty cycle input

  // Outputs
  wire pwm_out;                                             // PWM output

    // Variables
  time previous_duty_out_rise=0;                              // Time of the previous rising edge of the duty cycle output
  time previous_duty_out_fall=0;                              // Time of the previous falling edge of the duty cycle output
  time period=0;                                              // Period of the PWM signal
  time time_high=0;                                           // Time the PWM signal is high
  time time_low=0;                                            // Time the PWM signal is low                                    
  time current_time=0;                                        // Current simulation time
  time previous_period=0;                                     // Period of the previous PWM signal

  real calculated_duty = 1;
  real calculated_intendedduty=  1;
  real error = 1;
  // Instantiate the DUT (Device Under Test)
  pwm_module #(
    .bit_width(bit_width)
  ) dut (
    .clk(clk),
    .rst_n(rst_n),
    .duty(duty),
    .max_value(max_value), // Set maximum value to 2^32-1 (2^bit_width-
    .pwm_out(pwm_out)
  );

  // Clock generator
  always #((CLK_PERIOD)/2) clk = ~clk;

  // Initialize inputs
  initial begin
    clk = 0;
    rst_n = 0; // Assert reset (active-low)
    duty = 0;  // Set initial duty cycle
    #80;       // Wait for a few cycles
    rst_n = 1; // Release reset
    #20;       // Wait for a few cycles

    // Test with different duty cycle values, should work for all duty cycles except for 0%
    for (int i = 1; i < max_value; i++) begin
      #(max_value*CLK_PERIOD*2);
      duty = i;
    end
    $finish;
  end

  // Test cases
    // Test with different duty cycle values, should work for all duty cycles except for 0%
    always @(posedge pwm_out) begin
        current_time = $time;
        if(previous_duty_out_rise != 0 && previous_duty_out_fall != 0) begin
            period = current_time - previous_duty_out_rise;
            time_low = current_time - previous_duty_out_fall;
            time_high = period - time_low;
            if(period == previous_period) begin
                calculated_duty = (time_high/real'(period))*100;
                calculated_intendedduty = (duty/real'(max_value))*100;
                error = (calculated_duty-calculated_intendedduty)/calculated_intendedduty*100;
                $display("Period: %0d, High: %0d, Low: %0d, Duty: %0f, Intended Duty: %0f, Error: %0f", period, time_high, time_low, calculated_duty, calculated_intendedduty, error);
                
            end
            previous_period = period;
        end
        previous_duty_out_rise = current_time;
    end
    always @(negedge pwm_out) begin
        current_time = $time;
        if(previous_duty_out_rise != 0 && previous_duty_out_fall != 0) begin
            period = current_time - previous_duty_out_fall;
            time_high = current_time - previous_duty_out_rise;
            time_low = period - time_high;
            if(period == previous_period) begin
                calculated_duty = (time_high/real'(period))*100;
                calculated_intendedduty = (duty/real'(max_value))*100;
                error = (calculated_duty-calculated_intendedduty)/calculated_intendedduty*100;
                $display("Period: %0d, High: %0d, Low: %0d, Duty: %0f, Intended Duty: %0f, Error: %0f", period, time_high, time_low, calculated_duty, calculated_intendedduty, error);
                
            end
            
        end
        previous_duty_out_fall = current_time;
    end
  

endmodule