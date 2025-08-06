`timescale 1ns/1ps

module MA_tb;

    reg         CLK, RST;
    reg  [31:0] Result, Rdata2, nextPC, Ins;
    wire [31:0] Wdata;

    // DUT??????????????
    MA dut (
        .CLK(CLK),
        .RST(RST),
        .Result(Result),
        .Rdata2(Rdata2),
        .nextPC(nextPC),
        .Ins(Ins),
        .Wdata(Wdata)
    );

    // ??????
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

    // ???????
    initial begin
        $display("==== MA/DM ????? ====");
        RST    = 1;
        Result = 0;
        Rdata2 = 0;
        nextPC = 0;
        Ins    = 32'd0;
        #12;   // ??????
        RST    = 0;

        // --- SW???????0x20?0xDEADBEEF????? ---
        Result = 32'h00000020;          // ????????
        Rdata2 = 32'hDEADBEEF;          // ????
        Ins    = {6'd43, 26'd0};        // SW???Op=43?
        #10;
        $display("SW: ???[%h] <= %h", Result, Rdata2);

        // --- LW???????0x20???????? ---
        Result = 32'h00000020;
        Rdata2 = 32'h00000000;          // ???
        Ins    = {6'd35, 26'd0};        // LW???Op=35?
        #10;
        $display("LW: Wdata = %h (expect DEADBEEF)", Wdata);

        // --- ADD???Wdata=Result??????????????????? ---
        Result = 32'h12345678;
        Ins    = {6'd0, 26'd0};         // R????Op=0?
        #10;
        $display("ALU: Wdata = %h (expect 12345678)", Wdata);

        $display("==== ????? ====");
        $stop;
    end

endmodule

