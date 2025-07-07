`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chandrakiran G 
// 
// Create Date: 19.04.2025
// Design Name: UART Module
// Module Name: uart
// Description: Top-level UART design with parameterized transmitter and receiver
//
//////////////////////////////////////////////////////////////////////////////////

module uart #(parameter DWIDTH = 8, PWIDTH = 6, PRESCALE = 8)
(
    input clk_tx,
    input clk_rx,
    input rst,
    input [DWIDTH-1:0] p_data_tx,
    input data_valid_tx,
    input parity_en,
    input parity_type,
    output busy_tx,
    output [DWIDTH-1:0] p_data_rx,
    output data_valid_rx
);

    wire s_data;

    // Transmitter instance
    uart_tx #(DWIDTH) tx (
        .clk(clk_tx),
        .rst(rst),
        .p_data(p_data_tx),
        .data_valid(data_valid_tx),         // ? Fixed this line
        .parity_en(parity_en),
        .parity_type(parity_type),
        .s_data(s_data),
        .busy(busy_tx)
    );

    // Receiver instance
    uart_rx #(DWIDTH, PWIDTH) rx (
        .clk(clk_rx),
        .rst(rst),
        .s_data(s_data),
        .parity_type(parity_type),
        .parity_en(parity_en),
        .prescale(PRESCALE),
        .p_data(p_data_rx),
        .data_valid(data_valid_rx)
    );

endmodule
