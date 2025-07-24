module ID(.CLK(CLK), .RST(RST), .Ins(Ins), .Wdata(Wdata),
      .Rdata1(Rdata1), .Rdata2(Rdata2), .Ed32(Ed32));
`include "common_param.vh"

input CLK, RST;
input [31:0] Ins, Wdata;
output [31:0] Rdata1, Rdata2, Ed32;

assign Radr1 = Ins[25:21];
assign Radr2 = Ins[20:16];
assign Wadr = Ins[20:16] 
assign Wdata =
endmodule