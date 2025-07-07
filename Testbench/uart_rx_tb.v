`timescale 1ns / 1ps

`define TIMEPERIOD 8

module uart_rx_tb;
    // Testbench signals
    reg clk;
    reg rst;
    reg s_data;
    reg parity_type;
    reg parity_en;
    reg [5:0] prescale;
    wire [7:0] p_data;
    wire data_valid;

    // Instantiate UART receiver
    uart_rx #(8, 6) uut (
        .clk(clk),
        .rst(rst),
        .s_data(s_data),
        .parity_type(parity_type),
        .parity_en(parity_en),
        .prescale(prescale),
        .p_data(p_data),
        .data_valid(data_valid)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #(`TIMEPERIOD/2) clk = ~clk;
    end

    // Test sequence
    initial begin
        // Initialize inputs
        rst = 0;
        s_data = 1;
        parity_type = 0;
        parity_en = 0;
        prescale = 8;

        // Apply reset
        #10 rst = 1;
        #(prescale * 2);

        // Test 1: No parity
        parity_en   = 1'b1;
        parity_type = 1'b1;
        send_uart_frame(8'b10101010, 1'b0, 1'b0, 1'b1); // No parity

        #(prescale * 20);

        // Test 2: No parity, different data
        parity_en   = 1'b0;
        parity_type = 1'b1;
        send_uart_frame(8'b01010101, 1'b0, 1'b1, 1'b1); // No parity

        #(prescale * 20);

        // Test 3: With odd parity
        parity_en   = 1'b1;
        parity_type = 1'b1;
        send_uart_frame(8'b10101010, 1'b1, 1'b1, 1'b1); // Odd parity

        #(prescale * 20);

        // Test 4: With even parity
        parity_en   = 1'b1;
        parity_type = 1'b0;
        send_uart_frame(8'b01010101, 1'b1, 1'b0, 1'b1); // Even parity

        #(prescale * 30);

        // End simulation
        $finish;
    end

    // Task to send a UART frame
    task send_uart_frame;
        input [7:0] data;
        input parity_en;
        input parity_type;
        input stop_bit;
        integer i;
        begin
            // Start bit
            s_data = 0;
            #(prescale * `TIMEPERIOD);

            // Data bits (LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                s_data = data[i];
                #(prescale * `TIMEPERIOD);
            end

            // Parity bit (if enabled)
            if (parity_en) begin
                if (parity_type)
                    s_data = ~^data;  // Odd parity
                else
                    s_data = ^data;   // Even parity
                #(prescale * `TIMEPERIOD);
            end

            // Stop bit
            s_data = stop_bit;
            #(prescale * `TIMEPERIOD);

            // Line idle
            s_data = 1;
        end
    endtask

endmodule
