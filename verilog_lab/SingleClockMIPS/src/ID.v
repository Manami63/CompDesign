module ID(CLK, RST, Ins, Wdata, Rdata1, Rdata2, Ed32);
`include "common_param.vh"

input CLK, RST;
input [31:0] Ins, Wdata;
output [31:0] Rdata1, Rdata2, Ed32;

reg [31:0] regs[0:31];

wire [5:0]  Op = Ins[31:26];
wire [4:0]  Radr1 = Ins[25:21];
wire [4:0]  Radr2 = Ins[20:16];
wire [4:0]  Rd = Ins[15:11];
wire [15:0] Imm = Ins[15:0];

// 書き込み先レジスタ
wire [4:0] Wadr = (op == JAL) ? 5'b11111 :
                  (op == R_FORM || op == JALR) ? Rd :
                  Radr2;

// 書き込み許可
wire WE = (op == R_FORM && func != JR && func != MTHI && func != MTLO &&
           func != MULT && func != DIV && func != DIVU) ||
          (6'd8 <= op && op <= 6'd15) || // I形式算術論理演算
          (op == LW) || (op == JAL);

// 即値の符号/ゼロ拡張
assign Ed32 = (op == ANDI || op == ORI || op == XORI) ?
              {16'b0, Imm} :
              {{16{Imm[15]}}, Imm};


RegisterFile rf (
    .CLK(CLK),
    .RST(RST),
    .WE(WE),
    .Radr1(Radr1),
    .Radr2(Radr2),
    .Wadr(Wadr),
    .Wdata(Wdata),
    .Rdata1(Rdata1),
    .Rdata2(Rdata2)
);

endmodule

