`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2022 02:58:00 PM
// Design Name: 
// Module Name: doubleDabble
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// Based on the algorithmic description on Wikipedia https://en.wikipedia.org/wiki/Double_dabble
//////////////////////////////////////////////////////////////////////////////////


module doubleDabble(
    input [13:0] bin,
    output logic [15:0] bcd,
    input clk,
    input rst,
    output logic ready
    );
    
    // Reserve a size that is big enough for both the BCD and binary representations (This scratch space)
    logic [29:0] scratch;
    logic [3:0] clkcnt;
    // Partition the space as so for our case
    // 1000s 100s Tens Ones OriginalBinary
    // 0000 0000 0000 0000 00000000000000
    
    //Iterate the algorithm for the number of bits in the input (14 times)
    //On each iteration shift 1 left and if any BCD number is >=5 increment the value by 3
    always_ff @(posedge clk)
    begin
        if(rst) begin
            scratch <= 0;
            bcd <= 0;
            ready <= 1;
            clkcnt <= 0;
        end else if(clk) begin
            //Check If Ready
            if(scratch[29:26] >= 5) begin //Add to any bcd which is >= 5
                    scratch[29:26] = scratch[29:26] + 3;
            end
            if(scratch[25:22] >= 5) begin
                    scratch[25:22] = scratch[25:22] + 3;
            end
            if(scratch[21:18] >= 5) begin
                    scratch[21:18]  = scratch[21:18] + 3;
            end
            if(scratch[17:14] >= 5) begin
                    scratch[17:14]  = scratch[17:14] + 3;
            end
            scratch[29:0] = {scratch[28:0], 1'b0}; //Shift Left
            if (clkcnt == 0) begin
                clkcnt = clkcnt + 1;
                ready = 1; //Set a Ready Flag
                bcd[15:0] = scratch[29:14]; //Set the BCD Output
                scratch[29:14] = 0;
                scratch[13:0] = bin;
            end else begin
                clkcnt = clkcnt + 1;
                ready = 0; //Not Ready
                

                if(clkcnt == 14) begin
                    clkcnt = 0;
                end
            end
            
        end
    end
endmodule