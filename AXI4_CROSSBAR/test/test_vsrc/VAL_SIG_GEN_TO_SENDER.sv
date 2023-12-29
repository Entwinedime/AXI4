module VAL_SIG_GEN_TO_SENDER #(
        parameter WIDTH = 1,
        parameter NUM = 8
    )
    (
        input       logic           [WIDTH - 1 : 0]         signal          [0 : NUM - 1],
        input       logic           [NUM - 1 : 0]           select                       ,
        output      logic           [WIDTH - 1 : 0]         val_sig
    );

    logic                [WIDTH - 1 : 0]         val_sig_array   [0 : NUM - 1]/* verilator split_var */;

    genvar i;
    generate
        for (i = 0; i < NUM; i ++) begin
            assign val_sig_array[i] = (select[i]) ? signal[i] : 0;
        end
    endgenerate

    OR #(
        .NUM(NUM),
        .WIDTH(WIDTH)
    )
    sig_or
    (
        .src(val_sig_array),
        .res(val_sig)
    );

endmodule
