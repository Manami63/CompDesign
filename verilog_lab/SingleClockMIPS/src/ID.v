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

// 即値の符号拡張/ゼロ拡張
assign Ed32 = (Op == 6'b001100 ||  // andi
            Op == 6'b001101 ||      // ori
            Op == 6'b001110) ?      // xori     
            {16'b0, Imm} :          
            {{16{Imm[15]}}, Imm};

// 書き込み先レジスタ選択
wire [4:0] Wadr;
assign Wadr = (Op == 6'b000011) ? 5'd31 :
            (Op == 6'b000000) ? Rd :
            Radr2;

wire WE = (Op != 6'b000100) &&
            (Op != 6'b000101) &&
            (Op != 6'b000010);

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
