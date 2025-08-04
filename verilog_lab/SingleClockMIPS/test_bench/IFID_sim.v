`timescale 1ns/1ps

module IFID_sim();

  // クロックとリセット信号
  reg CLK;
  reg RST;

  // IFから出る信号
  wire [31:0] PC;
  wire [31:0] nextPC;
  wire [31:0] Ins;

  // IDから出る信号
  wire [31:0] Rdata1, Rdata2, Ed32;

  // 書き込み用信号（テストベンチからは0固定、必要に応じて変更可）
  reg WE = 0;
  reg [31:0] W_Ins = 32'd0;
  reg [31:0] Wdata = 32'd0;

  // IF モジュールのインスタンス
  IF uut_if (
    .CLK(CLK),
    .RST(RST),
    .newPC(32'd0),  // 今回使ってないので0固定
    .PC(PC),
    .W_Ins(W_Ins),
    .WE(WE),
    .nextPC(nextPC),
    .Ins(Ins)
  );

  // ID モジュールのインスタンス
  ID uut_id (
    .CLK(CLK),
    .RST(RST),
    .Ins(Ins),
    .Wdata(Wdata),
    .Rdata1(Rdata1),
    .Rdata2(Rdata2),
    .Ed32(Ed32)
  );

  // クロック生成：周期10ns (100MHz)
  initial begin
    CLK = 0;
    forever #5 CLK = ~CLK;
  end

  // リセットシーケンス
  initial begin
    RST = 1;
    #20;       // 20ns間リセット
    RST = 0;
  end

  // 書き込みデータは今回は使わないので0のまま（必要ならここを改良）
  initial begin
    W_Ins = 32'd0;
    Wdata = 32'd0;
    WE = 0;
  end

  // シミュレーション時間制限（1000nsで終了）
  initial begin
    #1000 $stop;
  end

endmodule
