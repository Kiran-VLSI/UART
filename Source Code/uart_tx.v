`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.04.2025 20:39:51
// Design Name: 
// Module Name: uart_tx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: UART Transmitter Top Module
// 
// Dependencies: parity_calc, serializer, tx_fsm, mux
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module uart_tx #(parameter DWIDTH = 8)(
    input clk,
    input rst,
    input [DWIDTH-1:0] p_data,
    input data_valid,
    input parity_en,
    input parity_type,
    output s_data,
    output busy
);

    wire parity_bit, ser_en, ser_done, ser_data;
    wire [2:0] mux_sel;

    // Parity calculation block
    parity_calc #(DWIDTH) par_c (
        .clk(clk), 
        .rst(rst), 
        .data(p_data),
        .parity_type(parity_type), 
        .parity_bit(parity_bit)
    );

    // Serializer block
    serializer #(DWIDTH) ser (
        .clk(clk), 
        .rst(rst), 
        .p_data(p_data), 
        .ser_en(ser_en), 
        .s_data(ser_data), 
        .ser_done(ser_done)
    );

    // Transmit FSM
    tx_fsm fsm (
        .clk(clk), 
        .rst(rst), 
        .valid_data(data_valid), 
        .parity_en(parity_en), 
        .ser_done(ser_done), 
        .ser_en(ser_en), 
        .mux_sel(mux_sel), 
        .busy(busy)
    );

    // MUX for selecting start, data, parity, stop bits
    mux m (
        .clk(clk), 
        .rst(rst), 
        .mux_sel(mux_sel), 
        .start_bit(1'b0), 
        .ser_data(ser_data), 
        .parity_bit(parity_bit), 
        .stop_bit(1'b1),
        .tx_out(s_data)
    );

endmodule
