`timescale 1ns/1ps


module pwm_module
#(parameter bit_width = 8)
(
input wire clk,                         // 1-bit input: clock
input wire rst_n,                       // 1-bit input: reset
input [bit_width-1:0] duty,              // bitwidth-bit input: duty cycle
input [bit_width-1:0] max_value,         // bitwidth-bit input: maximum value
output logic pwm_out                     // 1-bit output: pwm output
);

logic [bit_width-1:0] counter;

// pwm output is high when counter is less than duty
// otherwise, pwm output is low
always_ff @(posedge clk)
begin
    if (~rst_n) begin
        counter <= (bit_width)'('d0);               // counter is reset to 0
        pwm_out <= 1'b0;                            // pwm output is low when reset
    end else begin 
        if (counter == max_value) begin             // counter is reset to 0 when it reaches max_value
            counter <= (bit_width)'('d0);          
        end else begin                              // counter is incremented by 1
            counter <= counter + (bit_width)'('d1);
        end
        pwm_out <= (counter <= duty);               // pwm output is high when counter is less than duty
    end
end
endmodule