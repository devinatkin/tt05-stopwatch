//----------------------------------------------------------------------------------
//--   Original code by:
//--   Version 1.0 10/15/2017 Denis Onen
//----------------------------------------------------------------------------------
//      SystemVerilog Adaptation by Devin Atkin
module tb_debounce;
// Type Def
typedef enum {Resetting, Bouncing, Stable, Completed, Failed} StateType;

//Constants
time stable_time_tb = 70ms;
time some_delay = 3ns;
time clock_period = 10ns;


// Inputs
reg clk;
reg button;
reg reset_n;

// Outputs
wire result;

reg error = 0;

StateType Test_State;
// Instantiate the Unit Under Test (UUT)
debounce #(50000000,10) uut (
    .clk(clk), 
    .button(button), 
    .reset_n(reset_n), 
    .result(result)
);

always begin
    #(clock_period/2);
    clk = 1;
    #(clock_period/2);
    clk = 0;    
end

  initial begin
    // Initialize Inputs
    clk = 0;
    button = 0;
    reset_n = 0;
    Test_State = Resetting;
    // Wait 100 ns for global reset to finish
    #100;
    reset_n = 1; //End the Resetting

    // Add stimulus here

    //Bouncing 
    Test_State = Bouncing;
    button = 1; #100;
    button = 0; #100;
    button = 1; #100;
    button =0; #100;
    Test_State = Stable;
    button = 1;

    #(stable_time_tb+some_delay);

    assert(result == 1) $display("First Test Passed");
        else begin
            $error("First Test Failed");
            Test_State = Failed;
            error = 1;
        end

    #(clock_period*100);

    //test bouncing High to Low Transition
    Test_State = Bouncing; 
    button =0; #100;
    button = 1; #100;
    button = 0; #100;
    button = 1; #100;
    button =0; #100;
    button = 1; #100;
    Test_State = Stable;
    button = 0; 

    #(stable_time_tb+some_delay);

    assert(result == 0) $display("Second Test Passed");
        else begin
            $error("Second Test Failed");
            Test_State = Failed;
            error = 1;
        end

    #(clock_period*100);

    
    $display("Testbench Finished");
    if(error == 1) begin
        $display("Test Failed with Some Errors");
    end else begin
        $display("Test Passed with no Errors");
    end

    $stop;
  end
endmodule

