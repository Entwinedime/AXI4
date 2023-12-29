/*
0x00000000 - 0x00001000: RAM1
0x00001000 - 0x80002000: RAM2
0x80002000 - 0xC0003000: RAM3
0xC0003000 - 0x00004000: RAM4
*/

module
    ADDRESS_CHECK (
        input       logic                   [31 : 0]        addr,
        input       logic                                   valid,
        output      logic                   [3 : 0]         res
    );

    always @(*) begin
        if(!valid) res = 4'H0;
        else if(addr < 32'H00001000) res = {1'H1, 3'H0};
        else if(addr >= 32'H00001000 && addr < 32'H00002000) res = {1'H0, 1'H1, 2'H0};
        else if(addr >= 32'H00002000 && addr < 32'H00003000) res = {2'H0, 1'H1, 1'H0};
        else if(addr >= 32'H00003000 && addr < 32'H00004000) res = {3'H0, 1'H1};
        else res = 4'H0;
    end
    
endmodule
