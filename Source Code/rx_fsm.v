`timescale 1ns / 1ps

module rx_fsm #(parameter PWIDTH = 6)(
    input clk,
    input rst,
    input [PWIDTH-1:0] prescale,
    input [PWIDTH-1:0] edge_counter,
    input [PWIDTH-2:0] bit_counter,
    input rx_in,
    input parity_en,
    input stop_error,
    input start_error,
    input parity_error,
    output reg data_sampling_en,
    output reg deser_en,
    output reg start_check_en,
    output reg stop_check_en,
    output reg parity_check_en,
    output reg enable,
    output reg data_valid
);

    reg [2:0] current_state, next_state;

    localparam IDLE   = 3'd0,
               START  = 3'd1,
               DATA   = 3'd2,
               PARITY = 3'd3,
               STOP   = 3'd4,
               CERROR = 3'd5,
               DVALID = 3'd6;

    // State register
    always @(posedge clk or negedge rst) begin
        if (!rst)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Default assignments
    always @(*) begin
        // Default all outputs to zero
        data_sampling_en = 0;
        deser_en         = 0;
        start_check_en   = 0;
        stop_check_en    = 0;
        parity_check_en  = 0;
        enable           = 0;
        data_valid       = 0;
        next_state       = current_state;

        case (current_state)
            IDLE: begin
                if (!rx_in) begin
                    data_sampling_en = 1;
                    enable           = 1;
                    start_check_en   = 1;
                    next_state       = START;
                end
            end

            START: begin
                data_sampling_en = 1;
                enable           = 1;
                start_check_en   = 1;

                if ((bit_counter == 0) && (edge_counter == prescale - 1)) begin
                    if (!start_error)
                        next_state = DATA;
                    else
                        next_state = IDLE;
                end
            end

            DATA: begin
                data_sampling_en = 1;
                enable           = 1;
                deser_en         = 1;

                if ((bit_counter == 8) && (edge_counter == prescale - 1)) begin
                    if (parity_en)
                        next_state = PARITY;
                    else
                        next_state = STOP;
                end
            end

            PARITY: begin
                data_sampling_en  = 1;
                enable            = 1;
                parity_check_en   = 1;

                if ((bit_counter == 9) && (edge_counter == prescale - 1))
                    next_state = STOP;
            end

            STOP: begin
                data_sampling_en = 1;
                enable           = 1;
                stop_check_en    = 1;

                if ((bit_counter == 10) && (edge_counter == prescale - 1))
                    next_state = CERROR;
            end

            CERROR: begin
                data_sampling_en = 1;

                if (parity_error || stop_error)
                    next_state = IDLE;
                else
                    next_state = DVALID;
            end

            DVALID: begin
                data_valid = 1;
                if (!rx_in)
                    next_state = START;
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule
