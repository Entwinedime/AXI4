`ifndef _AXI4_UART_SIM_
    `include "../include/config.sv"
    `include "../../../GLOBAL_VSRC/include/interface.sv"
`else
    `include "config.sv"
    `include "interface.sv"
`endif

`define     STATE_WIDTH         3

`define     DISABLED            3'h7
`define     IDLE                3'h0
`define     RECEIVING_START     3'h1
`define     RECEIVING_BITS      3'h2
`define		RECEIVING_END       3'h3

module UART_RX (
    input       logic           [0 : 0]                 clk,
    input       logic           [0 : 0]                 rstn,
    input       logic           [0 : 0]                 en,

    input       logic           [0 : 0]                 uart_rxd,

    output      logic           [0 : 0]                 ready,
    output      logic           [7 : 0]                 data
);

    logic   [`STATE_WIDTH - 1 : 0]              state_current;
    logic   [`STATE_WIDTH - 1 : 0]              state_next;
    logic   [`UART_COUNTER_WIDTH - 1 : 0]       counter;
    logic   [`UART_BIT_COUNTER_WIDTH - 1 : 0]   bit_counter;

    always_ff @( posedge clk ) begin
        if (!rstn) begin
            state_current   <= `DISABLED;
        end
        else begin
            state_current   <= state_next;
        end
    end

    always_comb begin
        state_next  = state_current;
        case(state_current)
            `DISABLED :
                begin
                    state_next      = `IDLE;
                end
            `IDLE :
                begin
                    if(!uart_rxd) begin 
                        state_next  = `RECEIVING_START;
                    end
                end
            `RECEIVING_START :
                begin
                    if(counter == `UART_CLK_DIV / 2) begin
                        state_next  = `RECEIVING_BITS;
                    end
                end
            `RECEIVING_BITS :
                begin
                    if(counter == `UART_CLK_DIV && bit_counter == `UART_BIT_NUM - 1) begin
                        state_next  = `RECEIVING_END;
                    end
                end
            `RECEIVING_END :
                begin
                    if(counter == `UART_CLK_DIV) begin
                        state_next  = `IDLE;
                    end
                end
            default :
                begin
                    state_next      = `DISABLED;
                end
        endcase
    end

    always_ff @( posedge clk ) begin
        case(state_current)
            `DISABLED :
                begin
                    counter         <= 0;
                    bit_counter     <= 0;
                    ready           <= 0;
                    data            <= 0;
                end
            `IDLE :
                begin
                    counter         <= 0;
                end
            `RECEIVING_START :
                begin
                    if(counter == `UART_CLK_DIV / 2) begin
                        counter     <= 0;
                    end
                    else begin
                        counter     <= counter + 1;
                    end
                    ready           <= 0;
                    bit_counter     <= 0;
                end
            `RECEIVING_BITS :
                begin
                    if(counter == `UART_CLK_DIV) begin
                        bit_counter <= bit_counter + 1;
                        counter     <= 0;
                        data        <= {uart_rxd, data[7 : 1]};
                    end
                    else begin
                        counter     <= counter + 1;
                    end
                end
            `RECEIVING_END :
                begin
                    if(counter == `UART_CLK_DIV) begin
                        ready       <= uart_rxd;
                        counter     <= 0;
                    end
                    else begin
                        counter     <= counter + 1;
                    end
                end
            default :
                begin
                    counter         <= 0;
                    bit_counter     <= 0;
                    ready           <= 0;
                    data            <= 0;
                end
        endcase
    end

endmodule
