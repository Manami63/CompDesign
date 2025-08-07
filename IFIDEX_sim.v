`timescale 1ns/1ps

module IF_ID_EX_tb;

    reg         CLK, RST;
    reg  [31:0] newPC;
    reg  [31:0] W_Ins;
    reg         WE;

    wire [31:0] PC, nextPC, Ins;
    wire [31:0] Rdata1, Rdata2, Ed32;
    wire [31:0] Result_EX, newPC_EX, HI_EX, LO_EX;

    // --- IF部 ---
    IF ifu (
        .CLK(CLK),
        .RST(RST),
        .newPC(newPC),
        .PC(PC),
        .W_Ins(W_Ins),
        .WE(WE),
        .nextPC(nextPC),
        .Ins(Ins)
    );

    // --- ID部 ---
    ID idu (
        .CLK(CLK),
        .RST(RST),
        .Ins(Ins),
        .Wdata(Result_EX),  // 今回はEXの出力をWdataに
        .Rdata1(Rdata1),
        .Rdata2(Rdata2),
        .Ed32(Ed32)
    );

    // --- EX部 ---
    EX exu (
        .CLK(CLK),
        .RST(RST),
        .Ins(Ins),
        .Rdata1(Rdata1),
        .Rdata2(Rdata2),
        .Ed32(Ed32),
        .nextPC(nextPC),
        .Result(Result_EX),
        .newPC(newPC_EX),
        .HI(HI_EX),
        .LO(LO_EX)
    );

    // クロック生成
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

    // テストシナリオ
    initial begin
        $display("==== IF→ID→EX Pipeline テスト開始 ====");
        RST    = 1;
        newPC  = 32'h0;
        W_Ins  = 32'b0;
        WE     = 0;
        #12;
        RST    = 0;

        // 命令書き込みテスト例（直接IMemに書き込む場合）
        // 例: ADD $3, $1, $2 (000000 00001 00010 00011 00000 100000)
        // newPC  = 32'h0;
        // W_Ins  = 32'b000000_00001_00010_00011_00000_100000;
        // WE     = 1;
        // #10;
        // WE     = 0;

        // 命令ROM(IMem.txt)を利用し命令を自動ロード
        // IF→ID→EXを5サイクル分観察
        repeat(10) begin
            #10;
            $display("PC=%h | IF.Ins=%h | R1=%h | R2=%h | Ed32=%h | EX.Result=%h | EX.newPC=%h | HI=%h | LO=%h",
                PC, Ins, Rdata1, Rdata2, Ed32, Result_EX, newPC_EX, HI_EX, LO_EX);
        end

        $display("==== テスト終了 ====");
        $stop;
    end

endmodule

