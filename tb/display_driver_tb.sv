`timescale 1ns / 1ns

// This is a testbench for the display_driver module. I'm going to recommend you take this module at faith as it can be annoying to simulate.
// This is because it has to account for the need to cycle through the anodes and the need to hold the display for a certain amount of time.


module tb_display_driver();

    // Declare signals to connect to the display_driver module
    logic clk;              // 100MHz clock (Lower frequency clocks are generated internal to the display_driver module)
    logic rst_n;            // Active low reset
    logic [5:0] minutes;    // 6-bit minutes value
    logic [5:0] seconds;    // 6-bit seconds value
    logic [6:0] seg;         // 7-bit segment value
    logic [3:0] an;          // 4-bit anode value

    logic [31:0] displayHold;   // 32-bit value to hold the display for a certain amount of time


    // Instantiate the display_driver module
    display_driver uut (
        .clk(clk),
        .rst_n(rst_n),
        .minutes(minutes),
        .seconds(seconds),
        .seg(seg),
        .an(an)
    );

    // Clock generation blocks for 100MHz
    always #5 clk = ~clk;

    always @(an) begin
        $display("an = %b , seg = %b, time = %2d:%2d", an, seg, minutes, seconds);
        #1; // Short Delay to move transitions away from clock edges
        if(an == 4'b0111) begin //Increment after the anodes have been cycled through
            displayHold = displayHold + 1;
            if(displayHold == 32'd3) begin //Increment after 100 anode cycles
                displayHold = 32'd0;
                seconds = seconds + 1;
                if(seconds == 6'd60) begin
                    seconds = 6'd0;
                    minutes = minutes + 1;
                end
            end
        end
    end

    // Testbench logic
    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        minutes = 6'b0;
        seconds = 6'b0;
        displayHold = 32'd0;

        #2; // Short Delay to move transitions away from clock edges

        // Apply reset
        rst_n = 0;
        #10;
        rst_n = 1;
        #100;

        while (minutes < 6'd60) begin // wait for minutes to be 60 before ending simulation (This is a long time to wait, especially given the simulation runs slower than real time)
            #100;
        end
        $finish;
    end

endmodule
