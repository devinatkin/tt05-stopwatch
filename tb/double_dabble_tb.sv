`timescale 1ns / 1ps
// 14-bit Binary to BCD Converter
// This testbench is used to test the double dabble module, It cycles through all the numbers from 0 to 9999 and checks if the output is correct.
module double_dabble_tb();
logic clk;
logic rst;
wire ready;
logic[13:0] bin = 14'b00_0000_0000_0000;
logic [15:0] clkcnt = 0;
logic [15:0] bcd;
doubleDabble uut(bin,bcd,clk,rst,ready);
logic [13:0] bcd_to_bin = 14'b00_0000_0000_0000;
initial begin
    clk = 0;
    rst = 1;
    #6;
    clk = 1;
    #5;
    rst = 0;
    do begin

        if (ready) begin
            bcd_to_bin = bcd[3:0] + ((bcd[7:4])*10) + ((bcd[11:8])*100)+((bcd[15:12])*1000);

            if(bcd_to_bin == bin) begin
                $display("Number Input: %d",bin);
                $display("BCD Output: %d %d %d %d",bcd[15:12],bcd[11:8],bcd[7:4],bcd[3:0]);
                $display("BCD Output: %b %b %b %b",bcd[15:12],bcd[11:8],bcd[7:4],bcd[3:0]);
                $display("Number Output: %d",bcd_to_bin);
                bin <= bin + 1;
            end
            
        end
        clkcnt= clkcnt + 1;
        clk = ~clk;
        #5;
        clk = ~clk;
        #5;
        
    end while(bin < 14'd10000);
end   

endmodule