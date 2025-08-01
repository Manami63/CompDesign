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
    wire [3:0] sec10, min10;     // 秒・分の10桁目（0〜5）

    wire [3:0] disp_sec10 = (sec10 == 0) ? 4'hA : sec10;   
    
   // wire [3:0] disp_min1  = (min10 == 0 && min1 == 0) ? 4'hA : min1;
    wire [3:0] disp_min10 = (min10 == 0) ? 4'hA : min10;

    wire ca;                    // キャリー信号（秒→分）
    
    wire secup, minup, clr;

    wire dot_enable = 1'b1;
    wire dot_unenable = 1'b0;

    

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
    .CLR(clr),
	.EN(en1hz),
    .INC(secup),
    .QH(sec10),
    .QL(sec1),
    .CA(ca)
);

CNT60 umin (
    .CLK(CLK),
    .RST(RST),
    .CLR(clr),
	.EN(ca),
    .INC(minup),
    .QH(min10),
    .QL(min1),
    .CA()  // 分にはCAいらない
);

    // --- 7セグメント表示（アクティブロー） ---
    SEG7DEC d0 (.DIN(sec1), .dot_enable(dot_enable), .seg_out(nHEX0));
    SEG7DEC d1 (.DIN(disp_sec10), .dot_enable(dot_unenable), .seg_out(nHEX1));
    SEG7DEC d2 (.DIN(min1), .dot_enable(dot_unenable), .seg_out(nHEX2));
    SEG7DEC d3 (.DIN(disp_min10),.dot_enable(dot_unenable), .seg_out(nHEX3));

endmodule
