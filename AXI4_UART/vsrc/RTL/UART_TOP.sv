/* -------------------------------------------------------------------------- */
/*                          address of UART registers                         */
/* -------------------------------------------------------------------------- */
//  4'h0            tx_data             read & write            tx_data[7 : 0] is the valid data
//  4'h4            rx_data             read only               rx_data[7 : 0] is the valid data
//  4'h8            txrx_queue_status   read only               [0] : tx_queue_empty. [1] : tx_queue_full. [2] : rx_queue_empty. [3] : rx_queue_full.
//  4'hC            txrx_en             read & write            [0] : tx_en. [1] : rx_en.

`ifndef _AXI4_UART_SIM_
    `include "../include/config.sv"
    `include "../../../GLOBAL_VSRC/include/interface.sv"
`else
    `include "config.sv"
    `include "interface.sv"
`endif

module UART_TOP (
    input       logic           [0 : 0]                 clk,
    input       logic           [0 : 0]                 rstn,

    AXI4_Interface.Slave_Interface                      axi4_slave_interface,

    input       logic           [0 : 0]                 uart_rxd,
    output      logic           [0 : 0]                 uart_txd
);

    logic   [0 : 0]                 tx_data;
    logic   [0 : 0]                 tx_dequeue_raw;
    logic   [0 : 0]                 tx_enqueue;
    logic   [0 : 0]                 tx_dequeue;
    logic   [0 : 0]                 tx_queue_empty;
    logic   [0 : 0]                 tx_queue_full;
    logic   [`UART_BIT_NUM - 1 : 0] tx_queue_head_data;

    logic   [0 : 0]                 rx_data;
    logic   [0 : 0]                 rx_enqueue_raw;
    logic   [0 : 0]                 rx_enqueue;
    logic   [0 : 0]                 rx_dequeue;
    logic   [0 : 0]                 rx_queue_empty;
    logic   [0 : 0]                 rx_queue_full;
    logic   [`UART_BIT_NUM - 1 : 0] rx_enqueue_data;
    logic   [`UART_BIT_NUM - 1 : 0] rx_queue_head_data;
    logic   [0 : 0]                 tx_en;
    logic   [0 : 0]                 rx_en;

    logic   [`ADDR_WIDTH - 1 : 0]                   waddr;
    logic   [`EXTRA_ID_LEN + `W_ID_LEN - 1 : 0]     w_channel_id;
    logic   [`ADDR_WIDTH - 1 : 0]                   raddr;
    logic   [`EXTRA_ID_LEN + `R_ID_LEN - 1 : 0]     r_channel_id;

/* ----------------------------- W STATE MACHINE ---------------------------- */

    localparam          STATE_AW    = 2'B00;
    localparam          STATE_W     = 2'B10;
    localparam          STATE_B     = 2'B10;

    logic   [1 : 0]     w_state_current;
    logic   [1 : 0]     w_state_next;

    always_ff @( posedge clk ) begin
        if (!rstn) begin
            w_state_current   <= STATE_AW;
        end
        else begin
            w_state_current   <= w_state_next;
        end
    end

    always_comb begin
        w_state_next = w_state_current;
        case (w_state_current)
            STATE_AW :
                begin
                    if (axi4_slave_interface.AWVALID && axi4_slave_interface.AWREADY) begin
                        w_state_next    = STATE_W;
                    end
                end
            STATE_W :
                begin
                    if (axi4_slave_interface.WVALID && axi4_slave_interface.WREADY) begin
                        w_state_next    = STATE_B;
                    end
                end
            STATE_B :
                begin
                    if (axi4_slave_interface.BVALID && axi4_slave_interface.BREADY) begin
                        w_state_next    = STATE_AW;
                    end
                end
        endcase
    end

