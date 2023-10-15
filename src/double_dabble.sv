`timescale 1ns / 1ps

module doubleDabble(
    input logic [13:0] bin,
    output logic [15:0] bcd,
    input logic clk,
    input logic rst,
    output logic ready
);

    logic [29:0] scratch;
    logic [3:0] clkcnt;
    logic shift;
    // Initialize scratch and clkcnt
    always_ff @(posedge clk) begin
        if(rst) begin
            scratch <= 30'h0;
            clkcnt <= 4'h0;
            ready <= 1'b0;
            bcd <= 16'h0;
            shift <= 1'b0;
        end else begin
            // Shift when 0 add when 1
            shift <= !shift;
            if(clkcnt == 4'h0) begin
                scratch[29:14] <= 16'h0;
                scratch[13:0] <= bin;

                clkcnt <= 4'h2;
                bcd <= scratch[29:14];
                ready <= 1'b1;
            end else begin
                ready <= 1'b0;
                if (shift == 1'b1) begin // If Shift is 1 then add 3 to each digit if >= 5
                    if (scratch[29:26] >= 5) begin 
                        scratch[29:26] <= scratch[29:26] + 3;
                    end
                    if (scratch[25:22] >= 5) begin
                        scratch[25:22] <= scratch[25:22] + 3;
                    end
                    if (scratch[21:18] >= 5) begin
                        scratch[21:18] <= scratch[21:18] + 3;

                    end
                    if (scratch[17:14] >= 5) begin 
                        scratch[17:14] <= scratch[17:14] + 3;
                    end
                end else begin // If Shift is 0 then shift left by 1

                    // Shift left by 1 and fill with 0
                    scratch[29:0] <= {scratch[28:0], 1'b0};

                    // Increment clkcnt (Tracking the number of left shifts)
                    clkcnt <= clkcnt + 1;
                end
            end



        end
    end
endmodule
