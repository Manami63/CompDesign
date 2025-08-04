module ID(CLK, RST, Ins, Wdata, Rdata1, Rdata2, Ed32);

input CLK, RST;
input [31:0] Ins, Wdata;      // Instruction(命令)
output [31:0] Rdata1, Rdata2, Ed32;

reg [31:0] regs[0:31];

// 命令を取り出す
assign Op = Ins[31:26];       // opcode     
assign Radr1 = Ins[25:21];    // rs reg addr
assign Radr2 = Ins[20:16];    // rt reg addr
assign Rd = Ins[15:11];       // rd reg addr
wire [15:0] Imm = Ins[15:0];       // immediate value  wireで型宣言しないと， 27lineでエラー        

// レジスタから値を読む
assign Rdata1 = regs[Radr1];
assign Rdata2 = regs[Radr2];

// レジスタの初期化?
integer i;
initial begin
    for (i = 0; i < 32; i = i + 1) begin
        regs[i] = 32'd0;
    end
end


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

// 書き込み
always @(posedge CLK) begin
      if(WE && Wadr != 5'd0) begin
            regs[Wadr] <= Wdata;
      end
end
endmodule