module TopMIPS (
    input [9:0] SW,
    input [2:0] BTN,
    output [7:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
    output [4:0] LED
);
`include "common_param.vh"

// クロックとリセットを上位の仕様に合わせて参照
wire RST = SW[9];
wire CLK = BTN[0];

wire [31:0] PC, Result,Rdata1, Rdata2, Wdata, Ins, nextPC, Ed32;
wire [31:0] display_data;
wire [7:0] pc_disp;

// クロック制御
reg prev_BTN, step_clk;
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        prev_BTN <= 0;
        step_clk <= 0;
    end else begin
        prev_BTN <= BTN[0];
        step_clk <= ~prev_BTN & BTN[0];
    end
end

// ...他ロジック...

endmodule
