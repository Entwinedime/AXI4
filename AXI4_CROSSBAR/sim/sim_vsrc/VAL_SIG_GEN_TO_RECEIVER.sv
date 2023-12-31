module VAL_SIG_GEN_TO_RECEIVER #(
        parameter WIDTH = 1,
        parameter SENDER_NUM = 8,
        parameter RECEIVER_NUM = 8,
        parameter RECEIVER_CHOSEN = 1
    )
    (
        input       logic           [WIDTH - 1 : 0]                 signal          [0 : SENDER_NUM - 1],
        input       logic           [RECEIVER_NUM - 1 : 0]          select          [0 : SENDER_NUM - 1],
        output      logic           [WIDTH - 1 : 0]                 val_sig
    );

    logic                [WIDTH - 1 : 0]         val_sig_array   [0 : SENDER_NUM - 1]/* verilator split_var */;

    genvar i;
    generate
        for (i = 0; i < SENDER_NUM; i ++) begin
            assign val_sig_array[i] = (select[i][RECEIVER_CHOSEN]) ? signal[i] : 0;
        end
    endgenerate

    OR #(
        .NUM(SENDER_NUM),
        .WIDTH(WIDTH)
    )
    sig_or
    (
        .src(val_sig_array),
        .res(val_sig)
    );

endmodule
