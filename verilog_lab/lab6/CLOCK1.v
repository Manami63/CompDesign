module CLOCK1 (
    input CLK, 	 // 50MHz クロック
	 input RST,
                // スイッチ（SW[9] = RST, SW[0] = CLRボタン）
    input [2:0] KEY,            // ボタン入力（KEY[1]=分加算, KEY[0]=秒加算）
    output [7:0] nHEX0,         // 秒の1桁目
    output [7:0] nHEX1,         // 秒の10桁目
    output [7:0] nHEX2,         // 分の1桁目
    output [7:0] nHEX3          // 分の10桁目
);

    // --- 信号線定義 ---
    wire en1hz;                 // 1Hzイネーブル信号
    wire [3:0] sec1, min1;      // 秒・分の1桁目（0〜9）
    wire [2:0] sec10, min10;    // 秒・分の10桁目（0〜5）
    wire ca;                    // キャリー信号（秒→分）
    
    wire secup, minup, clr;

    // --- 1Hz分周器 ---
    CNT1SEC u1hz (
        .CLK(CLK),
        .RST(RST),
        .EN1HZ(en1hz)
    );

    // --- ボタンチャタリング除去 ---
    BTN_IN ubtn (
        .CLK(CLK),
        .RST(RST),
        .nBIN(KEY),  // 3bit入力: CLR, MINUP, SECUP
        .BOUT({secup, minup, clr})
    );

CNT60 usec (
    .CLK(CLK),
    .RST(RST),
	 .EN(en1hz),
    .INC(secup),
    .CLR(clr),
    .QL(sec1),
    .QH(sec10),
    .CA(ca)
);

CNT60 umin (
    .CLK(CLK),
    .RST(RST),
	 .EN(ca),
    .INC(minup),
    .CLR(clr),
    .QL(min1),
    .QH(min10),
    .CA()  // 分にはCAいらない
);

    // --- 7セグメント表示（アクティブロー） ---
    SEG7DEC d0 (.DIN(sec1),  .nHEX(nHEX0));
    SEG7DEC d1 (.DIN(sec10), .nHEX(nHEX1));
    SEG7DEC d2 (.DIN(min1),  .nHEX(nHEX2));
    SEG7DEC d3 (.DIN(min10), .nHEX(nHEX3));

endmodule
