module tt_um_devinatkin_stopwatch
(
    input  logic [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output logic [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  logic [7:0] uio_in,   // IOs: Bidirectional Input path
    output logic [7:0] uio_out,  // IOs: Bidirectional Output path
    output logic [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  logic       ena,      // will go high when the design is enabled
    input  logic       clk,      // clock
    input  logic       rst_n     // reset_n - low to reset
);

    // Instantiate the top module
    top uut (
        .clk(clk),
        .rst_n(rst_n),
        .en(ena),
        .start_btn(ui_in[0]),
        .stop_btn(ui_in[1]),
        .softrst_sw(ui_in[2]),
        .inc_min_btn(ui_in[3]),
        .inc_sec_btn(ui_in[4]),
        .inc_sw(ui_in[5]),
        .seg(uo_out[6:0]),
        .an(uio_out[3:0])
    );
assign uo_out[7] = 1'b0;

assign uio_out[7:4] = 4'b1111;

assign uio_oe = 8'b11111111;
endmodule

