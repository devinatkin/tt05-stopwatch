// Adapted to SystemVerilog from https://forum.digikey.com/t/debounce-logic-circuit-vhdl/12573
// Verilog version https://forum.digikey.com/t/debounce-logic-circuit-verilog/13196
// This version below is a direct translation of the diagram in the above reference. The commented
// out version at the bottom is a translation from the VHDL code in the reference, to SystemVerilog.
// Both versions work fine.
 
module debounce
 #(parameter clk_freq    = 25_000_000, // system clock frequency in Hz (e.g. 25 MHz for DE10-Lite)       
             stable_time = 10)         // time button must remain stable in ms (e.g. 20 ms for the bounce time)
  (input  logic clk,     // input clock                   
                reset_n, // asynchronous active low reset 
                button,  // input signal to be debounced  
   output logic result); // debounced signal              

  logic ff1,ff2,ff3;
  logic ena;
  logic sclr;
  localparam int max_count = clk_freq*stable_time/1000; // the number of clk cycles in the bounce time
  //int   count; // logic elements = 48, registers = 35
  logic [$clog2(max_count):0] count; // this gives a more optimal implementation, than int version
                                     // logic elements = 34, registers = 24
  
  always_ff @(posedge clk) // define the 3 flip flops
    if(!reset_n) begin
      ff1 <= 0;
      ff2 <= 0;
      ff3 <= 0;
    end
    else begin
      if(ena)
        ff3 <= ff2;
      ff1 <= button;
      ff2 <= ff1;  
    end
  
  assign result = ff3;
  
  assign sclr = ff1 ^ ff2; // XOR
  
  always_ff @(posedge clk)
    if(!reset_n)
      count <= 0;
    else if(sclr) // clears count if xor is high (xor inputs are different, meaning button input is not stable so reset the count)
        count <= 0;
    else if (!ena) // if count is less than the stable time, then keep counting
        count <= count + 1;
  
  assign ena = (count > max_count) ? 1 : 0; // comparator, if the max_count is reached by count then 
                                            // the button input has been stable for the bounce time
endmodule
           
