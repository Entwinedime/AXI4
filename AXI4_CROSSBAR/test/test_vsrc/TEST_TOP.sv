`include "./Interface.sv"

module TEST_TOP(
    input           logic                                                               clk,
    input           logic                                                               rstn,

    /* master0 */
        // AW
        input       logic                       [`W_ID_LEN - 1 : 0]                     m_AWID          [0 : `MASTER_NUM - 1],
        input       logic                       [`ADDR_WIDTH - 1 : 0]                   m_AWADDR        [0 : `MASTER_NUM - 1],
        input       logic                       [7 : 0]                                 m_AWLEN         [0 : `MASTER_NUM - 1],
        input       logic                       [2 : 0]                                 m_AWSIZE        [0 : `MASTER_NUM - 1],
        input       logic                       [1 : 0]                                 m_AWBURST       [0 : `MASTER_NUM - 1],
        input       logic                       [1 : 0]                                 m_AWLOCK        [0 : `MASTER_NUM - 1],
        input       logic                       [3 : 0]                                 m_AWCACHE       [0 : `MASTER_NUM - 1],
        input       logic                       [2 : 0]                                 m_AWPROT        [0 : `MASTER_NUM - 1],
        input       logic                                                               m_AWVALID       [0 : `MASTER_NUM - 1],
        output      logic                                                               m_AWREADY       [0 : `MASTER_NUM - 1],

        // W
        input       logic                       [`DATA_WIDTH - 1 : 0]                   m_WDATA         [0 : `MASTER_NUM - 1],
        input       logic                       [`DATA_WIDTH/8 - 1: 0]                  m_WSTRB         [0 : `MASTER_NUM - 1],
        input       logic                                                               m_WLAST         [0 : `MASTER_NUM - 1],
        input       logic                                                               m_WVALID        [0 : `MASTER_NUM - 1],
        output      logic                                                               m_WREADY        [0 : `MASTER_NUM - 1],

        // B
        output      logic                       [`W_ID_LEN - 1 : 0]                     m_BID           [0 : `MASTER_NUM - 1],
        output      logic                       [1 : 0]                                 m_BRESP         [0 : `MASTER_NUM - 1],
        output      logic                                                               m_BVALID        [0 : `MASTER_NUM - 1],
        input       logic                                                               m_BREADY        [0 : `MASTER_NUM - 1],

        // AR
        input       logic                       [`R_ID_LEN - 1 : 0]                     m_ARID          [0 : `MASTER_NUM - 1],
        input       logic                       [`ADDR_WIDTH - 1 : 0]                   m_ARADDR        [0 : `MASTER_NUM - 1],
        input       logic                       [7 : 0]                                 m_ARLEN         [0 : `MASTER_NUM - 1],
        input       logic                       [2 : 0]                                 m_ARSIZE        [0 : `MASTER_NUM - 1],
        input       logic                       [1 : 0]                                 m_ARBURST       [0 : `MASTER_NUM - 1],
        input       logic                       [1 : 0]                                 m_ARLOCK        [0 : `MASTER_NUM - 1],
        input       logic                       [3 : 0]                                 m_ARCACHE       [0 : `MASTER_NUM - 1],
        input       logic                       [2 : 0]                                 m_ARPROT        [0 : `MASTER_NUM - 1],
        input       logic                                                               m_ARVALID       [0 : `MASTER_NUM - 1],
        output      logic                                                               m_ARREADY       [0 : `MASTER_NUM - 1],

        // R
        output      logic                      [`R_ID_LEN - 1 : 0]                      m_RID           [0 : `MASTER_NUM - 1],
        output      logic                      [`DATA_WIDTH - 1 : 0]                    m_RDATA         [0 : `MASTER_NUM - 1],
        output      logic                      [`DATA_WIDTH/8 - 1 : 0]                  m_RSTRB         [0 : `MASTER_NUM - 1],
        output      logic                                                               m_RLAST         [0 : `MASTER_NUM - 1],
        output      logic                                                               m_RVALID        [0 : `MASTER_NUM - 1],
        input       logic                                                               m_RREADY        [0 : `MASTER_NUM - 1],

        /*slaves*/

        // AW
        output      logic                      [`EXTRA_ID_LEN + `W_ID_LEN - 1 : 0]      s_AWID          [0 : `SLAVE_NUM - 1],
        output      logic                      [`ADDR_WIDTH - 1 : 0]                    s_AWADDR        [0 : `SLAVE_NUM - 1],
        output      logic                      [7 : 0]                                  s_AWLEN         [0 : `SLAVE_NUM - 1],
        output      logic                      [2 : 0]                                  s_AWSIZE        [0 : `SLAVE_NUM - 1],
        output      logic                      [1 : 0]                                  s_AWBURST       [0 : `SLAVE_NUM - 1],
        output      logic                      [1 : 0]                                  s_AWLOCK        [0 : `SLAVE_NUM - 1],
        output      logic                      [3 : 0]                                  s_AWCACHE       [0 : `SLAVE_NUM - 1],
        output      logic                      [2 : 0]                                  s_AWPROT        [0 : `SLAVE_NUM - 1],
        output      logic                                                               s_AWVALID       [0 : `SLAVE_NUM - 1],
        input       logic                                                               s_AWREADY       [0 : `SLAVE_NUM - 1],

        // W
        output      logic                       [`DATA_WIDTH - 1 : 0]                   s_WDATA         [0 : `SLAVE_NUM - 1],
        output      logic                       [`DATA_WIDTH/8 - 1 : 0]                 s_WSTRB         [0 : `SLAVE_NUM - 1],
        output      logic                                                               s_WLAST         [0 : `SLAVE_NUM - 1],
        output      logic                                                               s_WVALID        [0 : `SLAVE_NUM - 1],
        input       logic                                                               s_WREADY        [0 : `SLAVE_NUM - 1],

        // B
        input       logic                       [`EXTRA_ID_LEN + `W_ID_LEN - 1 : 0]     s_BID           [0 : `SLAVE_NUM - 1],
        input       logic                       [1 : 0]                                 s_BRESP         [0 : `SLAVE_NUM - 1],
        input       logic                                                               s_BVALID        [0 : `SLAVE_NUM - 1],
        output      logic                                                               s_BREADY        [0 : `SLAVE_NUM - 1],

        // AR
        output      logic                       [`EXTRA_ID_LEN + `R_ID_LEN - 1 : 0]     s_ARID          [0 : `SLAVE_NUM - 1],
        output      logic                       [`ADDR_WIDTH - 1 : 0]                   s_ARADDR        [0 : `SLAVE_NUM - 1],
        output      logic                       [7 : 0]                                 s_ARLEN         [0 : `SLAVE_NUM - 1],
        output      logic                       [2 : 0]                                 s_ARSIZE        [0 : `SLAVE_NUM - 1],
        output      logic                       [1 : 0]                                 s_ARBURST       [0 : `SLAVE_NUM - 1],
        output      logic                       [1 : 0]                                 s_ARLOCK        [0 : `SLAVE_NUM - 1],
        output      logic                       [3 : 0]                                 s_ARCACHE       [0 : `SLAVE_NUM - 1],
        output      logic                       [2 : 0]                                 s_ARPROT        [0 : `SLAVE_NUM - 1],
        output      logic                                                               s_ARVALID       [0 : `SLAVE_NUM - 1],
        input       logic                                                               s_ARREADY       [0 : `SLAVE_NUM - 1],

        // R
        input       logic                       [`EXTRA_ID_LEN + `R_ID_LEN - 1 : 0]     s_RID           [0 : `SLAVE_NUM - 1],
        input       logic                       [`DATA_WIDTH - 1 : 0]                   s_RDATA         [0 : `SLAVE_NUM - 1],
        input       logic                       [`DATA_WIDTH/8 - 1 : 0]                 s_RSTRB         [0 : `SLAVE_NUM - 1],
        input       logic                                                               s_RLAST         [0 : `SLAVE_NUM - 1],
        input       logic                                                               s_RVALID        [0 : `SLAVE_NUM - 1],
        output      logic                                                               s_RREADY        [0 : `SLAVE_NUM - 1]
);

    AXI4_Master_Interface #(.NUM(`MASTER_NUM))      master_interface();
    AXI4_Slave_Interface  #(.NUM(`SLAVE_NUM))       slave_interface();

    AXI4_CROSSBAR crossbar(
        .clk                    (clk),
        .rstn                   (rstn),
        .axi4_master_interface  (master_interface),
        .axi4_slave_interface   (slave_interface)
    );

    genvar genvar_master_index;
    genvar genvar_slave_index;
    generate
        for (genvar_master_index = 0; genvar_master_index < `MASTER_NUM; genvar_master_index ++) begin
            assign master_interface.AWID[genvar_master_index]           = m_AWID[genvar_master_index];
            assign master_interface.AWADDR[genvar_master_index]         = m_AWADDR[genvar_master_index];
            assign master_interface.AWLEN[genvar_master_index]          = m_AWLEN[genvar_master_index];
            assign master_interface.AWSIZE[genvar_master_index]         = m_AWSIZE[genvar_master_index];
            assign master_interface.AWBURST[genvar_master_index]        = m_AWBURST[genvar_master_index];
            assign master_interface.AWLOCK[genvar_master_index]         = m_AWLOCK[genvar_master_index];
            assign master_interface.AWCACHE[genvar_master_index]        = m_AWCACHE[genvar_master_index];
            assign master_interface.AWPROT[genvar_master_index]         = m_AWPROT[genvar_master_index];
            assign master_interface.AWVALID[genvar_master_index]        = m_AWVALID[genvar_master_index];

            assign m_AWREADY[genvar_master_index]       = master_interface.AWREADY[genvar_master_index];

            assign master_interface.WDATA[genvar_master_index]          = m_WDATA[genvar_master_index];
            assign master_interface.WSTRB[genvar_master_index]          = m_WSTRB[genvar_master_index];
            assign master_interface.WLAST[genvar_master_index]          = m_WLAST[genvar_master_index];
            assign master_interface.WVALID[genvar_master_index]         = m_WVALID[genvar_master_index];

            assign m_WREADY[genvar_master_index]        = master_interface.WREADY[genvar_master_index];

            assign m_BID[genvar_master_index]           = master_interface.BID[genvar_master_index];
            assign m_BRESP[genvar_master_index]         = master_interface.BRESP[genvar_master_index];
            assign m_BVALID[genvar_master_index]        = master_interface.BVALID[genvar_master_index];

            assign master_interface.BREADY[genvar_master_index]         = m_BREADY[genvar_master_index];

            assign master_interface.ARID[genvar_master_index]           = m_ARID[genvar_master_index];
            assign master_interface.ARADDR[genvar_master_index]         = m_ARADDR[genvar_master_index];
            assign master_interface.ARLEN[genvar_master_index]          = m_ARLEN[genvar_master_index];
            assign master_interface.ARSIZE[genvar_master_index]         = m_ARSIZE[genvar_master_index];
            assign master_interface.ARBURST[genvar_master_index]        = m_ARBURST[genvar_master_index];
            assign master_interface.ARLOCK[genvar_master_index]         = m_ARLOCK[genvar_master_index];
            assign master_interface.ARCACHE[genvar_master_index]        = m_ARCACHE[genvar_master_index];
            assign master_interface.ARPROT[genvar_master_index]         = m_ARPROT[genvar_master_index];
            assign master_interface.ARVALID[genvar_master_index]        = m_ARVALID[genvar_master_index];

            assign m_ARREADY[genvar_master_index]       = master_interface.ARREADY[genvar_master_index];

            assign m_RID[genvar_master_index]           = master_interface.RID[genvar_master_index];
            assign m_RDATA[genvar_master_index]         = master_interface.RDATA[genvar_master_index];
            assign m_RSTRB[genvar_master_index]         = master_interface.RSTRB[genvar_master_index];
            assign m_RLAST[genvar_master_index]         = master_interface.RLAST[genvar_master_index];
            assign m_RVALID[genvar_master_index]        = master_interface.RVALID[genvar_master_index];

            assign master_interface.RREADY[genvar_master_index]         = m_RREADY[genvar_master_index];
        end

        for (genvar_slave_index = 0; genvar_slave_index < `SLAVE_NUM; genvar_slave_index ++) begin
            assign s_AWID[genvar_slave_index]           = slave_interface.AWID[genvar_slave_index];
            assign s_AWADDR[genvar_slave_index]         = slave_interface.AWADDR[genvar_slave_index];
            assign s_AWLEN[genvar_slave_index]          = slave_interface.AWLEN[genvar_slave_index];
            assign s_AWSIZE[genvar_slave_index]         = slave_interface.AWSIZE[genvar_slave_index];
            assign s_AWBURST[genvar_slave_index]        = slave_interface.AWBURST[genvar_slave_index];
            assign s_AWLOCK[genvar_slave_index]         = slave_interface.AWLOCK[genvar_slave_index];
            assign s_AWCACHE[genvar_slave_index]        = slave_interface.AWCACHE[genvar_slave_index];
            assign s_AWPROT[genvar_slave_index]         = slave_interface.AWPROT[genvar_slave_index];
            assign s_AWVALID[genvar_slave_index]        = slave_interface.AWVALID[genvar_slave_index];

            assign slave_interface.AWREADY[genvar_slave_index]          = s_AWREADY[genvar_slave_index];

            assign s_WDATA[genvar_slave_index]              = slave_interface.WDATA[genvar_slave_index];
            assign s_WSTRB[genvar_slave_index]              = slave_interface.WSTRB[genvar_slave_index];
            assign s_WLAST[genvar_slave_index]              = slave_interface.WLAST[genvar_slave_index];
            assign s_WVALID[genvar_slave_index]             = slave_interface.WVALID[genvar_slave_index];
            
            assign slave_interface.WREADY[genvar_slave_index]           = s_WREADY[genvar_slave_index];

            assign slave_interface.BID[genvar_slave_index]              = s_BID[genvar_slave_index];
            assign slave_interface.BRESP[genvar_slave_index]            = s_BRESP[genvar_slave_index];
            assign slave_interface.BVALID[genvar_slave_index]           = s_BVALID[genvar_slave_index];

            assign s_BREADY[genvar_slave_index]         = slave_interface.BREADY[genvar_slave_index];

            assign s_ARID[genvar_slave_index]               = slave_interface.ARID[genvar_slave_index];
            assign s_ARADDR[genvar_slave_index]             = slave_interface.ARADDR[genvar_slave_index];
            assign s_ARLEN[genvar_slave_index]              = slave_interface.ARLEN[genvar_slave_index];
            assign s_ARSIZE[genvar_slave_index]             = slave_interface.ARSIZE[genvar_slave_index];
            assign s_ARBURST[genvar_slave_index]            = slave_interface.ARBURST[genvar_slave_index];
            assign s_ARLOCK[genvar_slave_index]             = slave_interface.ARLOCK[genvar_slave_index];
            assign s_ARCACHE[genvar_slave_index]            = slave_interface.ARCACHE[genvar_slave_index];
            assign s_ARPROT[genvar_slave_index]             = slave_interface.ARPROT[genvar_slave_index];
            assign s_ARVALID[genvar_slave_index]            = slave_interface.ARVALID[genvar_slave_index];

            assign slave_interface.ARREADY[genvar_slave_index]          = s_ARREADY[genvar_slave_index];

            assign slave_interface.RID[genvar_slave_index]              = s_RID[genvar_slave_index];
            assign slave_interface.RDATA[genvar_slave_index]            = s_RDATA[genvar_slave_index];
            assign slave_interface.RSTRB[genvar_slave_index]            = s_RSTRB[genvar_slave_index];
            assign slave_interface.RLAST[genvar_slave_index]            = s_RLAST[genvar_slave_index];
            assign slave_interface.RVALID[genvar_slave_index]           = s_RVALID[genvar_slave_index];

            assign s_RREADY[genvar_slave_index]         = slave_interface.RREADY[genvar_slave_index];
        end
    endgenerate

endmodule