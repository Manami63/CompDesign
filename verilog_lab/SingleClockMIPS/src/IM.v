module IM #(parameter IMEM_SIZE = 128)(
  input CLK, RST,WE,
  input [31:0] PC, W_Ins,
  output [31:0] Ins
);

  reg [31:0] read_ins_temp;
  reg [31:0] IMem [0:IMEM_SIZE-1];

  initial begin
    //$readmemh("IMem.txt", IMem, 8'h00, 8'h0f); //binari, 8'h00:????????, 8'h0f:????? 2??
    $readmemh("IMem.txt", IMem); //binari, 8'h00:????????, 8'h0f:???????16??
//	for (i = 0; i < 32; i = i + 1) begin
//		IMem[i] <= 32'b0;
//	end
  end

  always @ (posedge CLK) begin
    if ( ~RST && WE ) IMem[PC>>2] <= W_Ins; //??????????????????
  end

  assign Ins = RST? 32'd0: IMem[PC>>2];

endmodule
