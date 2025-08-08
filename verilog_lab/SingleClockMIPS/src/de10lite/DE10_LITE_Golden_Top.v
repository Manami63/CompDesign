module DE10_LITE_Golden_Top (
    input  wire        MAX10_CLK1_50,
    input  wire [9:0]  SW,
    input  wire [1:0]  KEY,
    input  wire [31:0] GPIO,           // W_Ins 用入力
    output wire [7:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
    output wire [9:0]  LEDR
);

    // BTN_IN 出力
    wire [3:0] clean_btn;

    // BTN_IN インスタンス
    BTN_IN BTN0 (
        .CLK(MAX10_CLK1_50),
        .RST(SW[9]),
        .nBIN({2'b00, KEY[1:0]}),  // 上位2bitは0固定
        .BOUT(clean_btn)
    );

    // MIPS 内部信号
    wire [31:0] PC, Result, Rdata1, Rdata2, Wdata, nextPC;
    wire [31:0] Vdata;
    wire [4:0]  SEL_LED;

    // SingleClockMIPS
    SingleClockMIPS SCM0 (
        .CLK(clean_btn[3]),   // 1パルス動作用
        .RST(SW[9]),
        .WE(SW[8]),
        .W_Ins(GPIO),         // GPIOから命令入力
        .PC(PC),
        .Result(Result),
        .Rdata1(Rdata1),
        .Rdata2(Rdata2),
        .Wdata(Wdata),
        .nextPC(nextPC)
    );

    // SELECTOR
    SELECTOR SELECTOR00 (
        .Rdata1(Rdata1),
        .Rdata2(Rdata2),
        .Result(Result),
        .Wdata(Wdata),
        .nextPC(nextPC),
        .SEL(clean_btn[2:0]),
        .SEL_LED(SEL_LED),
        .Vdata(Vdata)
    );

        // 7セグメント表示（nHEX出力仕様）
    SEG7DEC Res00 (.DIN(Vdata[3:0]),    .EN(1'b1), .DOT(1'b0), .nHEX(HEX0));
	 SEG7DEC Res01 (.DIN(Vdata[7:4]),    .EN(1'b1), .DOT(1'b0), .nHEX(HEX1));
	 SEG7DEC Res02 (.DIN(Vdata[11:8]),   .EN(1'b1), .DOT(1'b0), .nHEX(HEX2));
	 SEG7DEC Res03 (.DIN(Vdata[15:12]),  .EN(1'b1), .DOT(1'b0), .nHEX(HEX3));
	 SEG7DEC PC00  (.DIN(PC[5:2]),       .EN(1'b1), .DOT(1'b0), .nHEX(HEX4));
	 SEG7DEC PC01  (.DIN(PC[9:6]),       .EN(1'b1), .DOT(1'b0), .nHEX(HEX5));


    // LED 出力
    assign LEDR[4:0] = SEL_LED;
    assign LEDR[9:5] = 5'b0;

endmodule

