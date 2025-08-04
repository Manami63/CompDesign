`timescale 1ns/1ps

module IF_tb;

  reg CLK;
  reg RST;
  wire [31:0] PC;
  wire [31:0] nextPC;
  wire [31:0] Ins;

  // 未使用だけど接続必須の信号
  reg [31:0] newPC = 0;
  reg [31:0] W_Ins = 32'd0;
  reg WE = 0;  // 書き込みは行わない

  // DUT: IF モジュール
  IF uut (
    .CLK(CLK),
    .RST(RST),
    .newPC(newPC),
    .PC(PC),
    .W_Ins(W_Ins),
    .WE(WE),
    .nextPC(nextPC),
    .Ins(Ins)
  );

  // クロック生成（10ns周期）
  initial CLK = 0;
  always #5 CLK = ~CLK;

  initial begin
    $display("Start simulation using IMem.txt");
    $dumpfile("IF_tb.vcd");
    $dumpvars(0, IF_tb);

    // 初期状態
    RST = 1;
    #10;
    RST = 0;

    // PCが増えて命令が読まれるのを観察
    repeat (5) begin
      #10;  // クロック5回で PC = 0 → 4 → 8 → 12 → 16
      $display("Time: %0t | PC: %h | Ins: %h", $time, PC, Ins);
    end

    $finish;
  end

endmodule
