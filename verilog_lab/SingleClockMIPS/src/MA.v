module MA(
    input  wire        CLK,
    input  wire        RST,
    input  wire [31:0] Result,
    input  wire [31:0] Rdata2,
    input  wire [31:0] nextPC,
    input  wire [31:0] Ins,
    output reg  [31:0] Wdata
);
    `include "common_param.vh"

    wire [31:0] dm_dout;
    reg         dm_we;

    DM dm0 (
        .CLK(CLK),
        .WE(dm_we),
        .addr(Result),
        .din(Rdata2),
        .dout(dm_dout)
    );

    always @(*) begin
        dm_we = 1'b0;
        Wdata = Result;
        case (Ins[31:26])
            `LW:    Wdata = dm_dout;   // lw
            `SW_OP: dm_we = 1'b1;      // sw
            default: ;
        endcase
    end

endmodule
