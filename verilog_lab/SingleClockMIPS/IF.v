module IF(CLK, RST, newPC, PC, W_Ins, WE, nextPC, Ins);
`include "common_param.vh"
input CLK, RST, WE;
input [31:0] newPC, W_Ins;
output reg [31:0] PC; // reg?
output [31:0] nextPC, Ins;

// PCにある番地の命令を取得
IM imem(
    .addr(PC[31:2]),    //word addressing
    .instr(Ins)
);

assign nextPC = PC + 4; //　つぎの命令アドレス

    always @(posedge CLK or posedge RST) begin
        if(RST)
            PC <= 32'd0;
        else
            PC <= nextPC;
    end
endmodule

// PCで命令を読んで，次のPCを計算