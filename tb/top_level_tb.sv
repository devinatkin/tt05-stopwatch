`timescale 1ns / 1ps

module tb_top();

    // Declare the signals to connect to the top module
    logic clk;
    logic rst;
    logic start_btn;
    logic stop_btn;
    logic softrst_btn;
    logic inc_min_btn;
    logic inc_sec_btn;
    logic mode_sw;
    logic sw_inc;
    wire [6:0] seg;
    wire [3:0] an;

    //Constants
    time stable_time_tb = 70ms;
    time some_delay = 3ns;
    time clock_period = 10ns;

    time wait_time = 1s;

    // Clock Generation
    always #5 clk = ~clk;  // 10ns clock period (for a 100MHz clock)

    // Instantiate the top module
    top uut (
        .clk(clk),
        .rst(rst),
        .start_btn(start_btn),
        .stop_btn(stop_btn),
        .softrst_btn(softrst_btn),
        .inc_min_btn(inc_min_btn),
        .inc_sec_btn(inc_sec_btn),
        .inc_sw(sw_inc),
        .mode_sw(mode_sw),
        .seg(seg),
        .an(an)
    );

    // Testbench Logic
    initial begin
        // Initialize signals
        clk = 0;
        rst = 0;
        start_btn = 0;
        stop_btn = 0;
        softrst_btn = 0;
        inc_min_btn = 0;
        inc_sec_btn = 0;
        mode_sw = 0;
        sw_inc = 0;
        // Reset pulse
        rst = 1;
        #10000 rst = 0;

        // Test different modes
        mode_sw = 1;
        #100 mode_sw = 0;

        // Increment minutes and seconds
        inc_min_btn = 1;
        #(stable_time_tb+some_delay);

        inc_min_btn = 0;
        inc_sec_btn = 1;

        #(stable_time_tb+some_delay);
        inc_sec_btn = 0;


        start_btn = 1;
        #(stable_time_tb+some_delay);
        start_btn = 0;


        // Stop timer/stopwatch
        stop_btn = 1;
        #10 stop_btn = 0;


        // Wait before ending simulation
        #(wait_time);

        $finish;
    end

endmodule
