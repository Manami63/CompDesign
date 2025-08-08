module RegisterFile (
    input CLK,
    input RST,
    input WE,                     // 書き込み信号
    input [4:0] Radr1, Radr2,   // 読み出しレジスタ番号
    input [4:0] Wadr,              // 書き込みレジスタ番号
    input [31:0] Wdata,            // 書き込みデータ
    output [31:0] Rdata1, Rdata2 // 読み出しデータ
);

    reg [31:0] registers[0:31];
    integer i;

    // 読み出し（非同期）
    assign Rdata1 = (Radr1 == 0) ? 32'b0 : registers[Radr1];
    assign Rdata2 = (Radr2 == 0) ? 32'b0 : registers[Radr2];

    // 書き込み（同期）
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'b0; // レジスタを初期化
            end
        end else if (WE && (Wadr != 0)) begin
            registers[Wadr] <= Wdata;
        end
    end

endmodule
