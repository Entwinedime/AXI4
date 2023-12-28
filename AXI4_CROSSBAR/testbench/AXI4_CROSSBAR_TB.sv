`include "../vsrc/include/Interface.sv"
`include "../vsrc/include/config.sv"

module AXI4_CROSSBAR_TB();

    logic       [0 : 0]                             clk;
    logic       [0 : 0]                             rst;

    AXI4_Interface#(.NUM(`MASTER_NUM))              master_interface();
    AXI4_Interface#(.NUM(`SLAVE_NUM))               slave_interface();

    AXI4_CROSSBAR axi4_crossbar(
        .clk                            (clk),
        .rst                            (rst),
        .axi4_master_interface          (master_interface),
        .axi4_slave_interface           (slave_interface)
    );

    // clk
    initial begin
        clk                             = 1'b0;
        forever #5 clk                  = ~clk;
    end

    // rst
    initial begin
        rst                             = 1'b1;
        #10 rst                         = 1'b0;
    end

endmodule