/* Copyright(C) 2017 Cobac.Net All Rights Reserved. */
/* chapter: 第3章         */
/* project: CLOCK1        */
/* outline: 10ms（100Hz）信号の作成 */

module CNT10MS(
    input  CLK, RST,
    output EN10MS
);

/* 50MHzカウンタ */
reg [18:0] cnt;

always @( posedge CLK ) begin
    if ( RST )
        cnt <= 19'b0;
    else if ( EN10MS )
        cnt <= 19'b0;
    else
        cnt <= cnt + 19'b1;
end

/* 100Hzのイネーブル信号（=10ms周期）*/
assign EN10MS = (cnt == 19'd499_999); // 50,000,000 ÷ 100 = 500,000 cycles

endmodule
