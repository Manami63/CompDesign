module DM(
    input  wire        CLK,
    input  wire        WE,
    input  wire [31:0] addr,    // ? MA.v????? 'addr'
    input  wire [31:0] din,     // ? MA.v????? 'din'
    output reg  [31:0] dout     // ? MA.v????? 'dout'
);

    reg [31:0] mem [0:127];

    // ????
    always @(posedge CLK) begin
        if (WE)
            mem[addr[8:2]] <= din;
    end

    // ????
    always @(*) begin
        dout = mem[addr[8:2]];
    end

endmodule