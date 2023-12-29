module SELECT_REGENERATE #(
        parameter SELECT_WIDTH = 8,
        parameter PRIO_WIDTH = 8
    )
    (
        input       logic       [SELECT_WIDTH - 1 : 0]          select                  [0 : PRIO_WIDTH - 1],
        input       logic       [PRIO_WIDTH - 1 : 0]            prio                    [0 : PRIO_WIDTH - 1],
        output      logic       [SELECT_WIDTH - 1 : 0]          select_with_priority    [0 : PRIO_WIDTH - 1]
    );

    logic [PRIO_WIDTH - 1 : 0] prio_relative    [0 : PRIO_WIDTH - 1][0 : PRIO_WIDTH - 1];
    logic [PRIO_WIDTH - 1 : 0] or_prio_relative [0 : PRIO_WIDTH - 1];

    genvar i;
    genvar j;
    generate

        for (i = 0; i < PRIO_WIDTH; i ++) begin
            for (j = 0; j < PRIO_WIDTH; j ++) begin
                if (i != j) begin
                    assign prio_relative[i][j] = (select[i] == select[j]) ? prio[j] : 0;
                end
                else begin
                    assign prio_relative[i][j] = prio[j];
                end
            end
        end

        for (i = 0; i < PRIO_WIDTH; i ++) begin
            OR #(
                .NUM(PRIO_WIDTH),
                .WIDTH(PRIO_WIDTH)
            )
            sig_or
            (
                .src(prio_relative[i]),
                .res(or_prio_relative[i])
            );

            assign select_with_priority[i] = ((or_prio_relative[i] < (prio[i] << 1)) | prio[i][PRIO_WIDTH - 1]) ? select[i] : 0;
        end

    endgenerate

endmodule
