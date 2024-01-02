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

`endif