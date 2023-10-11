// debounce_wrapper.v
// This module instantiates 5 debounce modules and connects them to the buttons and results wires.

module debounce_wrapper(
    input wire clk,                 // The clock signal
    input wire rst_n,               // The reset signal
    input wire [4:0] buttons,       // A 5-bit wide wire to hold the states of 5 buttons
    output logic [4:0] results      // A 5-bit wide wire to hold the debounced results
);


    generate                        // Generate 5 debounce instances (This is one of the few good places to use a for loop in System Verilog)
        genvar i;                   // Declare a generate variable, this is used to index the for loop to quickly instantiate multiple modules #(BE CAREFUL, it is easy to make mistakes with generate statements)
        for (i = 0; i < 5; i = i + 1) begin: debounce_instances
            // Instantiate the debounce module
            debounce #(50000000,10) generic_debounce (
                .clk(clk),              // Connect the clock signal to the debounce module
                .button(buttons[i]),    // Connect the ith button to the ith debounce module
                .reset_n(rst_n),        // Connect the reset signal to the debounce module
                .result(results[i])     // Connect the ith result to the ith debounce module
            );
        end
    endgenerate

    // You could also instantiate the debounce modules individually and connect them to the buttons and results wires like this:
    // debounce #(50000000,10) generic_debounce_0 (.clk(clk), .button(buttons[0]), .reset_n(rst_n), .result(results[0]));
    // debounce #(50000000,10) generic_debounce_1 (.clk(clk), .button(buttons[1]), .reset_n(rst_n), .result(results[1]));
    // debounce #(50000000,10) generic_debounce_2 (.clk(clk), .button(buttons[2]), .reset_n(rst_n), .result(results[2]));
    // debounce #(50000000,10) generic_debounce_3 (.clk(clk), .button(buttons[3]), .reset_n(rst_n), .result(results[3]));
    // debounce #(50000000,10) generic_debounce_4 (.clk(clk), .button(buttons[4]), .reset_n(rst_n), .result(results[4]));

    // This is even fewer Lines of code! But it is not as flexible as the generate statement above. If you wanted to add more buttons, you would have to add more lines of code.
    
endmodule
