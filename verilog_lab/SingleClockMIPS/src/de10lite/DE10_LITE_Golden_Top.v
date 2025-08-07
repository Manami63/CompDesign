module DE10_LITE_Golden_Top (
    input  wire        MAX10_CLK1_50,
    input  wire [9:0]  SW,
    input  wire [3:0]  KEY,
    output wire [7:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
    output wire [9:0]  LEDR
);

// BTN_INからSelectorへの配線用
wire [3:0] clean_btn;

// BTN_INインスタンス
BTN_IN BTN0 (
    .CLK(MAX10_CLK1_50),
    .RST(SW[9]),
    .nBIN(KEY[3:0]),
    .BOUT(clean_btn)
);

// MIPS内部信号
wire [31:0] PC, Result, Rdata1, Rdata2, Wdata, nextPC;
wire [15:0] Vdata;          // 7segへ
wire [4:0]  SEL_LED;        // LED点灯表示

// SingleClockMIPS
SingleClockMIPS SCM0 (
    .CLK(clean_btn[0]),      // 1パルス動作：BOUT[0]をクロックとして利用
    .RST(SW[9]),
    .W_Ins(32'b0),
    .WE(1'b0),
    .PC(PC),
    .Result(Result),
    .Rdata1(Rdata1),
    .Rdata2(Rdata2),
    .Wdata(Wdata),
    .nextPC(nextPC)
);

// Selector（sw=SEL配線、信号名はSEL_LEDなど）
Selector SELECTOR00 (
    .sw(clean_btn[2:0]),
    .Rdata1(Rdata1),
    .Rdata2(Rdata2),
    .Result(Result),
    .Wdata(Wdata),
    .nextPC(nextPC),
    .selected(Vdata),
    .LED(SEL_LED)
);

// 7セグメント出力
SEG7DEC Res00 (.DIN(Vdata[3:0]),    .seg_out(HEX0));
SEG7DEC Res01 (.DIN(Vdata[7:4]),    .seg_out(HEX1));
SEG7DEC Res02 (.DIN(Vdata[11:8]),   .seg_out(HEX2));
SEG7DEC Res03 (.DIN(Vdata[15:12]),  .seg_out(HEX3));
SEG7DEC PC00  (.DIN(PC[5:2]),       .seg_out(HEX4));
SEG7DEC PC01  (.DIN(PC[9:6]),       .seg_out(HEX5));

// LED出力（下位5bitのみSelector制御、残り未使用0固定）
assign LEDR[4:0] = SEL_LED;
assign LEDR[9:5] = 5'b0;

endmodule

