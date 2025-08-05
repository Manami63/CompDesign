module MA(
    input  wire        CLK,
    input  wire        RST,
    input  wire [31:0] ALUin,
    input  wire [31:0] RegB,
    input  wire        MemWrite,
    input  wire        MemRead,
    output wire [31:0] Dout
);
    wire [4:0] addr = ALUin[6:2]; // 32語=5bit

    // DM（データメモリ）インスタンス
    DM dmem (
        .CLK(CLK),
        .A(addr),
        .WD(RegB),
        .WE(MemWrite),
        .RD(Dout)
    );
endmodule
