`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.04.2025 20:50:56
// Design Name: 
// Module Name: data_sampling
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Data Sampling logic for UART RX
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module data_sampling #(parameter PWIDTH = 6)(
    input clk,
    input rst,
    input [PWIDTH-1:0] prescale,
    input [PWIDTH-1:0] edge_counter,
    input data_sampling_en,
    input rx_in,
    output reg sampled_bit
);

    wire [PWIDTH-1:0] num_samples;
    reg [PWIDTH-1:0] counter, ones, zeros;

    assign num_samples = (prescale >> 2) + 1; // 1/4 of prescale + 1

    // Counter for sampling duration
    always @(posedge clk or negedge rst) begin
        if (!rst)
            counter <= 0;
        else if (data_sampling_en) begin
            if ((edge_counter >= num_samples) && (counter != num_samples))
                counter <= counter + 1;
            else
                counter <= 0;
        end
    end

    // Majority Voting Logic
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ones        <= 0;
            zeros       <= 0;
            sampled_bit <= 0;
        end
        else if (data_sampling_en) begin
            if ((edge_counter >= num_samples) && (counter != num_samples)) begin
                if (rx_in)
                    ones <= ones + 1;
                else
                    zeros <= zeros + 1;
            end
            else begin
                if (ones > zeros)
                    sampled_bit <= 1'b1;
                else
                    sampled_bit <= 1'b0;

                ones  <= 0;
                zeros <= 0;
            end
        end
    end

endmodule
