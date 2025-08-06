module Selector(
  input  [2:0] sw,  // SW[2:0]
  input  [31:0] Rdata1, Rdata2, Result, Wdata, nextPC,
  output reg [15:0] selected,
  output reg [9:0] LED  // LED点灯表示
);
  always @(*) begin
    LED = 10'b0;
    case (sw)
      3'b000: begin selected = Rdata1[15:0]; LED[0] = 1; end
      3'b001: begin selected = Rdata2[15:0]; LED[1] = 1; end
      3'b010: begin selected = Result[15:0]; LED[2] = 1; end
      3'b011: begin selected = Wdata[15:0];  LED[3] = 1; end
      3'b100: begin selected = nextPC[15:0]; LED[4] = 1; end
      default: begin selected = 16'hDEAD; LED[9] = 1; end // debug
    endcase
  end

    assign LED = (SW == 3'b000) ? 5'b00001 :
                (SW == 3'b001) ? 5'b00010 :
                (SW == 3'b010) ? 5'b00100 :
                (SW == 3'b011) ? 5'b01000 :
                (SW == 3'b100) ? 5'b10000 : 5'b00000;
endmodule
