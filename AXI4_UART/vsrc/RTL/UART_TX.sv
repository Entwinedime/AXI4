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
`define     TRANSMITTING_START  3'h1
`define     TRANSMITTING_BIT    3'h2
`define		TRANSMITTING_END    3'h3

module UART_TX (
    input       logic           [0 : 0]                 clk,
    input       logic           [0 : 0]                 rstn,
    input       logic           [0 : 0]                 en,

    output      logic           [0 : 0]                 uart_txd,

    input       logic           [7 : 0]                 data,
    input       logic           [0 : 0]                 ready,
    output      logic           [0 : 0]                 transmitted
);

    logic   [`STATE_WIDTH - 1 : 0]              state_current;
    logic   [`STATE_WIDTH - 1 : 0]              state_next;
    logic   [`UART_COUNTER_WIDTH - 1 : 0]       counter;
    logic   [`UART_BIT_COUNTER_WIDTH - 1 : 0]   bit_counter;

    always_ff @( posedge clk ) begin
        if (!rstn || !en) begin
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
                    if(ready) begin 
                        state_next  = `TRANSMITTING_START;
                    end
                end
            `TRANSMITTING_START :
                begin
                    if(counter == `UART_CLK_DIV) begin
                        state_next  = `TRANSMITTING_BIT;
                    end
                end
            `TRANSMITTING_BIT :
                begin
                    if(counter == `UART_CLK_DIV && bit_counter == `UART_BIT_NUM - 1) begin
                        state_next  = `TRANSMITTING_END;
                    end
                end
            `TRANSMITTING_END :
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
        if (!rstn || !en) begin
            counter         <= 0;
            bit_counter     <= 0;
            transmitted     <= 0;
        end
        else begin
            case(state_current)
                `DISABLED :
                    begin
                        counter         <= 0;
                        bit_counter     <= 0;
                        transmitted     <= 0;
                    end
                `IDLE :
                    begin
                        counter         <= 0;
                    end
                `TRANSMITTING_START :
                    begin
                        if(counter == `UART_CLK_DIV) begin
                            counter     <= 0;
                        end
                        else begin
                            counter     <= counter + 1;
                        end
                        bit_counter     <= 0;
                    end
                `TRANSMITTING_BIT :
                    begin
                        if(counter == `UART_CLK_DIV) begin
                            bit_counter <= bit_counter + 1;
                            counter     <= 0;
                        end
                        else begin
                            counter     <= counter + 1;
                        end
                    end
                `TRANSMITTING_END :
                    begin
                        if(counter == `UART_CLK_DIV) begin
                            counter     <= 0;
                        end
                        else begin
                            counter     <= counter + 1;
                        end

                        if(counter == 0) begin
                            transmitted <= 1;
                        end
                        else if (counter == `UART_CLK_DIV) begin
                            transmitted <= 0;
                        end
                    end
                default :
                    begin
                        counter         <= 0;
                        bit_counter     <= 0;
                    end
            endcase
        end
    end

    assign uart_txd = state_current == `TRANSMITTING_BIT ? data[bit_counter] : (state_current == `TRANSMITTING_START ? 0 : 1);

endmodule


