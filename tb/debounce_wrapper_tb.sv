// Testbench for Debounce Wrapper
// This is a very simple testbench because the debouncer itself is debugged in the testbench for the debouncer module. So this testbench is just to make sure that the wrapper is working properly.

module tb_debounce_wrapper;

    typedef enum {Resetting, Bouncing, Stable, Completed, Failed} StateType;

    // Constants
    time stable_time_tb = 70ms;
    time some_delay = 3ns;
    time clock_period = 10ns;

    // Inputs
    logic clk;              // Clock
    logic [4:0] buttons;    // For multiple buttons
    logic reset_n;          // Reset

    // Outputs
    logic [4:0] results;     // For multiple debounced results

    logic error = 0;        // Error flag
    StateType Test_State;   // Test State       

    // Instantiate the Unit Under Test (UUT)
    debounce_wrapper uut (
        .clk(clk),          // Clock
        .rst_n(reset_n),    // Reset
        .buttons(buttons),  // For multiple buttons
        .results(results)   // For multiple debounced results
    );

    always begin            // Clock generator
        #(clock_period/2);
        clk = 1;
        #(clock_period/2);
        clk = 0;    
    end

    initial begin
        // Initialize Inputs
        clk = 0;
        buttons = 0;
        reset_n = 0;
        Test_State = Resetting;

        #102;   // wait a non-clock cycle length of time to move transitions off of clock edges
        reset_n = 1;

        // Example test for one button (say, START button at index 0)
        Test_State = Bouncing;
        buttons[0] = 1; #100;
        buttons[0] = 0; #100;
        buttons[0] = 1; #100;
        buttons[0] = 0; #100;
        Test_State = Stable;
        buttons[0] = 1;

        #(stable_time_tb+some_delay);

        assert(results[0] == 1) else begin
            $error("First Test Failed");
            Test_State = Failed;
            error = 1;
        end

        // You can add more tests for other buttons here, just like the example above.

        $display("Testbench Finished");
        if(error == 1) begin
            $display("Test Failed with Some Errors");
        end else begin
            $display("Test Passed with no Errors");
        end

        $stop;
    end
endmodule
