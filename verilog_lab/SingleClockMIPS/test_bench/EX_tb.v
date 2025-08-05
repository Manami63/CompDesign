`timescale 1ns/1ps

module EX_tb;

    reg         CLK, RST;
    reg  [31:0] Ins;
    reg  [31:0] Rdata1, Rdata2, Ed32, nextPC;
    wire [31:0] Result, newPC, HI, LO;

    // DUT??????????????????EX?
    EX dut (
        .CLK(CLK),
        .RST(RST),
        .Ins(Ins),
        .Rdata1(Rdata1),
        .Rdata2(Rdata2),
        .Ed32(Ed32),
        .nextPC(nextPC),
        .Result(Result),
        .newPC(newPC),
        .HI(HI),
        .LO(LO)
    );

    // ??????
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

    initial begin
        $display("==== EX ?????????? ====");
        RST = 1; Ins = 0; Rdata1 = 0; Rdata2 = 0; Ed32 = 0; nextPC = 32'h4;
        #12; RST = 0;

        // --- ADD????? ---
        Ins     = {6'd0, 5'd1, 5'd2, 5'd3, 5'd0, 6'd32};
        Rdata1  = 32'd15;
        Rdata2  = 32'd7;
        Ed32    = 32'd0;
        nextPC  = 32'h00000004;
        #10;
        $display("ADD: Result = %d (expect 22)", Result);

        // --- BEQ????????? ---
        Ins     = {6'd4, 5'd3, 5'd3, 16'd2}; // BEQ $3, $3, 2
        Rdata1  = 32'd5;
        Rdata2  = 32'd5;
        Ed32    = 32'd0;
        nextPC  = 32'h00000008;
        #10;
        $display("BEQ: newPC = %h (expect 00000014)", newPC);

        // --- J????? ---
        Ins     = {6'd2, 26'h0000003}; // J 0xC
        nextPC  = 32'h00000010;
        #10;
        $display("J: newPC = %h (expect 0000000C)", newPC);

        // --- JR????? ---
        Ins     = {6'd0, 5'd4, 5'd0, 5'd0, 5'd0, 6'd8}; // JR $4
        Rdata1  = 32'h12345678;
        #10;
        $display("JR: newPC = %h (expect 12345678)", newPC);

        // --- AND????? ---
        Ins     = {6'd0, 5'd5, 5'd6, 5'd7, 5'd0, 6'd36};
        Rdata1  = 32'hF0F0F0F0;
        Rdata2  = 32'h0FF00FF0;
        #10;
        $display("AND: Result = %h (expect 00F000F0)", Result);

        // --- SLL????? ---
        Ins     = {6'd0, 5'd0, 5'd8, 5'd9, 5'd4, 6'd0}; // shamt=4
        Rdata2  = 32'h00000011;
        #10;
        $display("SLL: Result = %h (expect 00000110)", Result);

        // --- ORI????? ---
        Ins     = {6'd13, 5'd9, 5'd10, 16'h00FF};
        Rdata1  = 32'h12340000;
        Ed32    = 32'h000000FF;
        #10;
        $display("ORI: Result = %h (expect 123400FF)", Result);

        // --- SLT????? ---
        Ins     = {6'd0, 5'd11, 5'd12, 5'd13, 5'd0, 6'd42};
        Rdata1  = -32'd2;
        Rdata2  = 32'd1;
        #10;
        $display("SLT: Result = %d (expect 1)", Result);

        // --- MULT??????HI/LO??? ---
        Ins     = {6'd0, 5'd14, 5'd15, 5'd0, 5'd0, 6'd24};
        Rdata1  = 32'd7;
        Rdata2  = 32'd5;
        #10;
        $display("MULT: HI = %d, LO = %d (expect HI=0, LO=35)", HI, LO);

        // --- MFLO????? ---
        Ins     = {6'd0, 5'd0, 5'd0, 5'd16, 5'd0, 6'd18};
        #10;
        $display("MFLO: Result = %d (expect LO=35)", Result);

        $display("==== EX ????? ====");
        $stop;
    end

endmodule

