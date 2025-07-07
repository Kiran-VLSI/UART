`timescale 1ns / 1ps

module parity_check #(parameter DWIDTH = 8)(
    input clk,
    input rst,
    input parity_type,            // 0 = even, 1 = odd
    input parity_check_en,
    input sampled_bit,            // Received parity bit
    input [DWIDTH-1:0] p_data,    // Received data
    output reg parity_error
);

    reg parity_bit;

    // Combinational parity calculation
    always @(*) begin
        case (parity_type)
            1'b0:    parity_bit = ^p_data;   // Even parity
            1'b1:    parity_bit = ~^p_data;  // Odd parity
            default: parity_bit = 1'b0;
        endcase
    end

    // Sequential error detection logic
    always @(posedge clk or negedge rst) begin
        if (!rst)
            parity_error <= 1'b0;
        else if (parity_check_en)
            parity_error <= (parity_bit != sampled_bit);
    end

endmodule
