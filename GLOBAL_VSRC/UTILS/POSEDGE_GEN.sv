module POSEDGE_GEN (
    input       logic           [0 : 0]                 clk,

    input       logic           [0 : 0]                 signal,
    output      logic           [0 : 0]                 signal_posedge
);

    logic   [0 : 0]     signal_delay1;
    logic   [0 : 0]     signal_delay2;

    initial begin
        signal_delay1 = 0;
        signal_delay2 = 0;
    end

    always_ff @( posedge clk ) begin
        signal_delay1 <= signal;
        signal_delay2 <= signal_delay1;
    end

    assign signal_posedge = signal_delay1 & ~signal_delay2;

endmodule
