`include "common_param.vh"

module MA(
    input  wire        CLK,
    input  wire        RST,
    input  wire [31:0] Result,    // ALU等の結果(アドレス/値)
    input  wire [31:0] Rdata2,    // SW時のストア値
    input  wire [31:0] nextPC,
    input  wire [31:0] Ins,
    output reg  [31:0] Wdata      // 書き戻しデータ
);
    // 内部メモリインスタンス
    wire [31:0] dm_dout;
    reg         dm_we;

    DM dm0 (
        .CLK(CLK),
        .WE(dm_we),
        .addr(Result),
        .din(Rdata2),
        .dout(dm_dout)
    );

    always @(*) begin
        dm_we = 1'b0;
        Wdata = Result;
        case (Ins[31:26])
            LW:  Wdata = dm_dout;   // lw命令時はメモリ値を返す
            SW:  dm_we = 1'b1;      // sw命令時は書き込み
            default: ;
        endcase
    end

endmodule
