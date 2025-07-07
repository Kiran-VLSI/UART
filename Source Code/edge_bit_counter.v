`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.04.2025 20:53:33
// Design Name: UART Receiver
// Module Name: edge_bit_counter
// Description: Generates edge and bit counters for UART frame processing
// 
//////////////////////////////////////////////////////////////////////////////////

module edge_bit_counter #(parameter PWIDTH = 6)(
    input clk,
    input rst,
    input enable,
    input [PWIDTH-1:0] prescale,
    output reg [PWIDTH-2:0] bit_counter,
    output reg [PWIDTH-1:0] edge_counter
);

    wire edge_counter_done;

    // Prescale (e.g., 8) ? edge_counter: 0 to 7 ? done at 8-1
    assign edge_counter_done = (edge_counter == prescale - 1);

    // Edge Counter
    always @(posedge clk or negedge rst) begin
        if (!rst)
            edge_counter <= 0;
        else if (enable) begin
            if (!edge_counter_done)
                edge_counter <= edge_counter + 1;
            else
                edge_counter <= 0;
        end else
            edge_counter <= 0;
    end

    // Bit Counter (only increments when edge_counter done)
    always @(posedge clk or negedge rst) begin
        if (!rst)
            bit_counter <= 0;
        else if (enable && edge_counter_done)
            bit_counter <= bit_counter + 1;
        else if (!enable)
            bit_counter <= 0;
    end

endmodule
