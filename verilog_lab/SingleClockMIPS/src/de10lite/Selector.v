module SELECTOR (
    input  [2:0]  SEL,       // 選択スイッチ
    input  [31:0] Rdata1, 
    input  [31:0] Rdata2, 
    input  [31:0] Result, 
    input  [31:0] Wdata, 
    input  [31:0] nextPC,
    output reg [31:0] Vdata, // 7セグ表示用
    output reg [4:0]  SEL_LED // LED表示
);

    always @(*) begin
        SEL_LED = 5'b0;
        case (SEL)
            3'b000: begin Vdata = {16'b0, Rdata1[15:0]}; SEL_LED[0] = 1; end
            3'b001: begin Vdata = {16'b0, Rdata2[15:0]}; SEL_LED[1] = 1; end
            3'b010: begin Vdata = {16'b0, Result[15:0]}; SEL_LED[2] = 1; end
            3'b011: begin Vdata = {16'b0, Wdata[15:0]};  SEL_LED[3] = 1; end
            3'b100: begin Vdata = {16'b0, nextPC[15:0]}; SEL_LED[4] = 1; end
            default: begin Vdata = 32'hDEAD_BEEF; SEL_LED = 5'b11111; end
        endcase
    end

endmodule
