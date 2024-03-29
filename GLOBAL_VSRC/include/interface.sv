`ifndef _AXI4_INTERFACE_SV_
`define _AXI4_INTERFACE_SV_

`define AXI4_RESP_OKAY      3'b000

interface AXI4_Interface #(
    parameter NUM           = 1,
    parameter ADDR_WIDTH    = 32,
    parameter DATA_WIDTH    = 32,
    parameter W_ID_LEN      = 4,
    parameter R_ID_LEN      = 4
);
    // AW
    logic                       [W_ID_LEN - 1 : 0]                      AWID                [0 : NUM - 1];
    logic                       [ADDR_WIDTH - 1 : 0]                    AWADDR              [0 : NUM - 1];
    logic                       [7 : 0]                                 AWLEN               [0 : NUM - 1];
    logic                       [2 : 0]                                 AWSIZE              [0 : NUM - 1];
    logic                       [1 : 0]                                 AWBURST             [0 : NUM - 1];
    logic                       [1 : 0]                                 AWLOCK              [0 : NUM - 1];
    logic                       [3 : 0]                                 AWCACHE             [0 : NUM - 1];
    logic                       [2 : 0]                                 AWPROT              [0 : NUM - 1];
    logic                       [0 : 0]                                 AWVALID             [0 : NUM - 1];
    logic                       [0 : 0]                                 AWREADY             [0 : NUM - 1];

    // W
    logic                       [DATA_WIDTH - 1 : 0]                    WDATA               [0 : NUM - 1];
    logic                       [DATA_WIDTH/8 - 1: 0]                   WSTRB               [0 : NUM - 1];
    logic                       [0 : 0]                                 WLAST               [0 : NUM - 1];
    logic                       [0 : 0]                                 WVALID              [0 : NUM - 1];
    logic                       [0 : 0]                                 WREADY              [0 : NUM - 1];

    // B
    logic                       [W_ID_LEN - 1 : 0]                      BID                 [0 : NUM - 1];
    logic                       [2 : 0]                                 BRESP               [0 : NUM - 1];
    logic                       [0 : 0]                                 BVALID              [0 : NUM - 1];
    logic                       [0 : 0]                                 BREADY              [0 : NUM - 1];

    // AR
    logic                       [R_ID_LEN - 1 : 0]                      ARID                [0 : NUM - 1];
    logic                       [ADDR_WIDTH - 1 : 0]                    ARADDR              [0 : NUM - 1];
    logic                       [7 : 0]                                 ARLEN               [0 : NUM - 1];
    logic                       [2 : 0]                                 ARSIZE              [0 : NUM - 1];
    logic                       [1 : 0]                                 ARBURST             [0 : NUM - 1];
    logic                       [1 : 0]                                 ARLOCK              [0 : NUM - 1];
    logic                       [3 : 0]                                 ARCACHE             [0 : NUM - 1];
    logic                       [2 : 0]                                 ARPROT              [0 : NUM - 1];
    logic                       [0 : 0]                                 ARVALID             [0 : NUM - 1];
    logic                       [0 : 0]                                 ARREADY             [0 : NUM - 1];

    // R
    logic                       [R_ID_LEN - 1 : 0]                      RID                 [0 : NUM - 1];
    logic                       [DATA_WIDTH - 1 : 0]                    RDATA               [0 : NUM - 1];
    logic                       [DATA_WIDTH/8 - 1 : 0]                  RSTRB               [0 : NUM - 1];
    logic                       [2 : 0]                                 RRESP               [0 : NUM - 1];
    logic                       [0 : 0]                                 RLAST               [0 : NUM - 1];
    logic                       [0 : 0]                                 RVALID              [0 : NUM - 1];
    logic                       [0 : 0]                                 RREADY              [0 : NUM - 1];

modport Master_Interface (
    output          AWID,
    output          AWADDR,
    output          AWLEN,
    output          AWSIZE,
    output          AWBURST,
    output          AWLOCK,
    output          AWCACHE,
    output          AWPROT,
    output          AWVALID,
    input           AWREADY,

    output          WDATA,
    output          WSTRB,
    output          WLAST,
    output          WVALID,
    input           WREADY,

    input           BID,
    input           BRESP,
    input           BVALID,
    output          BREADY,

    output          ARID,
    output          ARADDR,
    output          ARLEN,
    output          ARSIZE,
    output          ARBURST,
    output          ARLOCK,
    output          ARCACHE,
    output          ARPROT,
    output          ARVALID,
    input           ARREADY,

    input           RID,
    input           RDATA,
    input           RSTRB,
    input           RRESP,
    input           RLAST,
    input           RVALID,
    output          RREADY
);

modport Slave_Interface (
    input           AWID,
    input           AWADDR,
    input           AWLEN,
    input           AWSIZE,
    input           AWBURST,
    input           AWLOCK,
    input           AWCACHE,
    input           AWPROT,
    input           AWVALID,
    output          AWREADY,

    input           WDATA,
    input           WSTRB,
    input           WLAST,
    input           WVALID,
    output          WREADY,

    output          BID,
    output          BRESP,
    output          BVALID,
    input           BREADY,

    input           ARID,
    input           ARADDR,
    input           ARLEN,
    input           ARSIZE,
    input           ARBURST,
    input           ARLOCK,
    input           ARCACHE,
    input           ARPROT,
    input           ARVALID,
    output          ARREADY,

    output          RID,
    output          RDATA,
    output          RSTRB,
    output          RRESP,
    output          RLAST,
    output          RVALID,
    input           RREADY
);

endinterface

`endif