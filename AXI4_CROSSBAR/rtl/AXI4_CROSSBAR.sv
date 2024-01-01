`include "./include/Interface.sv"

module AXI4_CROSSBAR(
    input       logic                                   clk,
    input       logic                                   rstn,

    // AXI_port

    /* masters */
    AXI4_Master_Interface.port                          axi4_master_interface,

    /* slaves */
    AXI4_Slave_Interface.port                           axi4_slave_interface
);

    // ID extend and simplify
    logic       [`EXTRA_ID_LEN + `W_ID_LEN - 1 : 0]         AWID_extend             [0 : `MASTER_NUM - 1];
    logic       [`EXTRA_ID_LEN + `R_ID_LEN - 1 : 0]         ARID_extend             [0 : `MASTER_NUM - 1];
    logic       [`W_ID_LEN - 1 : 0]                         BID_tail                [0 : `SLAVE_NUM - 1];
    logic       [`R_ID_LEN - 1 : 0]                         RID_tail                [0 : `SLAVE_NUM - 1];
    logic       [`EXTRA_ID_LEN - 1 : 0]                     BID_head                [0 : `SLAVE_NUM - 1];
    logic       [`EXTRA_ID_LEN - 1 : 0]                     RID_head                [0 : `SLAVE_NUM - 1];

    genvar i;
    generate
        for(i = 0; i < `MASTER_NUM; i ++) begin
            assign AWID_extend[i] = {i[`EXTRA_ID_LEN - 1 : 0], axi4_master_interface.AWID[i]};
            assign ARID_extend[i] = {i[`EXTRA_ID_LEN - 1 : 0], axi4_master_interface.ARID[i]};
        end
    endgenerate

    genvar j;
    generate
        for (j = 0; j < `SLAVE_NUM; j ++) begin
            assign {BID_head[j], BID_tail[j]} = axi4_slave_interface.BID[j];
            assign {RID_head[j], RID_tail[j]} = axi4_slave_interface.RID[j];
        end
    endgenerate

    // slave_select
    logic       [`SLAVE_NUM - 1 : 0]                        aw_slave_select                 [0 : `MASTER_NUM - 1];
    logic       [`SLAVE_NUM - 1 : 0]                        ar_slave_select                 [0 : `MASTER_NUM - 1];
    logic       [`SLAVE_NUM - 1 : 0]                        w_slave_select                  [0 : `MASTER_NUM - 1];

    logic       [`SLAVE_NUM - 1 : 0]                        aw_slave_select_with_priority   [0 : `MASTER_NUM - 1];
    logic       [`SLAVE_NUM - 1 : 0]                        ar_slave_select_with_priority   [0 : `MASTER_NUM - 1];
    logic       [`SLAVE_NUM - 1 : 0]                        w_slave_select_with_priority    [0 : `MASTER_NUM - 1];

    // w_buf
    logic       [0 : 0]                                     w_buf_empty                     [0 : `MASTER_NUM - 1];
    logic       [0 : 0]                                     w_buf_full                      [0 : `MASTER_NUM - 1];
    logic       [`SLAVE_NUM - 1 : 0]                        w_buf_head_data                 [0 : `MASTER_NUM - 1];

    // master_select
    logic       [`MASTER_NUM - 1 : 0]                       r_master_select                 [0 : `SLAVE_NUM - 1];
    logic       [`MASTER_NUM - 1 : 0]                       b_master_select                 [0 : `SLAVE_NUM - 1];

    logic       [`MASTER_NUM - 1 : 0]                       r_master_select_with_priority   [0 : `SLAVE_NUM - 1];
    logic       [`MASTER_NUM - 1 : 0]                       b_master_select_with_priority   [0 : `SLAVE_NUM - 1];

    // r_buf
    logic       [0 : 0]                                     r_buf_empty                     [0 : (1 << (`EXTRA_ID_LEN + `R_ID_LEN)) - 1];
    logic       [0 : 0]                                     r_buf_full                      [0 : (1 << (`EXTRA_ID_LEN + `R_ID_LEN)) - 1];
    logic       [`SLAVE_NUM - 1 : 0]                        r_buf_head_data                 [0 : (1 << (`EXTRA_ID_LEN + `R_ID_LEN)) - 1];

    // m_priority
    logic       [`MASTER_NUM - 1 : 0]                       m_aw_priority                   [0 : `MASTER_NUM - 1];
    logic       [`MASTER_NUM - 1 : 0]                       m_ar_priority                   [0 : `MASTER_NUM - 1];
    logic       [`MASTER_NUM - 1 : 0]                       m_w_priority                    [0 : `MASTER_NUM - 1];

    // s_priority
    logic [`SLAVE_NUM - 1 : 0] s_r_priority [0 : `SLAVE_NUM - 1];
    logic [`SLAVE_NUM - 1 : 0] s_b_priority [0 : `SLAVE_NUM - 1];


    // m_priority
    PRIORITY_REG #(
        .SENDER_NUM(`MASTER_NUM)
    )
    m_aw_priority_reg
    (
        .clk(clk),
        .rstn(rstn),
        .valid(axi4_master_interface.AWVALID),
        .ready(axi4_master_interface.AWREADY),
        .prio(m_aw_priority)
    );

    PRIORITY_REG #(
        .SENDER_NUM(`MASTER_NUM)
    )
    m_ar_priority_reg
    (
        .clk(clk),
        .rstn(rstn),
        .valid(axi4_master_interface.ARVALID),
        .ready(axi4_master_interface.ARREADY),
        .prio(m_ar_priority)
    );

    PRIORITY_REG #(
        .SENDER_NUM(`MASTER_NUM)
    )
    m_w_priority_reg
    (
        .clk(clk),
        .rstn(rstn),
        .valid(axi4_master_interface.WVALID),
        .ready(axi4_master_interface.WREADY),
        .prio(m_w_priority)
    );

    // s_priority
    PRIORITY_REG #(
        .SENDER_NUM(`SLAVE_NUM)
    )
    s_r_priority_reg
    (
        .clk(clk),
        .rstn(rstn),
        .valid(axi4_slave_interface.RVALID),
        .ready(axi4_slave_interface.RREADY),
        .prio(s_r_priority)
    );

    PRIORITY_REG #(
        .SENDER_NUM(`SLAVE_NUM)
    )
    s_b_priority_reg
    (
        .clk(clk),
        .rstn(rstn),
        .valid(axi4_slave_interface.BVALID),
        .ready(axi4_slave_interface.BREADY),
        .prio(s_b_priority)
    );

    // slave_select regenerate with priority
    SELECT_REGENERATE #(
        .SELECT_WIDTH(`SLAVE_NUM),
        .PRIO_WIDTH(`MASTER_NUM)
    )
    aw_slave_select_regenerate(
        .select(aw_slave_select),
        .prio(m_aw_priority),
        .select_with_priority(aw_slave_select_with_priority)
    );

    SELECT_REGENERATE #(
        .SELECT_WIDTH(`SLAVE_NUM),
        .PRIO_WIDTH(`MASTER_NUM)
    )
    ar_slave_select_regenerate(
        .select(ar_slave_select),
        .prio(m_ar_priority),
        .select_with_priority(ar_slave_select_with_priority)
    );

    SELECT_REGENERATE #(
        .SELECT_WIDTH(`SLAVE_NUM),
        .PRIO_WIDTH(`MASTER_NUM)
    )
    w_slave_select_regenerate(
        .select(w_slave_select),
        .prio(m_w_priority),
        .select_with_priority(w_slave_select_with_priority)
    );

    // master_select regenerate with priority
    SELECT_REGENERATE #(
        .SELECT_WIDTH(`MASTER_NUM),
        .PRIO_WIDTH(`SLAVE_NUM)
    )
    r_master_select_regenerate(
        .select(r_master_select),
        .prio(s_r_priority),
        .select_with_priority(r_master_select_with_priority)
    );

    SELECT_REGENERATE #(
        .SELECT_WIDTH(`MASTER_NUM),
        .PRIO_WIDTH(`SLAVE_NUM)
    )
    b_master_select_regenerate(
        .select(b_master_select),
        .prio(s_b_priority),
        .select_with_priority(b_master_select_with_priority)
    );

    genvar genvar_master_index;
    genvar genvar_slave_index;
    genvar genvar_r_buf_index;

    generate

        // W_BUF
        for (genvar_master_index = 0; genvar_master_index < `MASTER_NUM; genvar_master_index ++) begin

            logic   [0 : 0]     w_buf_enqueue;
            logic   [0 : 0]     w_buf_dequeue;

            assign w_buf_enqueue = axi4_master_interface.AWVALID[genvar_master_index] & axi4_master_interface.AWREADY[genvar_master_index];
            assign w_buf_dequeue = axi4_master_interface.WLAST[genvar_master_index] & axi4_master_interface.WVALID[genvar_master_index] & axi4_master_interface.WREADY[genvar_master_index];

            QUEUE #(
               .WIDTH(`SLAVE_NUM),
               .DEPTH(`W_BUF_DEPTH) 
            )
            w_buf
            (
                .clk(clk),
                .rstn(rstn),
                .en(1'H1),
                .enqueue(w_buf_enqueue),
                .dequeue(w_buf_dequeue),
                .enqueue_data(aw_slave_select[genvar_master_index]),
                .queue_head_data(w_buf_head_data[genvar_master_index]),
                .empty(w_buf_empty[genvar_master_index]),
                .full(w_buf_full[genvar_master_index])
            );
        end

        // R_BUF
        for (genvar_r_buf_index = 0; genvar_r_buf_index < (1 << (`EXTRA_ID_LEN + `R_ID_LEN)); genvar_r_buf_index ++) begin

            logic   [0 : 0]                     r_buf_enqueue;
            logic   [0 : 0]                     r_buf_dequeue;

            logic   [`EXTRA_ID_LEN - 1 : 0]      index_head;
            logic   [`R_ID_LEN - 1 : 0]          index_tail;

            assign index_head = genvar_r_buf_index[`EXTRA_ID_LEN + `R_ID_LEN - 1 : `R_ID_LEN];
            assign index_tail = genvar_r_buf_index[`R_ID_LEN - 1 : 0];

            assign r_buf_enqueue = (axi4_master_interface.ARID[index_head] == index_tail) & axi4_master_interface.ARVALID[index_head] & axi4_master_interface.ARREADY[index_head];
            assign r_buf_dequeue = (axi4_master_interface.RID[index_head] == index_tail) & axi4_master_interface.RLAST[index_head] & axi4_master_interface.RVALID[index_head] & axi4_master_interface.RREADY[index_head];

            QUEUE #(
                .WIDTH(`SLAVE_NUM),
                .DEPTH(`R_BUF_DEPTH)
            )
            r_buf
            (
                .clk(clk),
                .rstn(rstn),
                .en(1'H1),
                .enqueue(r_buf_enqueue),
                .dequeue(r_buf_dequeue),
                .enqueue_data(ar_slave_select[index_head]),
                .queue_head_data(r_buf_head_data[genvar_r_buf_index]),
                .empty(r_buf_empty[genvar_r_buf_index]),
                .full(r_buf_full[genvar_r_buf_index])
            );
        end

        /*master as sender*/

        for (genvar_master_index = 0; genvar_master_index < `MASTER_NUM; genvar_master_index ++) begin

            // slave_select generate (address space)
            ADDRESS_CHECK aw_check(
                .addr(axi4_master_interface.AWADDR[genvar_master_index]),
                .valid(axi4_master_interface.AWVALID[genvar_master_index] & !w_buf_full[genvar_master_index]),
                .res(aw_slave_select[genvar_master_index])
            );

            ADDRESS_CHECK ar_check(
                .addr(axi4_master_interface.ARADDR[genvar_master_index]),
                .valid(axi4_master_interface.ARVALID[genvar_master_index] & !r_buf_full[ARID_extend[genvar_master_index]]),
                .res(ar_slave_select[genvar_master_index])
            );

            assign w_slave_select[genvar_master_index] = (!w_buf_empty[genvar_master_index]) ? w_buf_head_data[genvar_master_index] : 0;

            // AR
            VAL_SIG_GEN_TO_SENDER #(
                .WIDTH(1),
                .NUM(`SLAVE_NUM)
            )
            m_arready_gen
            (
                .signal(axi4_slave_interface.ARREADY),
                .select(ar_slave_select_with_priority[genvar_master_index]),
                .val_sig(axi4_master_interface.ARREADY[genvar_master_index])
            );

            for (genvar_slave_index = 0; genvar_slave_index < `SLAVE_NUM; genvar_slave_index ++) begin
                
                // s_ARID
                VAL_SIG_GEN_TO_RECEIVER #(
                    .WIDTH(`EXTRA_ID_LEN + `R_ID_LEN),
                    .SENDER_NUM(`MASTER_NUM),
                    .RECEIVER_NUM(`SLAVE_NUM),
                    .RECEIVER_CHOSEN(genvar_slave_index)
                )
                s_arid_gen
                (
                    .signal(ARID_extend),
                    .select(ar_slave_select_with_priority),
                    .val_sig(axi4_slave_interface.ARID[genvar_slave_index])
                );

                // s_ARADDR
                VAL_SIG_GEN_TO_RECEIVER #(
                    .WIDTH(`ADDR_WIDTH),
                    .SENDER_NUM(`MASTER_NUM),
                    .RECEIVER_NUM(`SLAVE_NUM),
                    .RECEIVER_CHOSEN(genvar_slave_index)
                )
                s_araddr_gen
                (
                    .signal(axi4_master_interface.ARADDR),
                    .select(ar_slave_select_with_priority),
                    .val_sig(axi4_slave_interface.ARADDR[genvar_slave_index])
                );

                // s_ARLEN
                VAL_SIG_GEN_TO_RECEIVER #(
                    .WIDTH(8),
                    .SENDER_NUM(`MASTER_NUM),
                    .RECEIVER_NUM(`SLAVE_NUM),
                    .RECEIVER_CHOSEN(genvar_slave_index)
                )
                s_arlen_gen
                (
                    .signal(axi4_master_interface.ARLEN),
                    .select(ar_slave_select_with_priority),
                    .val_sig(axi4_slave_interface.ARLEN[genvar_slave_index])
                );

                // s_ARSIZE
                VAL_SIG_GEN_TO_RECEIVER #(
                    .WIDTH(3),
                    .SENDER_NUM(`MASTER_NUM),
                    .RECEIVER_NUM(`SLAVE_NUM),
                    .RECEIVER_CHOSEN(genvar_slave_index)
                )
                s_arsize_gen
                (
                    .signal(axi4_master_interface.ARSIZE),
                    .select(ar_slave_select_with_priority),
                    .val_sig(axi4_slave_interface.ARSIZE[genvar_slave_index])
                );

                // s_ARBURST
                VAL_SIG_GEN_TO_RECEIVER #(
                    .WIDTH(2),
                    .SENDER_NUM(`MASTER_NUM),
                    .RECEIVER_NUM(`SLAVE_NUM),
                    .RECEIVER_CHOSEN(genvar_slave_index)
                )
                s_arburst_gen
                (
                    .signal(axi4_master_interface.ARBURST),
                    .select(ar_slave_select_with_priority),
                    .val_sig(axi4_slave_interface.ARBURST[genvar_slave_index])
                );

                // s_ARLOCK
                VAL_SIG_GEN_TO_RECEIVER #(
                    .WIDTH(2),
                    .SENDER_NUM(`MASTER_NUM),
                    .RECEIVER_NUM(`SLAVE_NUM),
                    .RECEIVER_CHOSEN(genvar_slave_index)
                )
                s_arlock_gen
                (
                    .signal(axi4_master_interface.ARLOCK),
                    .select(ar_slave_select_with_priority),
                    .val_sig(axi4_slave_interface.ARLOCK[genvar_slave_index])
                );

                // s_ARCACHE
                VAL_SIG_GEN_TO_RECEIVER #(
                    .WIDTH(4),
                    .SENDER_NUM(`MASTER_NUM),
                    .RECEIVER_NUM(`SLAVE_NUM),
                    .RECEIVER_CHOSEN(genvar_slave_index)
                )
                s_arcache_gen
                (
                    .signal(axi4_master_interface.ARCACHE),
                    .select(ar_slave_select_with_priority),
                    .val_sig(axi4_slave_interface.ARCACHE[genvar_slave_index])
                );

                // s_ARPROT
                VAL_SIG_GEN_TO_RECEIVER #(
                    .WIDTH(3),
                    .SENDER_NUM(`MASTER_NUM),
                    .RECEIVER_NUM(`SLAVE_NUM),
                    .RECEIVER_CHOSEN(genvar_slave_index)
                )
                s_arport_gen
                (
                    .signal(axi4_master_interface.ARPROT),
                    .select(ar_slave_select_with_priority),
                    .val_sig(axi4_slave_interface.ARPROT[genvar_slave_index])
                );

                // s_ARVALID
                VAL_SIG_GEN_TO_RECEIVER #(
                    .WIDTH(1),
                    .SENDER_NUM(`MASTER_NUM),
                    .RECEIVER_NUM(`SLAVE_NUM),
                    .RECEIVER_CHOSEN(genvar_slave_index)
                )
                s_arvalid_gen
                (
                    .signal(axi4_master_interface.ARVALID),
                    .select(ar_slave_select_with_priority),
                    .val_sig(axi4_slave_interface.ARVALID[genvar_slave_index])
                );

            end

            // AW
            VAL_SIG_GEN_TO_SENDER #(
                .WIDTH(1),
                .NUM(`SLAVE_NUM)
            )
            m_awready_gen
            (
                .signal(axi4_slave_interface.AWREADY),
                .select(aw_slave_select_with_priority[genvar_master_index]),
                .val_sig(axi4_master_interface.AWREADY[genvar_master_index])
            );

            for (genvar_slave_index = 0; genvar_slave_index < `SLAVE_NUM; genvar_slave_index ++) begin

                // s_AWID
                VAL_SIG_GEN_TO_RECEIVER #(
                    .WIDTH(`EXTRA_ID_LEN + `W_ID_LEN),
                    .SENDER_NUM(`MASTER_NUM),
                    .RECEIVER_NUM(`SLAVE_NUM),
                    .RECEIVER_CHOSEN(genvar_slave_index)
                )
                s_awid_gen
                (
                    .signal(AWID_extend),
                    .select(aw_slave_select_with_priority),
                    .val_sig(axi4_slave_interface.AWID[genvar_slave_index])
                );

                // s_AWADDR
                VAL_SIG_GEN_TO_RECEIVER #(
                    .WIDTH(`ADDR_WIDTH),
                    .SENDER_NUM(`MASTER_NUM),
                    .RECEIVER_NUM(`SLAVE_NUM),
                    .RECEIVER_CHOSEN(genvar_slave_index)
                )
                s_awaddr_gen
                (
                    .signal(axi4_master_interface.AWADDR),
                    .select(aw_slave_select_with_priority),
                    .val_sig(axi4_slave_interface.AWADDR[genvar_slave_index])
                );

                // s_AWLEN
                VAL_SIG_GEN_TO_RECEIVER #(
                    .WIDTH(8),
                    .SENDER_NUM(`MASTER_NUM),
                    .RECEIVER_NUM(`SLAVE_NUM),
                    .RECEIVER_CHOSEN(genvar_slave_index)
                )
                s_awlen_gen
                (
                    .signal(axi4_master_interface.AWLEN),
                    .select(aw_slave_select_with_priority),
                    .val_sig(axi4_slave_interface.AWLEN[genvar_slave_index])
                );

                // s_AWSIZE
                VAL_SIG_GEN_TO_RECEIVER #(
                    .WIDTH(3),
                    .SENDER_NUM(`MASTER_NUM),
                    .RECEIVER_NUM(`SLAVE_NUM),
                    .RECEIVER_CHOSEN(genvar_slave_index)
                )
                s_awsize_gen
                (
                    .signal(axi4_master_interface.AWSIZE),
                    .select(aw_slave_select_with_priority),
                    .val_sig(axi4_slave_interface.AWSIZE[genvar_slave_index])
                );

                // s_AWBURST
                VAL_SIG_GEN_TO_RECEIVER #(
                    .WIDTH(2),
                    .SENDER_NUM(`MASTER_NUM),
                    .RECEIVER_NUM(`SLAVE_NUM),
                    .RECEIVER_CHOSEN(genvar_slave_index)
                )
                s_awburst_gen
                (
                    .signal(axi4_master_interface.AWBURST),
                    .select(aw_slave_select_with_priority),
                    .val_sig(axi4_slave_interface.AWBURST[genvar_slave_index])
                );

                // s_AWLOCK
                VAL_SIG_GEN_TO_RECEIVER #(
                    .WIDTH(2),
                    .SENDER_NUM(`MASTER_NUM),
                    .RECEIVER_NUM(`SLAVE_NUM),
                    .RECEIVER_CHOSEN(genvar_slave_index) 
                )
                s_awlock_gen
                (
                    .signal(axi4_master_interface.AWLOCK),
                    .select(aw_slave_select_with_priority),
                    .val_sig(axi4_slave_interface.AWLOCK[genvar_slave_index])
                );

                // s_AWCACHE
                VAL_SIG_GEN_TO_RECEIVER #(
                    .WIDTH(4),
                    .SENDER_NUM(`MASTER_NUM),
                    .RECEIVER_NUM(`SLAVE_NUM),
                    .RECEIVER_CHOSEN(genvar_slave_index) 
                )
                s_awcache_gen
                (
                    .signal(axi4_master_interface.AWCACHE),
                    .select(aw_slave_select_with_priority),
                    .val_sig(axi4_slave_interface.AWCACHE[genvar_slave_index])
                );

                // s_AWPROT
                VAL_SIG_GEN_TO_RECEIVER #(
                    .WIDTH(3),
                    .SENDER_NUM(`MASTER_NUM),
                    .RECEIVER_NUM(`SLAVE_NUM),
                    .RECEIVER_CHOSEN(genvar_slave_index) 
                )
                s_awprot_gen
                (
                    .signal(axi4_master_interface.AWPROT),
                    .select(aw_slave_select_with_priority),
                    .val_sig(axi4_slave_interface.AWPROT[genvar_slave_index])
                );

                // s_AWVALID
                VAL_SIG_GEN_TO_RECEIVER #(
                    .WIDTH(1),
                    .SENDER_NUM(`MASTER_NUM),
                    .RECEIVER_NUM(`SLAVE_NUM),
                    .RECEIVER_CHOSEN(genvar_slave_index)
                )
                s_awvalid_gen
                (
                    .signal(axi4_master_interface.AWVALID),
                    .select(aw_slave_select_with_priority),
                    .val_sig(axi4_slave_interface.AWVALID[genvar_slave_index])
                );

            end

            // W
            VAL_SIG_GEN_TO_SENDER #(
                .WIDTH(1),
                .NUM(`SLAVE_NUM)
            )
            m_wready_gen
            (
                .signal(axi4_slave_interface.WREADY),
                .select(w_slave_select_with_priority[genvar_master_index]),
                .val_sig(axi4_master_interface.WREADY[genvar_master_index])
            );

            for (genvar_slave_index = 0; genvar_slave_index < `SLAVE_NUM; genvar_slave_index ++) begin

                // s_WDATA
                VAL_SIG_GEN_TO_RECEIVER #(
                    .WIDTH(`DATA_WIDTH),
                    .SENDER_NUM(`MASTER_NUM),
                    .RECEIVER_NUM(`SLAVE_NUM),
                    .RECEIVER_CHOSEN(genvar_slave_index)
                )
                s_wdata_gen
                (
                    .signal(axi4_master_interface.WDATA),
                    .select(w_slave_select_with_priority),
                    .val_sig(axi4_slave_interface.WDATA[genvar_slave_index])
                );

                // s_WSTRB
                VAL_SIG_GEN_TO_RECEIVER #(
                    .WIDTH(`DATA_WIDTH/8),
                    .SENDER_NUM(`MASTER_NUM),
                    .RECEIVER_NUM(`SLAVE_NUM),
                    .RECEIVER_CHOSEN(genvar_slave_index)
                )
                s_wstrb_gen
                (
                    .signal(axi4_master_interface.WSTRB),
                    .select(w_slave_select_with_priority),
                    .val_sig(axi4_slave_interface.WSTRB[genvar_slave_index])
                );

                // s_WLAST
                VAL_SIG_GEN_TO_RECEIVER #(
                    .WIDTH(1),
                    .SENDER_NUM(`MASTER_NUM),
                    .RECEIVER_NUM(`SLAVE_NUM),
                    .RECEIVER_CHOSEN(genvar_slave_index)
                )
                s_wlast_gen
                (
                    .signal(axi4_master_interface.WLAST),
                    .select(w_slave_select_with_priority),
                    .val_sig(axi4_slave_interface.WLAST[genvar_slave_index])
                );

                // s_WVALID
                VAL_SIG_GEN_TO_RECEIVER #(
                    .WIDTH(1),
                    .SENDER_NUM(`MASTER_NUM),
                    .RECEIVER_NUM(`SLAVE_NUM),
                    .RECEIVER_CHOSEN(genvar_slave_index)
                )
                s_awvalid_gen
                (
                    .signal(axi4_master_interface.WVALID),
                    .select(w_slave_select_with_priority),
                    .val_sig(axi4_slave_interface.WVALID[genvar_slave_index])
                );

            end
        end


        /*slave as sender*/

        for (genvar_slave_index = 0; genvar_slave_index < `SLAVE_NUM; genvar_slave_index ++) begin

            // master_select generate
            assign r_master_select[genvar_slave_index] = axi4_slave_interface.RVALID[genvar_slave_index] && (r_buf_head_data[axi4_slave_interface.RID[genvar_slave_index]] == (1 << genvar_slave_index)) ? (1 << RID_head[genvar_slave_index]) : 0;
            assign b_master_select[genvar_slave_index] = axi4_slave_interface.BVALID[genvar_slave_index] ? (1 << BID_head[genvar_slave_index]) : 0;

            // R
            VAL_SIG_GEN_TO_SENDER #(
                .WIDTH(1),
                .NUM(`MASTER_NUM)
            )
            s_rready_gen
            (
                .signal(axi4_master_interface.RREADY),
                .select(r_master_select_with_priority[genvar_slave_index]),
                .val_sig(axi4_slave_interface.RREADY[genvar_slave_index])
            );

            for (genvar_master_index = 0; genvar_master_index < `MASTER_NUM; genvar_master_index ++) begin

                // m_RID
                VAL_SIG_GEN_TO_RECEIVER #(
                    .WIDTH(`R_ID_LEN),
                    .SENDER_NUM(`SLAVE_NUM),
                    .RECEIVER_NUM(`MASTER_NUM),
                    .RECEIVER_CHOSEN(genvar_master_index)
                )
                m_rid_gen
                (
                    .signal(RID_tail),
                    .select(r_master_select_with_priority),
                    .val_sig(axi4_master_interface.RID[genvar_master_index])
                );

                // m_RDATA
                VAL_SIG_GEN_TO_RECEIVER #(
                    .WIDTH(`DATA_WIDTH),
                    .SENDER_NUM(`SLAVE_NUM),
                    .RECEIVER_NUM(`MASTER_NUM),
                    .RECEIVER_CHOSEN(genvar_master_index)
                )
                m_rdata_gen
                (
                    .signal(axi4_slave_interface.RDATA),
                    .select(r_master_select_with_priority),
                    .val_sig(axi4_master_interface.RDATA[genvar_master_index])
                );

                // m_RSTRB
                VAL_SIG_GEN_TO_RECEIVER #(
                    .WIDTH(`DATA_WIDTH/8),
                    .SENDER_NUM(`SLAVE_NUM),
                    .RECEIVER_NUM(`MASTER_NUM),
                    .RECEIVER_CHOSEN(genvar_master_index)
                )
                m_rstrb_gen
                (
                    .signal(axi4_slave_interface.RSTRB),
                    .select(r_master_select_with_priority),
                    .val_sig(axi4_master_interface.RSTRB[genvar_master_index])
                );

                // m_RLAST
                VAL_SIG_GEN_TO_RECEIVER #(
                    .WIDTH(1),
                    .SENDER_NUM(`SLAVE_NUM),
                    .RECEIVER_NUM(`MASTER_NUM),
                    .RECEIVER_CHOSEN(genvar_master_index)
                )
                m_rlast_gen
                (
                    .signal(axi4_slave_interface.RLAST),
                    .select(r_master_select_with_priority),
                    .val_sig(axi4_master_interface.RLAST[genvar_master_index])
                );
                // m_RVALID
                VAL_SIG_GEN_TO_RECEIVER #(
                    .WIDTH(1),
                    .SENDER_NUM(`SLAVE_NUM),
                    .RECEIVER_NUM(`MASTER_NUM),
                    .RECEIVER_CHOSEN(genvar_master_index)
                )
                m_rvalid_gen
                (
                    .signal(axi4_slave_interface.RVALID),
                    .select(r_master_select_with_priority),
                    .val_sig(axi4_master_interface.RVALID[genvar_master_index])
                );

            end

            // B
            VAL_SIG_GEN_TO_SENDER #(
                .WIDTH(1),
                .NUM(`MASTER_NUM)
            )
            s_bready_gen
            (
                .signal(axi4_master_interface.BREADY),
                .select(b_master_select_with_priority[genvar_slave_index]),
                .val_sig(axi4_slave_interface.BREADY[genvar_slave_index])
            );

            for (genvar_master_index = 0; genvar_master_index < `MASTER_NUM; genvar_master_index ++) begin
                
                // m_BID
                VAL_SIG_GEN_TO_RECEIVER #(
                    .WIDTH(`W_ID_LEN),
                    .SENDER_NUM(`SLAVE_NUM),
                    .RECEIVER_NUM(`MASTER_NUM),
                    .RECEIVER_CHOSEN(genvar_master_index)
                )
                m_bid_gen
                (
                    .signal(BID_tail),
                    .select(b_master_select_with_priority),
                    .val_sig(axi4_master_interface.BID[genvar_master_index])
                );

                // m_BRESP
                VAL_SIG_GEN_TO_RECEIVER #(
                    .WIDTH(2),
                    .SENDER_NUM(`SLAVE_NUM),
                    .RECEIVER_NUM(`MASTER_NUM),
                    .RECEIVER_CHOSEN(genvar_master_index)
                )
                m_bresp_gen
                (
                    .signal(axi4_slave_interface.BRESP),
                    .select(b_master_select_with_priority),
                    .val_sig(axi4_master_interface.BRESP[genvar_master_index])
                );

                // m_BVALID
                VAL_SIG_GEN_TO_RECEIVER #(
                    .WIDTH(1),
                    .SENDER_NUM(`SLAVE_NUM),
                    .RECEIVER_NUM(`MASTER_NUM),
                    .RECEIVER_CHOSEN(genvar_master_index)
                )
                m_bvalid_gen
                (
                    .signal(axi4_slave_interface.BVALID),
                    .select(b_master_select_with_priority),
                    .val_sig(axi4_master_interface.BVALID[genvar_master_index])
                );

            end
        end
    endgenerate


endmodule
