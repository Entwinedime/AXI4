`include "./config.sv"

interface AXI4_Interface;

    parameter NUM = 0;

    // AW
    logic                       [`W_ID_LEN - 1 : 0]                     AWID                [0 : NUM - 1];
    logic                       [`ADDR_WIDTH - 1 : 0]                   AWADDR              [0 : NUM - 1];
    logic                       [7 : 0]                                 AWLEN               [0 : NUM - 1];
    logic                       [2 : 0]                                 AWSIZE              [0 : NUM - 1];
    logic                       [1 : 0]                                 AWBURST             [0 : NUM - 1];
    logic                       [1 : 0]                                 AWLOCK              [0 : NUM - 1];
    logic                       [3 : 0]                                 AWCACHE             [0 : NUM - 1];
    logic                       [2 : 0]                                 AWPORT              [0 : NUM - 1];
    logic                                                               AWVALID             [0 : NUM - 1];
    logic                                                               AWREADY             [0 : NUM - 1];

    // W
    logic                       [`DATA_WIDTH - 1 : 0]                   WDATA               [0 : NUM - 1];
    logic                       [`DATA_WIDTH/8 - 1: 0]                  WSTRB               [0 : NUM - 1];
    logic                                                               WLAST               [0 : NUM - 1];
    logic                                                               WVALID              [0 : NUM - 1];
    logic                                                               WREADY              [0 : NUM - 1];

    // B
    logic                       [`W_ID_LEN - 1 : 0]                     BID                 [0 : NUM - 1];
    logic                       [1 : 0]                                 BRESP               [0 : NUM - 1];
    logic                                                               BVALID              [0 : NUM - 1];
    logic                                                               BREADY              [0 : NUM - 1];

    // AR
    logic                       [`R_ID_LEN - 1 : 0]                     ARID                [0 : NUM - 1];
    logic                       [`ADDR_WIDTH - 1 : 0]                   ARADDR              [0 : NUM - 1];
    logic                       [7 : 0]                                 ARLEN               [0 : NUM - 1];
    logic                       [2 : 0]                                 ARSIZE              [0 : NUM - 1];
    logic                       [1 : 0]                                 ARBURST             [0 : NUM - 1];
    logic                       [1 : 0]                                 ARLOCK              [0 : NUM - 1];
    logic                       [3 : 0]                                 ARCACHE             [0 : NUM - 1];
    logic                       [2 : 0]                                 ARPORT              [0 : NUM - 1];
    logic                                                               ARVALID             [0 : NUM - 1];
    logic                                                               ARREADY             [0 : NUM - 1];

    // R
    logic                      [`R_ID_LEN - 1 : 0]                      RID                 [0 : NUM - 1];
    logic                      [`DATA_WIDTH - 1 : 0]                    RDATA               [0 : NUM - 1];
    logic                      [`DATA_WIDTH/8 - 1 : 0]                  RSTRB               [0 : NUM - 1];
    logic                                                               RLAST               [0 : NUM - 1];
    logic                                                               RVALID              [0 : NUM - 1];
    logic                                                               RREADY              [0 : NUM - 1];

modport axi4_master_interface (
    input           AWID,
    input           AWADDR,
    input           AWLEN,
    input           AWSIZE,
    input           AWBURST,
    input           AWLOCK,
    input           AWCACHE,
    input           AWPORT,
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
    input           ARPORT,
    input           ARVALID,
    output          ARREADY,

    output          RID,
    output          RDATA,
    output          RSTRB,
    output          RLAST,
    output          RVALID,
    input           RREADY
);

modport axi4_slave_interface (
    output          AWID,
    output          AWADDR,
    output          AWLEN,
    output          AWSIZE,
    output          AWBURST,
    output          AWLOCK,
    output          AWCACHE,
    output          AWPORT,
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
    output          ARPORT,
    output          ARVALID,
    input           ARREADY,

    input           RID,
    input           RDATA,
    input           RSTRB,
    input           RLAST,
    input           RVALID,
    output          RREADY
);

endinterface