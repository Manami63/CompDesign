`timescale 1ns/1ps

module IFIDEX_sim;

    reg         CLK, RST;
    reg  [31:0] newPC;
    reg  [31:0] W_Ins;
    reg         WE;

    wire [31:0] PC, nextPC, Ins;
    wire [31:0] Rdata1, Rdata2, Ed32;
    wire [31:0] Result_EX, newPC_EX, HI_EX, LO_EX;

    // --- IF（命令フェッチ） ---
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

    // --- ID（デコード） ---
    ID idu (
        .CLK(CLK),
        .RST(RST),
        .Ins(Ins),
        .Wdata(Result_EX),   // EXの結果をレジスタ書き込み値とする
        .Rdata1(Rdata1),
        .Rdata2(Rdata2),
        .Ed32(Ed32)
    );

    // --- EX（実行） ---
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

    // シミュレーションシナリオ
    initial begin
        $display("==== IF→ID→EX Pipeline Simulation ====");
        RST    = 1;
        newPC  = 32'h0;
        W_Ins  = 32'b0;
        WE     = 0;
        #12;
        RST    = 0;

        // 命令の動作確認（IMem.txt利用の場合、WE=1不要・W_Insも不要）
        // 必要があれば初期命令注入用の処理をここに追加

        repeat(20) begin
            #10;
            $display("PC=%h | Ins=%h | R1=%h | R2=%h | Ed32=%h | EX.Result=%h | HI=%h | LO=%h",
                PC, Ins, Rdata1, Rdata2, Ed32, Result_EX, HI_EX, LO_EX
            );
        end

        $display("==== Simulation END ====");
        $stop;
    end

endmodule
