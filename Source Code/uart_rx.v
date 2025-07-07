`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.04.2025 21:01:52
// Design Name: 
// Module Name: uart_rx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: UART Receiver Top Module
// 
// Dependencies: data_sampling, deserializer, edge_bit_counter, rx_fsm, 
//               start_check, parity_check, stop_check
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module uart_rx #(parameter DWIDTH = 8, PWIDTH = 6)(
    input clk,
    input rst,
    input s_data,
    input parity_type,
    input parity_en,
    input [PWIDTH-1:0] prescale,
    
    output [DWIDTH-1:0] p_data,
    output data_valid
);

    wire data_sampling_en, enable, deser_en;
    wire stop_check_en, start_check_en, parity_check_en;
    wire start_error, stop_error, parity_error;
    wire sampled_bit;
    wire [PWIDTH-1:0] edge_counter;
    wire [PWIDTH-2:0] bit_counter;

    // Data Sampling Module
    data_sampling #(PWIDTH) dsample (
        .clk(clk),
        .rst(rst),
        .prescale(prescale),
        .edge_counter(edge_counter),
        .data_sampling_en(data_sampling_en),
        .rx_in(s_data),
        .sampled_bit(sampled_bit)
    );

    // Deserializer
    deserializer #(DWIDTH, PWIDTH) deser (
        .clk(clk),
        .rst(rst),
        .deser_en(deser_en),
        .sampled_bit(sampled_bit),
        .prescale(prescale),
        .edge_counter(edge_counter),
        .p_data(p_data)
    );

    // Edge & Bit Counter
    edge_bit_counter #(PWIDTH) count (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .prescale(prescale),
        .bit_counter(bit_counter),
        .edge_counter(edge_counter)
    );

    // FSM Controller
    rx_fsm #(PWIDTH) fsm (
        .clk(clk),
        .rst(rst),
        .prescale(prescale),
        .edge_counter(edge_counter),
        .bit_counter(bit_counter),
        .rx_in(s_data),
        .parity_en(parity_en),
        .stop_error(stop_error),
        .start_error(start_error),
        .parity_error(parity_error),
        .data_sampling_en(data_sampling_en),
        .deser_en(deser_en),
        .start_check_en(start_check_en),
        .stop_check_en(stop_check_en),
        .parity_check_en(parity_check_en),
        .enable(enable),
        .data_valid(data_valid)
    );

    // Start Bit Check
    start_check start (
        .clk(clk),
        .rst(rst),
        .sampled_bit(sampled_bit),
        .start_check_en(start_check_en),
        .start_error(start_error)
    );

    // Parity Check
    parity_check #(DWIDTH) parity (
        .clk(clk),
        .rst(rst),
        .parity_type(parity_type),
        .parity_check_en(parity_check_en),
        .sampled_bit(sampled_bit),
        .p_data(p_data),
        .parity_error(parity_error)
    );

    // Stop Bit Check
    stop_check stop (
        .clk(clk),
        .rst(rst),
        .stop_check_en(stop_check_en),
        .sampled_bit(sampled_bit),
        .stop_error(stop_error)
    );

endmodule
