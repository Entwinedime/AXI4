/*
0x00000000 - 0x00004000: Hoot ROM
0x00008000 - 0x00008010: UART
0x00008010 - 0x00008020: IRQ
0x00008020 - 0x00008030: MTIME
0x00008030 - 0x00008040: RST
0x00008040 - 0x00008050: MMU
0x00008050 - 0x00008060: RAM(CTRL)
0x80000000 - 0x88000000: RAM
*/

`ifndef _AXI4_CROSSBAR_SIM_
    `include "../include/config.sv"
    `include "../../../GLOBAL_VSRC/include/interface.sv"
`else
    `include "config.sv"
    `include "interface.sv"
`endif

module SLAVE_ADDRESS_CHECK (
        input       logic                   [31 : 0]                    addr,
        input       logic                                               valid,
        output      logic                   [`SLAVE_NUM - 1 : 0]        res
    );

    `ifndef _AXI4_CROSSBAR_SIM_

    always @(*) begin
        if(!valid) res = 8'H0;
        else if(addr < 32'H00004000) res = {1'H1, 7'H0};
        else if(addr >= 32'H00008000 && addr < 32'H00008010) res = {1'H0, 1'H1, 6'H0};
        else if(addr >= 32'H00008010 && addr < 32'H00008020) res = {2'H0, 1'H1, 5'H0};
        else if(addr >= 32'H00008020 && addr < 32'H00008030) res = {3'H0, 1'H1, 4'H0};
        else if(addr >= 32'H00008030 && addr < 32'H00008040) res = {4'H0, 1'H1, 3'H0};
        else if(addr >= 32'H00008040 && addr < 32'H00008050) res = {5'H0, 1'H1, 2'H0};
        else if(addr >= 32'H00008050 && addr < 32'H00008060) res = {6'H0, 1'H1, 1'H0};
        else if(addr >= 32'H80000000 && addr < 32'H88000000) res = {7'H0, 1'H1};
        else res = 8'H0;
    end

    `else

    always @(*) begin
        if(!valid) res = 4'H0;
        else if(addr < 32'H00001000) res = {3'H0, 1'H1};
        else if(addr >= 32'H00001000 && addr < 32'H00002000) res = {2'H0, 1'H1, 1'H0};
        else if(addr >= 32'H00002000 && addr < 32'H00003000) res = {1'H0, 1'H1, 2'H0};
        else if(addr >= 32'H00003000 && addr < 32'H00004000) res = {1'H1, 3'H0};
        else res = 4'H0;
    end

    `endif
    
endmodule
