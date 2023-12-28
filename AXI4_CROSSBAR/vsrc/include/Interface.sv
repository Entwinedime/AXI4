`include "./config.sv"

interface AXI4_Interface;
    // AW
    logic                       [`W_ID_LEN - 1 : 0]                     AWID    ;
    logic                       [`ADDR_WIDTH - 1 : 0]                   AWADDR  ;
    logic                       [7 : 0]                                 AWLEN   ;
    logic                       [2 : 0]                                 AWSIZE  ;
    logic                       [1 : 0]                                 AWBURST ;
    logic                       [1 : 0]                                 AWLOCK  ;
    logic                       [3 : 0]                                 AWCACHE ;
    logic                       [2 : 0]                                 AWPORT  ;
    logic                                                               AWVALID ;
    logic                                                               AWREADY ;

    // W
    logic                       [`DATA_WIDTH - 1 : 0]                   WDATA   ;
    logic                       [`DATA_WIDTH/8 - 1: 0]                  WSTRB   ;
    logic                                                               WLAST   ;
    logic                                                               WVALID  ;
    logic                                                               WREADY  ;

    // B
    logic                       [`W_ID_LEN - 1 : 0]                     BID     ;
    logic                       [1 : 0]                                 BRESP   ;
    logic                                                               BVALID  ;
    logic                                                               BREADY  ;

    // AR
    logic                       [`R_ID_LEN - 1 : 0]                     ARID    ;
    logic                       [`ADDR_WIDTH - 1 : 0]                   ARADDR  ;
    logic                       [7 : 0]                                 ARLEN   ;
    logic                       [2 : 0]                                 ARSIZE  ;
    logic                       [1 : 0]                                 ARBURST ;
    logic                       [1 : 0]                                 ARLOCK  ;
    logic                       [3 : 0]                                 ARCACHE ;
    logic                       [2 : 0]                                 ARPORT  ;
    logic                                                               ARVALID ;
    logic                                                               ARREADY ;

    // R
    logic                      [`R_ID_LEN - 1 : 0]                      RID     ;
    logic                      [`DATA_WIDTH - 1 : 0]                    RDATA   ;
    logic                      [`DATA_WIDTH/8 - 1 : 0]                  RSTRB   ;
    logic                                                               RLAST   ;
    logic                                                               RVALID  ;
    logic                                                               RREADY  ;

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