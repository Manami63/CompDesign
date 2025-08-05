module DM(
    input  wire        CLK,
    input  wire [4:0]  A,    // アドレス (32語)
    input  wire [31:0] WD,   // 書き込みデータ
    input  wire        WE,   // 書き込みイネーブル
    output wire [31:0] RD    // 読み出しデータ
);
    reg [31:0] mem[0:31];
    integer i;
    initial for(i=0; i<32; i=i+1) mem[i]=0;

    always @(posedge CLK) begin
        if(WE) mem[A] <= WD;
    end
    assign RD = mem[A];
endmodule
