module PRIORITY_REG #(
        parameter SENDER_NUM = 8
    )
    (
        input           logic               [0 : 0]                         clk,
        input           logic               [0 : 0]                         rstn,
        input           logic               [0 : 0]                         valid       [0 : SENDER_NUM - 1],
        input           logic               [0 : 0]                         ready       [0 : SENDER_NUM - 1],
        output          logic               [SENDER_NUM - 1 : 0]            prio        [0 : SENDER_NUM - 1]
    );

    initial begin
        for (integer i = 0; i < SENDER_NUM; i ++) begin
            prio[i] = (1 << i);
        end
    end

    logic [SENDER_NUM - 1 : 0] need_change_prio [0 : SENDER_NUM - 1];
    logic [SENDER_NUM - 1 : 0] or_need_change_prio;

    OR #(
        .NUM(SENDER_NUM),
        .WIDTH(SENDER_NUM)
    )
    sig_or
    (
        .src(need_change_prio),
        .res(or_need_change_prio)
    );

    genvar i;
    generate
        for (i = 0; i < SENDER_NUM; i ++) begin

            assign need_change_prio[i] = (valid[i] & ready[i]) ? prio[i] : 0;
            
            always @(posedge clk) begin
                if (!rstn) begin
                    prio[i] <= (1 << i);
                end
                else begin
                    if (prio[i] <= or_need_change_prio & or_need_change_prio < (prio[i] << 1)) begin
                        prio[i] <= 1;
                    end
                    else if (prio[i] > or_need_change_prio) begin
                            prio[i] <= prio[i];
                    end
                    else begin
                        if (prio[i][SENDER_NUM - 1]) begin
                            prio[i] <= 1;
                        end
                        else begin
                            prio[i] <= prio[i] << 1;
                        end
                    end
                end
            end

        end
    endgenerate

    
endmodule
