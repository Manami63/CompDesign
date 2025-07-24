module tb_SEG7DEC;
    reg [3:0] DIN;
    wire [7:0] nHEX;

    SEG7DEC uut (
        .DIN(DIN),
        .nHEX(nHEX)
    );

    initial begin
        $display("DIN | nHEX");
        for (DIN = 0; DIN < 16; DIN = DIN + 1) begin
            #10 $display("%h   | %b", DIN, nHEX);
        end
    end
endmodule
