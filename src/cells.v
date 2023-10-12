/* 
This file provides the mapping from the Wokwi modules to Verilog HDL

It's only needed for Wokwi designs

*/
`define default_netname none

module buffer_cell (
    input logic in,
    output logic out
    );
    assign out = in;
endmodule

module and_cell (
    input logic a,
    input logic b,
    output logic out
    );

    assign out = a & b;
endmodule

module or_cell (
    input logic a,
    input logic b,
    output logic out
    );

    assign out = a | b;
endmodule

module xor_cell (
    input logic a,
    input logic b,
    output logic out
    );

    assign out = a ^ b;
endmodule

module nand_cell (
    input logic a,
    input logic b,
    output logic out
    );

    assign out = !(a&b);
endmodule

module not_cell (
    input logic in,
    output logic out
    );

    assign out = !in;
endmodule

module mux_cell (
    input logic a,
    input logic b,
    input logic sel,
    output logic out
    );

    assign out = sel ? b : a;
endmodule

module dff_cell (
    input logic clk,
    input logic d,
    output reg q,
    output logic notq
    );

    assign notq = !q;
    always @(posedge clk)
        q <= d;

endmodule

module dffsr_cell (
    input logic clk,
    input logic d,
    input logic s,
    input logic r,
    output reg q,
    output logic notq
    );

    assign notq = !q;

    always @(posedge clk or posedge s or posedge r) begin
        if (r)
            q <= 0;
        else if (s)
            q <= 1;
        else
            q <= d;
    end
endmodule
