`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.04.2025 21:00:13
// Design Name: 
// Module Name: stop_check
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


module stop_check (clk, rst, stop_check_en, sampled_bit, stop_error);
    input clk, rst; 
    input stop_check_en; 
    input sampled_bit;
        
    output reg stop_error;
    
    always @(posedge clk, negedge rst) begin
        if(!rst)
            stop_error <= 1'b0;
    
        else if (stop_check_en) begin
        if (!sampled_bit)
            stop_error <= 1'b1;
        else
            stop_error <= 1'b0;
        end
    end
 endmodule    
