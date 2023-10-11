// 4-Digit 7-Segment Display Driver


module display_driver(
    input wire clk,             //100Mhz System Clock
    input wire rst_n,           //Active Low Reset
    input wire [5:0] minutes,   //6-bit input for minutes
    input wire [5:0] seconds,   //6-bit input for seconds
    output logic [6:0] seg,     //Segment Outputs
    output logic [3:0] an       //Common Anode Outputs (0 = on, 1 = off)
    );

    wire [6:0] digit0, digit1, digit2, digit3;  //Segment Outputs for each digit
    logic [3:0] bcd0, bcd1, bcd2, bcd3;         //BCD Outputs for each digit
    wire [15:0] seconds_bcd;                    //BCD Output for seconds (16-bits from double dabble, only 8 used)
    wire [15:0] minutes_bcd;                    //BCD Output for minutes (16-bits from double dabble, only 8 used)
    wire seconds_ready;                         //Ready signal from double dabble for seconds
    wire minutes_ready;                         //Ready signal from double dabble for minutes
    wire [3:0] out_sel;                         //Common Anode Outputs (0 = on, 1 = off)

    wire [3:0] assigned_value;                  //Value to be assigned to out_sel
    
    assign an = ~out_sel;                       //Common Anode Outputs (0 = on, 1 = off) (Inverted from out_sel)

    bcd_to_binary digit0_bcd_to_binary (        //Convert BCD to Binary for each digit (0-9)
        .bcd(bcd0),
        .bin(digit0)
    );

    bcd_to_binary digit1_bcd_to_binary (        //Convert BCD to Binary for each digit (0-9)
        .bcd(bcd1),
        .bin(digit1)
    );

    bcd_to_binary digit2_bcd_to_binary (        //Convert BCD to Binary for each digit (0-9)
        .bcd(bcd2),
        .bin(digit2)
    );

    bcd_to_binary digit3_bcd_to_binary (        //Convert BCD to Binary for each digit (0-9)
        .bcd(bcd3),
        .bin(digit3)
    );

    doubleDabble double_dabble_seconds(         //Double Dabble for seconds (0-59), this module is for 4 digits, but only 2 are used.
        .bin({8'd0,seconds}),
        .bcd(seconds_bcd),
        .clk(clk),
        .rst(!rst_n),
        .ready(seconds_ready)
    );

    doubleDabble double_dabble_minutes(         //Double Dabble for minutes (0-59), this module is for 4 digits, but only 2 are used.
        .bin({8'd0,minutes}),
        .bcd(minutes_bcd),
        .clk(clk),
        .rst(!rst_n),
        .ready(minutes_ready)
    );

    sevenseg4ddriver seg_driver(                //7-Segment Driver for 4 digits
    .clk(clk),
    .rst_n(rst_n),
    .digit0_segments(digit0),
    .digit1_segments(digit1),
    .digit2_segments(digit2),
    .digit3_segments(digit3),
    .segments(seg),
    .anodes(out_sel)
    );

    always @(posedge clk) begin                 //Simple Logic to drive the BCD inputs to the 7-segment decoder
        if(!rst_n) begin
            bcd0 <= 4'd0;                       //Reset all BCD values to 0
            bcd1 <= 4'd0;
            bcd2 <= 4'd0;
            bcd3 <= 4'd0;
        end else begin
            if(seconds_ready) begin             //Only update the BCD values when the double dabble is ready
                bcd0 <= seconds_bcd[3:0];
                bcd1 <= seconds_bcd[7:4];
            end
            if(minutes_ready) begin             //Only update the BCD values when the double dabble is ready
                bcd2 <= minutes_bcd[3:0];
                bcd3 <= minutes_bcd[7:4];
            end
        end
    end


endmodule
