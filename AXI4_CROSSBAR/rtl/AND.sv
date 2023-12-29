module AND #(
        parameter NUM = 2,
        parameter WIDTH = 64
    )
    (
        input       logic                       [WIDTH - 1 : 0]         src         [0 : NUM - 1],

        output      logic                       [WIDTH - 1 : 0]         res
    );

    logic                            [WIDTH - 1 : 0]         pres        [0 : NUM - 1]/* verilator split_var */;
    assign pres[0] = src[0];

    genvar i;
    generate
        for(i = 1; i < NUM; i ++) begin
            assign pres[i] = pres[i - 1] & src[i];
        end
    endgenerate

    assign res = pres[NUM - 1];

endmodule
