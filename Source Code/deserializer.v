`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.04.2025 20:59:32
// Design Name: 
// Module Name: deserializer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Deserializes incoming serial bits into parallel data
// 
// Dependencies: None
// 
// Revision: 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

module deserializer #(
    parameter DWIDTH = 8, 
    parameter PWIDTH = 6
)(
    input clk, 
    input rst, 
    input deser_en, 
    input sampled_bit,
    input [PWIDTH-1:0] prescale, 
    input [PWIDTH-1:0] edge_counter,
    output reg [DWIDTH-1:0] p_data
);

    reg [$clog2(DWIDTH):0] bit_index;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            p_data    <= 0;
            bit_index <= 0;
        end
        else begin
            if (deser_en && bit_index < DWIDTH && edge_counter == (prescale - 1)) begin
                p_data[bit_index] <= sampled_bit;
                bit_index <= bit_index + 1;
            end

            if (bit_index == DWIDTH)
                bit_index <= 0;
        end
    end

endmodule
