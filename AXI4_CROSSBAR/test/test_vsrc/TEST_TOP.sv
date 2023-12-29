`include "./Interface.sv"

module TEST_TOP(
    input           logic                       [0 : 0]                                 clk,
    input           logic                       [0 : 0]                                 rstn,

    /* master0 */
    // AW
    input           logic                       [`W_ID_LEN - 1 : 0]                     m0_AWID,
    input           logic                       [`ADDR_WIDTH - 1 : 0]                   m0_AWADDR,
    input           logic                       [7 : 0]                                 m0_AWLEN,
    input           logic                       [2 : 0]                                 m0_AWSIZE,
    input           logic                       [1 : 0]                                 m0_AWBURST,
    input           logic                       [1 : 0]                                 m0_AWLOCK,
    input           logic                       [3 : 0]                                 m0_AWCACHE,
    input           logic                       [2 : 0]                                 m0_AWPROT,
    input           logic                       [0 : 0]                                 m0_AWVALID,
    output          logic                       [0 : 0]                                 m0_AWREADY,

    // W
    input           logic                       [`DATA_WIDTH - 1 : 0]                   m0_WDATA,
    input           logic                       [`DATA_WIDTH/8 - 1: 0]                  m0_WSTRB,
    input           logic                       [0 : 0]                                 m0_WLAST,
    input           logic                       [0 : 0]                                 m0_WVALID,
    output          logic                       [0 : 0]                                 m0_WREADY,

    // B
    output          logic                       [`W_ID_LEN - 1 : 0]                     m0_BID,
    output          logic                       [1 : 0]                                 m0_BRESP,
    output          logic                       [0 : 0]                                 m0_BVALID,
    input           logic                       [0 : 0]                                 m0_BREADY,

    // AR
    input           logic                       [`R_ID_LEN - 1 : 0]                     m0_ARID,
    input           logic                       [`ADDR_WIDTH - 1 : 0]                   m0_ARADDR,
    input           logic                       [7 : 0]                                 m0_ARLEN,
    input           logic                       [2 : 0]                                 m0_ARSIZE,
    input           logic                       [1 : 0]                                 m0_ARBURST,
    input           logic                       [1 : 0]                                 m0_ARLOCK,
    input           logic                       [3 : 0]                                 m0_ARCACHE,
    input           logic                       [2 : 0]                                 m0_ARPORT,
    input           logic                       [0 : 0]                                 m0_ARVALID,
    output          logic                       [0 : 0]                                 m0_ARREADY,

    // R
    output          logic                      [`R_ID_LEN - 1 : 0]                      m0_RID,
    output          logic                      [`DATA_WIDTH - 1 : 0]                    m0_RDATA,
    output          logic                      [`DATA_WIDTH/8 - 1 : 0]                  m0_RSTRB,
    output          logic                      [0 : 0]                                  m0_RLAST,
    output          logic                      [0 : 0]                                  m0_RVALID,
    input           logic                      [0 : 0]                                  m0_RREADY,

    /* master1 */
    // AW
    input           logic                       [`W_ID_LEN - 1 : 0]                     m1_AWID,
    input           logic                       [`ADDR_WIDTH - 1 : 0]                   m1_AWADDR,
    input           logic                       [7 : 0]                                 m1_AWLEN,
    input           logic                       [2 : 0]                                 m1_AWSIZE,
    input           logic                       [1 : 0]                                 m1_AWBURST,
    input           logic                       [1 : 0]                                 m1_AWLOCK,
    input           logic                       [3 : 0]                                 m1_AWCACHE,
    input           logic                       [2 : 0]                                 m1_AWPROT,
    input           logic                       [0 : 0]                                 m1_AWVALID,
    output          logic                       [0 : 0]                                 m1_AWREADY,

    // W
    input           logic                       [`DATA_WIDTH - 1 : 0]                   m1_WDATA,
    input           logic                       [`DATA_WIDTH/8 - 1: 0]                  m1_WSTRB,
    input           logic                       [0 : 0]                                 m1_WLAST,
    input           logic                       [0 : 0]                                 m1_WVALID,
    output          logic                       [0 : 0]                                 m1_WREADY,

    // B
    output          logic                       [`W_ID_LEN - 1 : 0]                     m1_BID,
    output          logic                       [1 : 0]                                 m1_BRESP,
    output          logic                       [0 : 0]                                 m1_BVALID,
    input           logic                       [0 : 0]                                 m1_BREADY,

    // AR
    input           logic                       [`R_ID_LEN - 1 : 0]                     m1_ARID,
    input           logic                       [`ADDR_WIDTH - 1 : 0]                   m1_ARADDR,
    input           logic                       [7 : 0]                                 m1_ARLEN,
    input           logic                       [2 : 0]                                 m1_ARSIZE,
    input           logic                       [1 : 0]                                 m1_ARBURST,
    input           logic                       [1 : 0]                                 m1_ARLOCK,
    input           logic                       [3 : 0]                                 m1_ARCACHE,
    input           logic                       [2 : 0]                                 m1_ARPORT,
    input           logic                       [0 : 0]                                 m1_ARVALID,
    output          logic                       [0 : 0]                                 m1_ARREADY,

    // R
    output          logic                      [`R_ID_LEN - 1 : 0]                      m1_RID,
    output          logic                      [`DATA_WIDTH - 1 : 0]                    m1_RDATA,
    output          logic                      [`DATA_WIDTH/8 - 1 : 0]                  m1_RSTRB,
    output          logic                      [0 : 0]                                  m1_RLAST,
    output          logic                      [0 : 0]                                  m1_RVALID,
    input           logic                      [0 : 0]                                  m1_RREADY,

    /* master2 */
    // AW
    input           logic                       [`W_ID_LEN - 1 : 0]                     m2_AWID,
    input           logic                       [`ADDR_WIDTH - 1 : 0]                   m2_AWADDR,
    input           logic                       [7 : 0]                                 m2_AWLEN,
    input           logic                       [2 : 0]                                 m2_AWSIZE,
    input           logic                       [1 : 0]                                 m2_AWBURST,
    input           logic                       [1 : 0]                                 m2_AWLOCK,
    input           logic                       [3 : 0]                                 m2_AWCACHE,
    input           logic                       [2 : 0]                                 m2_AWPROT,
    input           logic                       [0 : 0]                                 m2_AWVALID,
    output          logic                       [0 : 0]                                 m2_AWREADY,

    // W
    input           logic                       [`DATA_WIDTH - 1 : 0]                   m2_WDATA,
    input           logic                       [`DATA_WIDTH/8 - 1: 0]                  m2_WSTRB,
    input           logic                       [0 : 0]                                 m2_WLAST,
    input           logic                       [0 : 0]                                 m2_WVALID,
    output          logic                       [0 : 0]                                 m2_WREADY,

    // B
    output          logic                       [`W_ID_LEN - 1 : 0]                     m2_BID,
    output          logic                       [1 : 0]                                 m2_BRESP,
    output          logic                       [0 : 0]                                 m2_BVALID,
    input           logic                       [0 : 0]                                 m2_BREADY,

    // AR
    input           logic                       [`R_ID_LEN - 1 : 0]                     m2_ARID,
    input           logic                       [`ADDR_WIDTH - 1 : 0]                   m2_ARADDR,
    input           logic                       [7 : 0]                                 m2_ARLEN,
    input           logic                       [2 : 0]                                 m2_ARSIZE,
    input           logic                       [1 : 0]                                 m2_ARBURST,
    input           logic                       [1 : 0]                                 m2_ARLOCK,
    input           logic                       [3 : 0]                                 m2_ARCACHE,
    input           logic                       [2 : 0]                                 m2_ARPORT,
    input           logic                       [0 : 0]                                 m2_ARVALID,
    output          logic                       [0 : 0]                                 m2_ARREADY,

    // R
    output          logic                      [`R_ID_LEN - 1 : 0]                      m2_RID,
    output          logic                      [`DATA_WIDTH - 1 : 0]                    m2_RDATA,
    output          logic                      [`DATA_WIDTH/8 - 1 : 0]                  m2_RSTRB,
    output          logic                      [0 : 0]                                  m2_RLAST,
    output          logic                      [0 : 0]                                  m2_RVALID,
    input           logic                      [0 : 0]                                  m2_RREADY,

    /* master3 */
    // AW
    input           logic                       [`W_ID_LEN - 1 : 0]                     m3_AWID,
    input           logic                       [`ADDR_WIDTH - 1 : 0]                   m3_AWADDR,
    input           logic                       [7 : 0]                                 m3_AWLEN,
    input           logic                       [2 : 0]                                 m3_AWSIZE,
    input           logic                       [1 : 0]                                 m3_AWBURST,
    input           logic                       [1 : 0]                                 m3_AWLOCK,
    input           logic                       [3 : 0]                                 m3_AWCACHE,
    input           logic                       [2 : 0]                                 m3_AWPROT,
    input           logic                       [0 : 0]                                 m3_AWVALID,
    output          logic                       [0 : 0]                                 m3_AWREADY,

    // W
    input           logic                       [`DATA_WIDTH - 1 : 0]                   m3_WDATA,
    input           logic                       [`DATA_WIDTH/8 - 1: 0]                  m3_WSTRB,
    input           logic                       [0 : 0]                                 m3_WLAST,
    input           logic                       [0 : 0]                                 m3_WVALID,
    output          logic                       [0 : 0]                                 m3_WREADY,

    // B
    output          logic                       [`W_ID_LEN - 1 : 0]                     m3_BID,
    output          logic                       [1 : 0]                                 m3_BRESP,
    output          logic                       [0 : 0]                                 m3_BVALID,
    input           logic                       [0 : 0]                                 m3_BREADY,

    // AR
    input           logic                       [`R_ID_LEN - 1 : 0]                     m3_ARID,
    input           logic                       [`ADDR_WIDTH - 1 : 0]                   m3_ARADDR,
    input           logic                       [7 : 0]                                 m3_ARLEN,
    input           logic                       [2 : 0]                                 m3_ARSIZE,
    input           logic                       [1 : 0]                                 m3_ARBURST,
    input           logic                       [1 : 0]                                 m3_ARLOCK,
    input           logic                       [3 : 0]                                 m3_ARCACHE,
    input           logic                       [2 : 0]                                 m3_ARPORT,
    input           logic                       [0 : 0]                                 m3_ARVALID,
    output          logic                       [0 : 0]                                 m3_ARREADY,

    // R
    output          logic                      [`R_ID_LEN - 1 : 0]                      m3_RID,
    output          logic                      [`DATA_WIDTH - 1 : 0]                    m3_RDATA,
    output          logic                      [`DATA_WIDTH/8 - 1 : 0]                  m3_RSTRB,
    output          logic                      [0 : 0]                                  m3_RLAST,
    output          logic                      [0 : 0]                                  m3_RVALID,
    input           logic                      [0 : 0]                                  m3_RREADY,

    /* slave0 */
    // AW
    output          logic                       [`EXTRA_ID_LEN + `W_ID_LEN - 1 : 0]     s0_AWID,
    output          logic                       [`ADDR_WIDTH - 1 : 0]                   s0_AWADDR,
    output          logic                       [7 : 0]                                 s0_AWLEN,
    output          logic                       [2 : 0]                                 s0_AWSIZE,
    output          logic                       [1 : 0]                                 s0_AWBURST,
    output          logic                       [1 : 0]                                 s0_AWLOCK,
    output          logic                       [3 : 0]                                 s0_AWCACHE,
    output          logic                       [2 : 0]                                 s0_AWPROT,
    output          logic                       [0 : 0]                                 s0_AWVALID,
    input           logic                       [0 : 0]                                 s0_AWREADY,

    // W
    output          logic                       [`DATA_WIDTH - 1 : 0]                   s0_WDATA,
    output          logic                       [`DATA_WIDTH/8 - 1: 0]                  s0_WSTRB,
    output          logic                       [0 : 0]                                 s0_WLAST,
    output          logic                       [0 : 0]                                 s0_WVALID,
    input           logic                       [0 : 0]                                 s0_WREADY,

    // B
    input           logic                       [`EXTRA_ID_LEN + `W_ID_LEN - 1 : 0]     s0_BID,
    input           logic                       [1 : 0]                                 s0_BRESP,
    input           logic                       [0 : 0]                                 s0_BVALID,
    output          logic                       [0 : 0]                                 s0_BREADY,

    // AR
    output          logic                       [`EXTRA_ID_LEN + `R_ID_LEN - 1 : 0]     s0_ARID,
    output          logic                       [`ADDR_WIDTH - 1 : 0]                   s0_ARADDR,
    output          logic                       [7 : 0]                                 s0_ARLEN,
    output          logic                       [2 : 0]                                 s0_ARSIZE,
    output          logic                       [1 : 0]                                 s0_ARBURST,
    output          logic                       [1 : 0]                                 s0_ARLOCK,
    output          logic                       [3 : 0]                                 s0_ARCACHE,
    output          logic                       [2 : 0]                                 s0_ARPORT,
    output          logic                       [0 : 0]                                 s0_ARVALID,
    input           logic                       [0 : 0]                                 s0_ARREADY,

    // R
    input           logic                      [`EXTRA_ID_LEN + `R_ID_LEN - 1 : 0]      s0_RID,
    input           logic                      [`DATA_WIDTH - 1 : 0]                    s0_RDATA,
    input           logic                      [`DATA_WIDTH/8 - 1 : 0]                  s0_RSTRB,
    input           logic                      [0 : 0]                                  s0_RLAST,
    input           logic                      [0 : 0]                                  s0_RVALID,
    output          logic                      [0 : 0]                                  s0_RREADY,

    /* slave1 */
    // AW
    output          logic                       [`EXTRA_ID_LEN + `W_ID_LEN - 1 : 0]     s1_AWID,
    output          logic                       [`ADDR_WIDTH - 1 : 0]                   s1_AWADDR,
    output          logic                       [7 : 0]                                 s1_AWLEN,
    output          logic                       [2 : 0]                                 s1_AWSIZE,
    output          logic                       [1 : 0]                                 s1_AWBURST,
    output          logic                       [1 : 0]                                 s1_AWLOCK,
    output          logic                       [3 : 0]                                 s1_AWCACHE,
    output          logic                       [2 : 0]                                 s1_AWPROT,
    output          logic                       [0 : 0]                                 s1_AWVALID,
    input           logic                       [0 : 0]                                 s1_AWREADY,

    // W
    output          logic                       [`DATA_WIDTH - 1 : 0]                   s1_WDATA,
    output          logic                       [`DATA_WIDTH/8 - 1: 0]                  s1_WSTRB,
    output          logic                       [0 : 0]                                 s1_WLAST,
    output          logic                       [0 : 0]                                 s1_WVALID,
    input           logic                       [0 : 0]                                 s1_WREADY,

    // B
    input           logic                       [`EXTRA_ID_LEN + `W_ID_LEN - 1 : 0]     s1_BID,
    input           logic                       [1 : 0]                                 s1_BRESP,
    input           logic                       [0 : 0]                                 s1_BVALID,
    output          logic                       [0 : 0]                                 s1_BREADY,

    // AR
    output          logic                       [`EXTRA_ID_LEN + `R_ID_LEN - 1 : 0]     s1_ARID,
    output          logic                       [`ADDR_WIDTH - 1 : 0]                   s1_ARADDR,
    output          logic                       [7 : 0]                                 s1_ARLEN,
    output          logic                       [2 : 0]                                 s1_ARSIZE,
    output          logic                       [1 : 0]                                 s1_ARBURST,
    output          logic                       [1 : 0]                                 s1_ARLOCK,
    output          logic                       [3 : 0]                                 s1_ARCACHE,
    output          logic                       [2 : 0]                                 s1_ARPORT,
    output          logic                       [0 : 0]                                 s1_ARVALID,
    input           logic                       [0 : 0]                                 s1_ARREADY,

    // R
    input           logic                      [`EXTRA_ID_LEN + `R_ID_LEN - 1 : 0]      s1_RID,
    input           logic                      [`DATA_WIDTH - 1 : 0]                    s1_RDATA,
    input           logic                      [`DATA_WIDTH/8 - 1 : 0]                  s1_RSTRB,
    input           logic                      [0 : 0]                                  s1_RLAST,
    input           logic                      [0 : 0]                                  s1_RVALID,
    output          logic                      [0 : 0]                                  s1_RREADY,

    /* slave2 */
    // AW
    output          logic                       [`EXTRA_ID_LEN + `W_ID_LEN - 1 : 0]     s2_AWID,
    output          logic                       [`ADDR_WIDTH - 1 : 0]                   s2_AWADDR,
    output          logic                       [7 : 0]                                 s2_AWLEN,
    output          logic                       [2 : 0]                                 s2_AWSIZE,
    output          logic                       [1 : 0]                                 s2_AWBURST,
    output          logic                       [1 : 0]                                 s2_AWLOCK,
    output          logic                       [3 : 0]                                 s2_AWCACHE,
    output          logic                       [2 : 0]                                 s2_AWPROT,
    output          logic                       [0 : 0]                                 s2_AWVALID,
    input           logic                       [0 : 0]                                 s2_AWREADY,

    // W
    output          logic                       [`DATA_WIDTH - 1 : 0]                   s2_WDATA,
    output          logic                       [`DATA_WIDTH/8 - 1: 0]                  s2_WSTRB,
    output          logic                       [0 : 0]                                 s2_WLAST,
    output          logic                       [0 : 0]                                 s2_WVALID,
    input           logic                       [0 : 0]                                 s2_WREADY,

    // B
    input           logic                       [`EXTRA_ID_LEN + `W_ID_LEN - 1 : 0]     s2_BID,
    input           logic                       [1 : 0]                                 s2_BRESP,
    input           logic                       [0 : 0]                                 s2_BVALID,
    output          logic                       [0 : 0]                                 s2_BREADY,

    // AR
    output          logic                       [`EXTRA_ID_LEN + `R_ID_LEN - 1 : 0]     s2_ARID,
    output          logic                       [`ADDR_WIDTH - 1 : 0]                   s2_ARADDR,
    output          logic                       [7 : 0]                                 s2_ARLEN,
    output          logic                       [2 : 0]                                 s2_ARSIZE,
    output          logic                       [1 : 0]                                 s2_ARBURST,
    output          logic                       [1 : 0]                                 s2_ARLOCK,
    output          logic                       [3 : 0]                                 s2_ARCACHE,
    output          logic                       [2 : 0]                                 s2_ARPORT,
    output          logic                       [0 : 0]                                 s2_ARVALID,
    input           logic                       [0 : 0]                                 s2_ARREADY,

    // R
    input           logic                      [`EXTRA_ID_LEN + `R_ID_LEN - 1 : 0]      s2_RID,
    input           logic                      [`DATA_WIDTH - 1 : 0]                    s2_RDATA,
    input           logic                      [`DATA_WIDTH/8 - 1 : 0]                  s2_RSTRB,
    input           logic                      [0 : 0]                                  s2_RLAST,
    input           logic                      [0 : 0]                                  s2_RVALID,
    output          logic                      [0 : 0]                                  s2_RREADY,

    /* slave3 */
    // AW
    output          logic                       [`EXTRA_ID_LEN + `W_ID_LEN - 1 : 0]     s3_AWID,
    output          logic                       [`ADDR_WIDTH - 1 : 0]                   s3_AWADDR,
    output          logic                       [7 : 0]                                 s3_AWLEN,
    output          logic                       [2 : 0]                                 s3_AWSIZE,
    output          logic                       [1 : 0]                                 s3_AWBURST,
    output          logic                       [1 : 0]                                 s3_AWLOCK,
    output          logic                       [3 : 0]                                 s3_AWCACHE,
    output          logic                       [2 : 0]                                 s3_AWPROT,
    output          logic                       [0 : 0]                                 s3_AWVALID,
    input           logic                       [0 : 0]                                 s3_AWREADY,

    // W
    output          logic                       [`DATA_WIDTH - 1 : 0]                   s3_WDATA,
    output          logic                       [`DATA_WIDTH/8 - 1: 0]                  s3_WSTRB,
    output          logic                       [0 : 0]                                 s3_WLAST,
    output          logic                       [0 : 0]                                 s3_WVALID,
    input           logic                       [0 : 0]                                 s3_WREADY,

    // B
    input           logic                       [`EXTRA_ID_LEN + `W_ID_LEN - 1 : 0]     s3_BID,
    input           logic                       [1 : 0]                                 s3_BRESP,
    input           logic                       [0 : 0]                                 s3_BVALID,
    output          logic                       [0 : 0]                                 s3_BREADY,

    // AR
    output          logic                       [`EXTRA_ID_LEN + `R_ID_LEN - 1 : 0]     s3_ARID,
    output          logic                       [`ADDR_WIDTH - 1 : 0]                   s3_ARADDR,
    output          logic                       [7 : 0]                                 s3_ARLEN,
    output          logic                       [2 : 0]                                 s3_ARSIZE,
    output          logic                       [1 : 0]                                 s3_ARBURST,
    output          logic                       [1 : 0]                                 s3_ARLOCK,
    output          logic                       [3 : 0]                                 s3_ARCACHE,
    output          logic                       [2 : 0]                                 s3_ARPORT,
    output          logic                       [0 : 0]                                 s3_ARVALID,
    input           logic                       [0 : 0]                                 s3_ARREADY,

    // R
    input           logic                      [`EXTRA_ID_LEN + `R_ID_LEN - 1 : 0]      s3_RID,
    input           logic                      [`DATA_WIDTH - 1 : 0]                    s3_RDATA,
    input           logic                      [`DATA_WIDTH/8 - 1 : 0]                  s3_RSTRB,
    input           logic                      [0 : 0]                                  s3_RLAST,
    input           logic                      [0 : 0]                                  s3_RVALID,
    output          logic                      [0 : 0]                                  s3_RREADY
);

    AXI4_Master_Interface #(.NUM(`MASTER_NUM))      master_interface();
    AXI4_Slave_Interface  #(.NUM(`SLAVE_NUM))       slave_interface();

    AXI4_CROSSBAR crossbar(
        .clk                    (clk),
        .rstn                   (rstn),
        .axi4_master_interface  (master_interface),
        .axi4_slave_interface   (slave_interface)
    );

    assign master_interface.AWID[0] = m0_AWID;
    assign master_interface.AWADDR[0] = m0_AWADDR;
    assign master_interface.AWLEN[0] = m0_AWLEN;
    assign master_interface.AWSIZE[0] = m0_AWSIZE;
    assign master_interface.AWBURST[0] = m0_AWBURST;
    assign master_interface.AWLOCK[0] = m0_AWLOCK;
    assign master_interface.AWCACHE[0] = m0_AWCACHE;
    assign master_interface.AWPROT[0] = m0_AWPROT;
    assign master_interface.AWVALID[0] = m0_AWVALID;
    assign m0_AWREADY = master_interface.AWREADY[0];

    assign master_interface.WDATA[0] = m0_WDATA;
    assign master_interface.WSTRB[0] = m0_WSTRB;
    assign master_interface.WLAST[0] = m0_WLAST;
    assign master_interface.WVALID[0] = m0_WVALID;
    assign m0_WREADY = master_interface.WREADY[0];

    assign m0_BID = master_interface.BID[0];
    assign m0_BRESP = master_interface.BRESP[0];
    assign m0_BVALID = master_interface.BVALID[0];
    assign master_interface.BREADY[0] = m0_BREADY;

    assign master_interface.ARID[0] = m0_ARID;
    assign master_interface.ARADDR[0] = m0_ARADDR;
    assign master_interface.ARLEN[0] = m0_ARLEN;
    assign master_interface.ARPORT[0] = m0_ARPORT;
    assign master_interface.ARVALID[0] = m0_ARVALID;
    assign m0_ARREADY = master_interface.ARREADY[0];

    assign m0_RID = master_interface.RID[0];
    assign m0_RDATA = master_interface.RDATA[0];
    assign m0_RSTRB = master_interface.RSTRB[0];
    assign m0_RLAST = master_interface.RLAST[0];
    assign m0_RVALID = master_interface.RVALID[0];
    assign master_interface.RREADY[0] = m0_RREADY;

    assign master_interface.AWID[1] = m1_AWID;
    assign master_interface.AWADDR[1] = m1_AWADDR;
    assign master_interface.AWLEN[1] = m1_AWLEN;
    assign master_interface.AWSIZE[1] = m1_AWSIZE;
    assign master_interface.AWBURST[1] = m1_AWBURST;
    assign master_interface.AWLOCK[1] = m1_AWLOCK;
    assign master_interface.AWCACHE[1] = m1_AWCACHE;
    assign master_interface.AWPROT[1] = m1_AWPROT;
    assign master_interface.AWVALID[1] = m1_AWVALID;
    assign m1_AWREADY = master_interface.AWREADY[1];

    assign master_interface.WDATA[1] = m1_WDATA;
    assign master_interface.WSTRB[1] = m1_WSTRB;
    assign master_interface.WLAST[1] = m1_WLAST;
    assign master_interface.WVALID[1] = m1_WVALID;
    assign m1_WREADY = master_interface.WREADY[1];

    assign m1_BID = master_interface.BID[1];
    assign m1_BRESP = master_interface.BRESP[1];
    assign m1_BVALID = master_interface.BVALID[1];
    assign master_interface.BREADY[1] = m1_BREADY;

    assign master_interface.ARID[1] = m1_ARID;
    assign master_interface.ARADDR[1] = m1_ARADDR;
    assign master_interface.ARLEN[1] = m1_ARLEN;
    assign master_interface.ARPORT[1] = m1_ARPORT;
    assign master_interface.ARVALID[1] = m1_ARVALID;
    assign m1_ARREADY = master_interface.ARREADY[1];

    assign m1_RID = master_interface.RID[1];
    assign m1_RDATA = master_interface.RDATA[1];
    assign m1_RSTRB = master_interface.RSTRB[1];
    assign m1_RLAST = master_interface.RLAST[1];
    assign m1_RVALID = master_interface.RVALID[1];
    assign master_interface.RREADY[1] = m1_RREADY;

    assign master_interface.AWID[2] = m2_AWID;
    assign master_interface.AWADDR[2] = m2_AWADDR;
    assign master_interface.AWLEN[2] = m2_AWLEN;
    assign master_interface.AWSIZE[2] = m2_AWSIZE;
    assign master_interface.AWBURST[2] = m2_AWBURST;
    assign master_interface.AWLOCK[2] = m2_AWLOCK;
    assign master_interface.AWCACHE[2] = m2_AWCACHE;
    assign master_interface.AWPROT[2] = m2_AWPROT;
    assign master_interface.AWVALID[2] = m2_AWVALID;
    assign m2_AWREADY = master_interface.AWREADY[2];

    assign master_interface.WDATA[2] = m2_WDATA;
    assign master_interface.WSTRB[2] = m2_WSTRB;
    assign master_interface.WLAST[2] = m2_WLAST;
    assign master_interface.WVALID[2] = m2_WVALID;
    assign m2_WREADY = master_interface.WREADY[2];

    assign m2_BID = master_interface.BID[2];
    assign m2_BRESP = master_interface.BRESP[2];
    assign m2_BVALID = master_interface.BVALID[2];
    assign master_interface.BREADY[2] = m2_BREADY;

    assign master_interface.ARID[2] = m2_ARID;
    assign master_interface.ARADDR[2] = m2_ARADDR;
    assign master_interface.ARLEN[2] = m2_ARLEN;
    assign master_interface.ARPORT[2] = m2_ARPORT;
    assign master_interface.ARVALID[2] = m2_ARVALID;
    assign m2_ARREADY = master_interface.ARREADY[2];

    assign m2_RID = master_interface.RID[2];
    assign m2_RDATA = master_interface.RDATA[2];
    assign m2_RSTRB = master_interface.RSTRB[2];
    assign m2_RLAST = master_interface.RLAST[2];
    assign m2_RVALID = master_interface.RVALID[2];
    assign master_interface.RREADY[2] = m2_RREADY;

    assign master_interface.AWID[3] = m3_AWID;
    assign master_interface.AWADDR[3] = m3_AWADDR;
    assign master_interface.AWLEN[3] = m3_AWLEN;

    assign master_interface.AWSIZE[3] = m3_AWSIZE;
    assign master_interface.AWBURST[3] = m3_AWBURST;
    assign master_interface.AWLOCK[3] = m3_AWLOCK;
    assign master_interface.AWCACHE[3] = m3_AWCACHE;
    assign master_interface.AWPROT[3] = m3_AWPROT;
    assign master_interface.AWVALID[3] = m3_AWVALID;
    assign m3_AWREADY = master_interface.AWREADY[3];

    assign master_interface.WDATA[3] = m3_WDATA;
    assign master_interface.WSTRB[3] = m3_WSTRB;
    assign master_interface.WLAST[3] = m3_WLAST;
    assign master_interface.WVALID[3] = m3_WVALID;
    assign m3_WREADY = master_interface.WREADY[3];

    assign m3_BID = master_interface.BID[3];
    assign m3_BRESP = master_interface.BRESP[3];
    assign m3_BVALID = master_interface.BVALID[3];
    assign master_interface.BREADY[3] = m3_BREADY;

    assign master_interface.ARID[3] = m3_ARID;
    assign master_interface.ARADDR[3] = m3_ARADDR;
    assign master_interface.ARLEN[3] = m3_ARLEN;
    assign master_interface.ARPORT[3] = m3_ARPORT;
    assign master_interface.ARVALID[3] = m3_ARVALID;
    assign m3_ARREADY = master_interface.ARREADY[3];

    assign m3_RID = master_interface.RID[3];
    assign m3_RDATA = master_interface.RDATA[3];
    assign m3_RSTRB = master_interface.RSTRB[3];
    assign m3_RLAST = master_interface.RLAST[3];
    assign m3_RVALID = master_interface.RVALID[3];
    assign master_interface.RREADY[3] = m3_RREADY;

    assign s0_AWID = slave_interface.AWID[0];
    assign s0_AWADDR = slave_interface.AWADDR[0];
    assign s0_AWLEN = slave_interface.AWLEN[0];
    assign s0_AWSIZE = slave_interface.AWSIZE[0];
    assign s0_AWBURST = slave_interface.AWBURST[0];
    assign s0_AWLOCK = slave_interface.AWLOCK[0];
    assign s0_AWCACHE = slave_interface.AWCACHE[0];
    assign s0_AWPROT = slave_interface.AWPROT[0];
    assign s0_AWVALID = slave_interface.AWVALID[0];
    assign slave_interface.AWREADY[0] = s0_AWREADY;

    assign s0_WDATA = slave_interface.WDATA[0];
    assign s0_WSTRB = slave_interface.WSTRB[0];
    assign s0_WLAST = slave_interface.WLAST[0];
    assign s0_WVALID = slave_interface.WVALID[0];
    assign slave_interface.WREADY[0] = s0_WREADY;

    assign slave_interface.BID[0] = s0_BID;
    assign slave_interface.BRESP[0] = s0_BRESP;
    assign slave_interface.BVALID[0] = s0_BVALID;
    assign s0_BREADY = slave_interface.BREADY[0];

    assign s0_ARID = slave_interface.ARID[0];
    assign s0_ARADDR = slave_interface.ARADDR[0];
    assign s0_ARLEN = slave_interface.ARLEN[0];
    assign s0_ARPORT = slave_interface.ARPORT[0];
    assign s0_ARVALID = slave_interface.ARVALID[0];
    assign slave_interface.ARREADY[0] = s0_ARREADY;

    assign slave_interface.RID[0] = s0_RID;
    assign slave_interface.RDATA[0] = s0_RDATA;
    assign slave_interface.RSTRB[0] = s0_RSTRB;
    assign slave_interface.RLAST[0] = s0_RLAST;
    assign slave_interface.RVALID[0] = s0_RVALID;
    assign s0_RREADY = slave_interface.RREADY[0];

    assign s1_AWID = slave_interface.AWID[1];
    assign s1_AWADDR = slave_interface.AWADDR[1];
    assign s1_AWLEN = slave_interface.AWLEN[1];
    assign s1_AWSIZE = slave_interface.AWSIZE[1];
    assign s1_AWBURST = slave_interface.AWBURST[1];
    assign s1_AWLOCK = slave_interface.AWLOCK[1];
    assign s1_AWCACHE = slave_interface.AWCACHE[1];
    assign s1_AWPROT = slave_interface.AWPROT[1];
    assign s1_AWVALID = slave_interface.AWVALID[1];
    assign slave_interface.AWREADY[1] = s1_AWREADY;

    assign s1_WDATA = slave_interface.WDATA[1];
    assign s1_WSTRB = slave_interface.WSTRB[1];
    assign s1_WLAST = slave_interface.WLAST[1];
    assign s1_WVALID = slave_interface.WVALID[1];
    assign slave_interface.WREADY[1] = s1_WREADY;

    assign slave_interface.BID[1] = s1_BID;
    assign slave_interface.BRESP[1] = s1_BRESP;
    assign slave_interface.BVALID[1] = s1_BVALID;
    assign s1_BREADY = slave_interface.BREADY[1];

    assign s1_ARID = slave_interface.ARID[1];
    assign s1_ARADDR = slave_interface.ARADDR[1];
    assign s1_ARLEN = slave_interface.ARLEN[1];
    assign s1_ARPORT = slave_interface.ARPORT[1];
    assign s1_ARVALID = slave_interface.ARVALID[1];
    assign slave_interface.ARREADY[1] = s1_ARREADY;

    assign slave_interface.RID[1] = s1_RID;
    assign slave_interface.RDATA[1] = s1_RDATA;
    assign slave_interface.RSTRB[1] = s1_RSTRB;
    assign slave_interface.RLAST[1] = s1_RLAST;
    assign slave_interface.RVALID[1] = s1_RVALID;
    assign s1_RREADY = slave_interface.RREADY[1];

    assign s2_AWID = slave_interface.AWID[2];
    assign s2_AWADDR = slave_interface.AWADDR[2];
    assign s2_AWLEN = slave_interface.AWLEN[2];
    assign s2_AWSIZE = slave_interface.AWSIZE[2];
    assign s2_AWBURST = slave_interface.AWBURST[2];
    assign s2_AWLOCK = slave_interface.AWLOCK[2];
    assign s2_AWCACHE = slave_interface.AWCACHE[2];
    assign s2_AWPROT = slave_interface.AWPROT[2];
    assign s2_AWVALID = slave_interface.AWVALID[2];
    assign slave_interface.AWREADY[2] = s2_AWREADY;

    assign s2_WDATA = slave_interface.WDATA[2];
    assign s2_WSTRB = slave_interface.WSTRB[2];
    assign s2_WLAST = slave_interface.WLAST[2];
    assign s2_WVALID = slave_interface.WVALID[2];
    assign slave_interface.WREADY[2] = s2_WREADY;

    assign slave_interface.BID[2] = s2_BID;
    assign slave_interface.BRESP[2] = s2_BRESP;
    assign slave_interface.BVALID[2] = s2_BVALID;
    assign s2_BREADY = slave_interface.BREADY[2];

    assign s2_ARID = slave_interface.ARID[2];
    assign s2_ARADDR = slave_interface.ARADDR[2];
    assign s2_ARLEN = slave_interface.ARLEN[2];
    assign s2_ARPORT = slave_interface.ARPORT[2];
    assign s2_ARVALID = slave_interface.ARVALID[2];
    assign slave_interface.ARREADY[2] = s2_ARREADY;

    assign slave_interface.RID[2] = s2_RID;
    assign slave_interface.RDATA[2] = s2_RDATA;
    assign slave_interface.RSTRB[2] = s2_RSTRB;
    assign slave_interface.RLAST[2] = s2_RLAST;
    assign slave_interface.RVALID[2] = s2_RVALID;
    assign s2_RREADY = slave_interface.RREADY[2];

    assign s3_AWID = slave_interface.AWID[3];
    assign s3_AWADDR = slave_interface.AWADDR[3];
    assign s3_AWLEN = slave_interface.AWLEN[3];
    assign s3_AWSIZE = slave_interface.AWSIZE[3];
    assign s3_AWBURST = slave_interface.AWBURST[3];
    assign s3_AWLOCK = slave_interface.AWLOCK[3];
    assign s3_AWCACHE = slave_interface.AWCACHE[3];
    assign s3_AWPROT = slave_interface.AWPROT[3];
    assign s3_AWVALID = slave_interface.AWVALID[3];
    assign slave_interface.AWREADY[3] = s3_AWREADY;

    assign s3_WDATA = slave_interface.WDATA[3];
    assign s3_WSTRB = slave_interface.WSTRB[3];
    assign s3_WLAST = slave_interface.WLAST[3];
    assign s3_WVALID = slave_interface.WVALID[3];
    assign slave_interface.WREADY[3] = s3_WREADY;

    assign slave_interface.BID[3] = s3_BID;
    assign slave_interface.BRESP[3] = s3_BRESP;
    assign slave_interface.BVALID[3] = s3_BVALID;
    assign s3_BREADY = slave_interface.BREADY[3];

    assign s3_ARID = slave_interface.ARID[3];
    assign s3_ARADDR = slave_interface.ARADDR[3];
    assign s3_ARLEN = slave_interface.ARLEN[3];
    assign s3_ARPORT = slave_interface.ARPORT[3];
    assign s3_ARVALID = slave_interface.ARVALID[3];
    assign slave_interface.ARREADY[3] = s3_ARREADY;

    assign slave_interface.RID[3] = s3_RID;
    assign slave_interface.RDATA[3] = s3_RDATA;
    assign slave_interface.RSTRB[3] = s3_RSTRB;
    assign slave_interface.RLAST[3] = s3_RLAST;
    assign slave_interface.RVALID[3] = s3_RVALID;
    assign s3_RREADY = slave_interface.RREADY[3];

endmodule