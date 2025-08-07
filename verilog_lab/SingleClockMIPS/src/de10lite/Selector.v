module SELECTOR(
    input  [2:0] SEL,  // SW[2:0]
    input  [31:0] Rdata1, Rdata2, Result, Wdata, nextPC,
    output reg [31:0] Vdata,
    output reg [4:0] SEL_LED  // LED点灯表示
);
    always @(*) begin
        SEL_LED = 5'b0;
        case (sw)
            3'b000: begin Vdata = Rdata1[31:0]; SEL_LED[0] = 1; end
            3'b001: begin Vdata = Rdata2[31:0]; SEL_LED[1] = 1; end
            3'b010: begin Vdata = Result[31:0]; SEL_LED[2] = 1; end
            3'b011: begin Vdata = Wdata[31:0];  SEL_LED[3] = 1; end
            3'b100: begin Vdata = nextPC[31:0]; SEL_LED[4] = 1; end
            default: begin Vdata = 16'hDEAD; SEL_LED = 5'b11111; end // debug
        endcase
    end
endmodule
