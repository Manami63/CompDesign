`timescale 1ns / 1ps
`include "common_param.vh"

module MA(
    input  wire        CLK,
    input  wire        RST,
    input  wire [31:0] Ins,
    input  wire [31:0] Addr,    // アドレス/ALU値
    input  wire [31:0] Rdata2,  // ストア時の書き込み値
    input  wire [31:0] RamData, // RAMの出力値
    output reg  [31:0] MemWdata, // メモリ書き込みデータ
    output reg         MemWE,    // メモリ書き込みイネーブル
    output reg  [31:0] Result    // メモリアクセスまたはALU出力
);

    always @(*) begin
        MemWE = 1'b0;
        MemWdata = 32'd0;
        Result = Addr; // デフォルト

        case (Ins[31:26])
            LW: begin
                Result = RamData;
            end
            SW: begin
                MemWE = 1'b1;
                MemWdata = Rdata2;
            end
            default: Result = Addr;
        endcase
    end
endmodule
