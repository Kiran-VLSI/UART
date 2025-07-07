`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.04.2025 20:58:40
// Design Name: 
// Module Name: start_check
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

 module start_check (clk, rst, sampled_bit, start_check_en, start_error);
    input clk, rst, sampled_bit;
    input start_check_en;
    
    output reg start_error;
    
    always @(posedge clk, negedge rst) begin
        if(!rst)
            start_error <= 1'b0;
    
        else if (start_check_en)
            start_error <= sampled_bit; // if sampled bit is 1 so there is an error
    end
 endmodule
