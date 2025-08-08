module SEG7DEC (
    input  wire [3:0] DIN,   // 4bit入力
    input  wire       EN,    // イネーブル（1=表示ON, 0=全消灯）
    input  wire       DOT,   // 小数点
    output reg  [7:0] nHEX   // 負論理7セグ出力 (dp含む)
);
    always @(*) begin
        if (!EN) begin
            nHEX = 8'b1111_1111; // 全消灯
        end else begin
            case (DIN)
                4'h0: nHEX[6:0] = 7'b100_0000;
                4'h1: nHEX[6:0] = 7'b111_1001;
                4'h2: nHEX[6:0] = 7'b010_0100;
                4'h3: nHEX[6:0] = 7'b011_0000;
                4'h4: nHEX[6:0] = 7'b001_1001;
                4'h5: nHEX[6:0] = 7'b001_0010;
                4'h6: nHEX[6:0] = 7'b000_0010;
                4'h7: nHEX[6:0] = 7'b111_1000;
                4'h8: nHEX[6:0] = 7'b000_0000;
                4'h9: nHEX[6:0] = 7'b001_0000;
                4'hA: nHEX[6:0] = 7'b000_1000;
                4'hB: nHEX[6:0] = 7'b000_0011;
                4'hC: nHEX[6:0] = 7'b100_0110;
                4'hD: nHEX[6:0] = 7'b010_0001;
                4'hE: nHEX[6:0] = 7'b000_0110;
                4'hF: nHEX[6:0] = 7'b000_1110;
                default: nHEX[6:0] = 7'b111_1111; // Error
            endcase
            // DOT（小数点）
            nHEX[7] = ~DOT; // 負論理なのでDOT=1なら0出力
        end
    end
endmodule
