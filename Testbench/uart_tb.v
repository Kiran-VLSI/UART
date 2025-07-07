`timescale 1 ns / 1 ps

 `define TIMEPERIOD 8
 module uart_tb();
    // Parameters
    parameter DWIDTH = 8;
    parameter PWIDTH = 6;
    parameter PRESCALE = 8;
    // Testbench signals
    reg clk_tx;
    reg clk_rx;
    reg rst;
    reg [DWIDTH-1:0] p_data_tx;
    reg data_valid_tx;
    reg parity_en;
    reg parity_type; // 0 for even, 1 for odd
    wire busy_tx;
    wire [DWIDTH-1:0] p_data_rx;
    wire data_valid_rx;
    // Clock generation
    initial begin
        clk_tx = 0;
        forever begin
            #(4*`TIMEPERIOD) clk_tx = ~clk_tx;
                end
                end
    initial begin
              clk_rx = 0;
        forever begin
            #(`TIMEPERIOD/2) clk_rx = ~clk_rx;
        end
    end
    
    // DUT instantiation
    uart #(DWIDTH, PWIDTH, PRESCALE) uut (
        .clk_tx(clk_tx),
        .clk_rx(clk_rx),
        .rst(rst),
        .p_data_tx(p_data_tx),
        .data_valid_tx(data_valid_tx),
        .parity_en(parity_en),
        .parity_type(parity_type),
        .busy_tx(busy_tx),
        .p_data_rx(p_data_rx),
        .data_valid_rx(data_valid_rx)
    );
    // Test sequence
    initial begin
        // Reset
        rst = 0;
        data_valid_tx = 0;
        parity_en = 0;
        parity_type = 0;
        p_data_tx = 0;
        #20 rst = 1;
       
        $display("#########Testing no parity");
        parity_en = 0;
         parity_type = 0;
        p_data_tx = 8'b10101010;
             data_valid_tx = 1;
        #100 data_valid_tx = 0;
       #900;
       $display("Given Data: %h", p_data_rx);
     $display("Received Data: %h\n", p_data_rx);
 $display("###########Testing no parity");
        parity_en = 0;
         parity_type = 0;
        p_data_tx = 8'b01010101;
           data_valid_tx = 1;
        #100 data_valid_tx = 0;
       #900;
       $display("Given Data: %h", p_data_rx);
     $display("Received Data: %h\n", p_data_rx);
     
      $display("###########Testing even parity");
         parity_en = 1;
         parity_type = 0;
        p_data_tx = 8'b10101010;
             data_valid_tx = 1;
        #100 data_valid_tx = 0;
       #900;
          $display("Given Data: %h", p_data_rx);
     $display("Received Data: %h\n", p_data_rx);
     
      $display("########Testing odd parity");
        parity_en = 1;
         parity_type = 1;
        p_data_tx = 8'b01010101;
        data_valid_tx = 1;
        #100 data_valid_tx = 0;
       #900;
       $display("Given Data: %h", p_data_rx);
     $display("Received Data: %h\n", p_data_rx);
        $finish;
    end
 endmodule
