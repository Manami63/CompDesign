module TopMIPS (
    input [2:0] SW,
    input [2:0] BTN,
    output [7:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
    output [4:0] LED
);
`include "common_param.vh"

wire RST = SW[9];  
wire CLK = KEY[0]; 

wire [31:0] PC, Result,Rdata1, Rdata2, Wdata, Ins, nextPC, Ed32;
wire [31:0] display_data;
wire [7:0] pc_disp;

// クロック制御（BTNが押されたときに1パルス）
reg prev_BTN, step_clk;
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        prev_BTN <= 0;
        step_clk <= 0;
    end else begin
        prev_BTN <= BTN;
        step_clk <= ~prev_BTN & BTN; // 立ち上がり検出
    end
end


// SingleClockMIPS を接続
SingleClockMIPS mips (
    .CLK(CLK),
    .RST(RST),
    .W_Ins(32'b0),  // FPGAではインストール書き換えしないなら0固定
    .WE(1'b0),      // 書き込み禁止
    .PC(PC),
    .Result(Result)
);

// 表示切り替え
Selector selector (
    .sw(SW[2:0]),
    .Rdata1(Rdata1),
    .Rdata2(Rdata2),
    .Result(Result),
    .Wdata(Wdata),
    .nextPC(nextPC),
    .selected(LED[15:0]),
    .LED(LED[9:0])  // LED点灯表示
);

// --- ボタンチャタリング除去 ---
BTN_IN ubtn (
    .CLK(CLK),
    .RST(RST),
    .nBIN(KEY),  // 3bit入力: CLR, MINUP, SECUP
    .BOUT({secup, minup, clr})
);

assign LED = led_out;
assign pc_display = PC[9:2];

// 7セグ表示（HEX5~HEX0）
SEG7DEC seg5(.din(pc_display[7:4]), .dout(HEX5));
SEG7DEC seg4(.din(pc_display[3:0]), .dout(HEX4));
SEG7DEC seg3(.din(selected[15:12]), .dout(HEX3));
SEG7DEC seg2(.din(selected[11:8]),  .dout(HEX2));
SEG7DEC seg1(.din(selected[7:4]),   .dout(HEX1));
SEG7DEC seg0(.din(selected[3:0]),   .dout(HEX0));

// LEDで確認用（PC下位ビットとか）
//assign LEDR = PC[9:0];

endmodule
