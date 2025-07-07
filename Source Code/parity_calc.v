`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.04.2025 20:36:11
// Design Name: 
// Module Name: parity_calc
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

 module parity_calc #(parameter DWIDTH = 8)(clk, rst, data, parity_type, parity_bit);
    input clk, rst;
    input [DWIDTH-1:0]data;
    input parity_type;
    output reg parity_bit;
    
    wire even_parity;
    
    localparam EVEN =0, ODD =1;
        
    assign even_parity = ^data;
    
    always @(posedge clk, negedge rst) begin
        if(!rst) // active low asynch rst
            parity_bit <= 1'b0;
        else begin
            case(parity_type) 
                EVEN:    parity_bit <=  even_parity;
                ODD :    parity_bit <= ~even_parity;
                default: parity_bit <= 1'b0;
            endcase
        end
    end
 endmodule
