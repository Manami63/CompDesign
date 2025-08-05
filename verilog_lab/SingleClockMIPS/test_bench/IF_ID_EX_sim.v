`timescale 1ns/1ps

module IF_ID_EX_sim;

    reg         CLK, RST;
    reg  [31:0] newPC;
    reg  [31:0] W_Ins;
    reg         WE;

    wire [31:0] PC, nextPC, Ins;
    wire [31:0] Rdata1, Rdata2, Ed32;
    wire [31:0] Result_EX, newPC_EX, HI_EX, LO_EX;

    // --- IF???? ---
    IF ifu (
        .CLK(CLK),
        .RST(RST),
        .newPC(newPC),
        .PC(PC),
        .W_Ins(W_Ins),
        .WE(WE),
        .nextPC(nextPC),
        .Ins(Ins)
    );

    // --- ID???? ---
    ID idu (
        .CLK(CLK),
        .RST(RST),
        .Ins(Ins),
        .Wdata(Result_EX),    // Wdata??????????????
        .Rdata1(Rdata1),
        .Rdata2(Rdata2),
        .Ed32(Ed32)
    );

    // --- EX???? ---
    EX exu (
        .CLK(CLK),
        .RST(RST),
        .Ins(Ins),
        .Rdata1(Rdata1),
        .Rdata2(Rdata2),
        .Ed32(Ed32),
        .nextPC(nextPC),
        .Result(Result_EX),
        .newPC(newPC_EX),
        .HI(HI_EX),
        .LO(LO_EX)
    );

    // ??????
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

    // ???????
    initial begin
        $display("==== IF?ID?EX Pipeline ??? ====");
        RST    = 1;
        newPC  = 32'h0;
        W_Ins  = 32'b0;
        WE     = 0;
        #12;
        RST    = 0;

        // ??????????????ADD???0????
        newPC  = 32'h0;
        W_Ins  = 32'b000000_00001_00010_00011_00000_100000; // ADD $3, $1, $2
        WE     = 1;
        #10;
        WE     = 0;

        // ????????
        repeat(5) begin
            #10;
            $display("PC=%h | IF.Ins=%h | R1=%h | R2=%h | Ed32=%h | EX.Result=%h | EX.newPC=%h", 
                PC, Ins, Rdata1, Rdata2, Ed32, Result_EX, newPC_EX);
        end

        $display("==== ????? ====");
        $stop;
    end

endmodule

