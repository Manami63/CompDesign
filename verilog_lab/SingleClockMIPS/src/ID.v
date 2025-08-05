module ID(CLK, RST, Ins, Wdata, Rdata1, Rdata2, Ed32);

input CLK, RST;
input [31:0] Ins, Wdata;      // Instruction(命令)
output [31:0] Rdata1, Rdata2, Ed32;

reg [31:0] regs[0:31];

// 命令を取り出す
wire [5:0]  Op = Ins[31:26];       // opcode     
wire [4:0]  Radr1 = Ins[25:21];    // rs reg addr     wireで型宣言しないと，Rdata1と2が波形表示されない
wire [4:0]  Radr2 = Ins[20:16];    // rt reg addr
wire [4:0]  Rd = Ins[15:11];       // rd reg addr
wire [15:0] Imm = Ins[15:0];       // immediate value  wireで型宣言しないと， 27lineでエラー        



// 即値(I型命令)拡張 SE/UE
//wire sign_bit = Imm[15];
assign Ed32 = (Op == 6'b001100 ||  // andi
            Op == 6'b001101 ||      // ori
            Op == 6'b001110) ?      // xori     
            {16'b0, Imm} :          
            {{16{Imm[15]}}, Imm};   // 最上位bitをうめる


// 書き込み先レジスタを決定 MUX1
assign Wadr = (Op == 6'b000011) ? 5'd31 :
            (Op == 6'b000000) ? Rd :
            Radr2;

wire WE = (Op != 6'b000100) &&
            (Op != 6'b000101) &&
            (Op != 6'b000010);

// レジスタファイルのインスタンス化
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


// 書き込み
// always @(posedge CLK) begin
//       if(WE && Wadr != 5'd0) begin
//             regs[Wadr] <= Wdata;
//       end
//end
endmodule