/* ----------------------------- AXI4 W Channel ----------------------------- */

    always_ff @( posedge clk) begin
        if (!rstn) begin
            w_channel_id <= 0;
        end
        else if (w_state_current == STATE_AW) begin
            w_channel_id <= axi4_slave_interface.AWID;
        end
    end

    always_comb begin
        case (w_state_current)
            STATE_AW :
                begin
                    axi4_slave_interface.AWREADY = 1'B1;
                end
            default :
                begin
                    axi4_slave_interface.AWREADY = 1'B0;
                end
        endcase
    end

    always_comb begin
        case (w_state_current)
            STATE_W :
                begin
                    axi4_slave_interface.WREADY = ~tx_queue_full;
                end
            default :
                begin
                    axi4_slave_interface.WREADY = 1'B0;
                end
        endcase
    end

    always_comb begin
        case (w_state_current)
            STATE_B :
                begin
                    axi4_slave_interface.BVALID =   1'B1;
                    axi4_slave_interface.BRESP =    `AXI4_RESP_OKAY;
                    axi4_slave_interface.BID =      w_channel_id;
                end
            default :
                begin
                    axi4_slave_interface.BVALID =   1'B0;
                    axi4_slave_interface.BRESP =    `AXI4_RESP_OKAY;
                    axi4_slave_interface.BID =      0;
                end
        endcase
    
    end

