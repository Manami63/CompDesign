// DM.v : シンプルな32bit×1024語RAM
module DM(
    input         CLK,
    input         WE,
    input  [31:0] addr,
    input  [31:0] din,
    output [31:0] dout
);
    reg [31:0] mem[0:1023];
    assign dout = mem[addr[11:2]];  // 4バイト境界

    always @(posedge CLK) begin
        if (WE) mem[addr[11:2]] <= din;
    end
endmodule
