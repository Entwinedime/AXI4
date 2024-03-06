`ifndef _CONFIG_SV_
`define _CONFIG_SV_

`ifndef _AXI4_CROSSBAR_SIM_

`define W_ID_LEN        4
`define R_ID_LEN        4

`define ADDR_WIDTH      32
`define DATA_WIDTH      64

`define MASTER_NUM      4
`define SLAVE_NUM       8

`endif

`define EXTRA_ID_LEN    $clog2(`MASTER_NUM)
`define W_BUF_DEPTH     2
`define R_BUF_DEPTH     2

/* -------------------------------------------------------------------------- */
/*                          115200 8N1 UART receiver                          */
/* -------------------------------------------------------------------------- */

`define UART_CLK_FREQ           100000000
`define UART_BAUD_RATE          115200
`define UART_BIT_NUM            8
`define UART_PARITY             0
`define UART_STOP_BIT           1
`define UART_TOTAL_BIT          (`UART_BIT_NUM + `UART_PARITY + `UART_STOP_BIT)

`define UART_CLK_DIV            (`UART_CLK_FREQ / `UART_BAUD_RATE)
`define UART_COUNTER_WIDTH      $clog2(`UART_CLK_DIV)
`define UART_BIT_COUNTER_WIDTH  $clog2(`UART_BIT_NUM)

`define UART_TX_QUEUE_DEPTH     12
`define UART_RX_QUEUE_DEPTH     12

`endif