/* --------------------------------- UART TX -------------------------------- */

    always_ff @( posedge clk) begin
        if (!rstn) begin
            waddr <= 0;
        end
        else if (w_state_current == STATE_AW) begin
            waddr <= axi4_slave_interface.AWADDR;
        end
    end

    always_ff @( posedge clk) begin
        if (!rstn) begin
            tx_data <= 0;
        end
        else if (w_state_current == STATE_W) begin
            tx_data <= axi4_slave_interface.WDATA;
        end
    end

    always_comb begin
        tx_enqueue = (w_state_current == STATE_W) && (raddr[3 : 2] == 2'H2) && axi4_slave_interface.WVALID && axi4_slave_interface.WREADY;
    end

    POSEDGE_GEN tx_enqueue_gen (
        .clk                (clk),

        .signal             (tx_dequeue_raw),
        .signal_posedge     (tx_dequeue)
    );

    always_ff @( posedge clk) begin
        if (!rstn) begin
            tx_en <= 0;
            rx_en <= 0;
        end
        else if ((w_state_current == STATE_W) && (raddr[3 : 2] == 2'H3) && axi4_slave_interface.WVALID && axi4_slave_interface.WREADY) begin
            rx_en <= axi4_slave_interface.RDATA[0];
            tx_en <= axi4_slave_interface.RDATA[1];
        end
    end 

/* ----------------------------- R STATE MACHINE ---------------------------- */

    localparam          STATE_AR  = 1'B0;
    localparam          STATE_R   = 1'B1;

    logic   [0 : 0]     r_state_current;
    logic   [0 : 0]     r_state_next;

    always_ff @( posedge clk) begin
        if (!rstn) begin
            r_state_current <= STATE_AR;
        end
        else begin
            r_state_current <= r_state_next;
        end
    end

    always_comb begin
        r_state_next = r_state_current;
        case (r_state_current)
            STATE_AR :
                begin
                    if (axi4_slave_interface.ARVALID && axi4_slave_interface.ARREADY) begin
                        r_state_next = STATE_R;
                    end
                end
            STATE_R :
                begin
                    if (axi4_slave_interface.RVALID && axi4_slave_interface.RREADY) begin
                        r_state_next = STATE_AR;
                    end
                end
        endcase
    end

/* ----------------------------- AXI4 R Channel ----------------------------- */

    always_ff @( posedge clk ) begin
        if (!rstn) begin
            r_channel_id <= 0;
        end
        else if (r_state_current == STATE_AR) begin
            r_channel_id <= axi4_slave_interface.ARID;
        end
    end

    always_comb begin
        case (r_state_current)
            STATE_AR :
                begin
                    axi4_slave_interface.ARREADY = 1'B1;
                end
            default :
                begin
                    axi4_slave_interface.ARREADY = 1'B0;
                end
        endcase
    end

    always_comb begin
        case (r_state_current)
            STATE_R :
                begin
                    axi4_slave_interface.RVALID     = 1'B1;
                    axi4_slave_interface.RRESP      = `AXI4_RESP_OKAY;
                    axi4_slave_interface.RID        = r_channel_id;
                end
            default :
                begin
                    axi4_slave_interface.RVALID     = 1'B0;
                    axi4_slave_interface.RRESP      = `AXI4_RESP_OKAY;
                    axi4_slave_interface.RID        = 0;
                end
        endcase
    end

    always_comb begin
        case (r_state_current)
            STATE_R :
                begin
                    case (raddr[3 : 2])
                        2'H0 :
                            axi4_slave_interface.RDATA = tx_data;
                        2'H1 :
                            axi4_slave_interface.RDATA = rx_data;
                        2'H2 :
                            axi4_slave_interface.RDATA = {(`DATA_WIDTH - 4)'(0), rx_queue_full, rx_queue_empty, tx_queue_full, tx_queue_empty};
                        2'H3 :
                            axi4_slave_interface.RDATA = {rx_en, tx_en};
                    endcase
                end
            default :
                begin
                    axi4_slave_interface.RDATA = 0;
                end
        endcase
    end

/* --------------------------------- UART RX -------------------------------- */

    always_ff @( posedge clk) begin
        if (!rstn) begin
            raddr <= 0;
        end
        else if (r_state_current == STATE_AR) begin
            raddr <= axi4_slave_interface.ARADDR;
        end
    end

    assign rx_data = {(`DATA_WIDTH - `UART_BIT_NUM)'(0), rx_queue_head_data};

    always_comb begin
        rx_dequeue = (r_state_current == STATE_R) && (raddr[3 : 2] == 2'H1) && axi4_slave_interface.RVALID && axi4_slave_interface.RREADY;
    end

/* ----------------------------- module generate ---------------------------- */

    UART_TX uart_tx (
        .clk                (clk),
        .rstn               (rstn),
        .en                 (tx_en),

        .uart_txd           (uart_txd),

        .data               (tx_queue_head_data),
        .ready              (!tx_queue_empty),
        .transmitted        (tx_dequeue_raw)
    );

    QUEUE #(
        .WIDTH(`UART_BIT_NUM),
        .DEPTH(`UART_TX_QUEUE_DEPTH)
    )
    tx_queue
    (
        .clk                (clk),
        .rst                (rst),
        .en                 (tx_en),

        .enqueue            (tx_enqueue),
        .dequeue            (tx_dequeue),
        .enqueue_data       (axi4_slave_interface.WDATA[`UART_BIT_NUM - 1 : 0]),
        .queue_head_data    (tx_queue_head_data),

        .empty              (tx_queue_empty),
        .full               (tx_queue_full)
    );

    POSEDGE_GEN tx_dequeue_gen (
        .clk                (clk),

        .signal             (tx_dequeue_raw),
        .signal_posedge     (tx_dequeue)
    );

    UART_RX uart_rx (
        .clk                (clk),
        .rstn               (rstn),
        .en                 (rx_en),

        .uart_rxd           (uart_rxd),

        .ready              (rx_enqueue_raw),
        .data               (rx_enqueue_data)
    );

    QUEUE #(
        .WIDTH(`UART_BIT_NUM),
        .DEPTH(`UART_TX_QUEUE_DEPTH)
    )
    rx_queue
    (
        .clk                (clk),
        .rst                (rst),
        .en                 (rx_en),

        .enqueue            (rx_enqueue),
        .dequeue            (rx_dequeue),
        .enqueue_data       (rx_enqueue_data),
        .queue_head_data    (rx_queue_head_data),

        .empty              (rx_queue_empty),
        .full               (rx_queue_full)
    );

    POSEDGE_GEN rx_enqueue_gen (
        .clk                (clk),

        .signal             (rx_enqueue_raw),
        .signal_posedge     (rx_enqueue)
    );

endmodule
