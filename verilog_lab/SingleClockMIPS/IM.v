module IM(parameter IMEM_SIZE = 128)(
  input CLK, RST,WE,
  input [31:0] PC, W_Ins,
  output [31:0] Ins
);

  reg [31:0] read_ins_temp;
  reg [31:0] IMem [0:IMEM_SIZE-1];

  initial begin
    $readmemb("IMem.txt", IMem, 8'h00, 8'h0f); //binari, 8'h00:初期化先頭ワード, 8'h0f:末尾ワード
//	for (i = 0; i < 32; i = i + 1) begin
//		IMem[i] <= 32'b0;
//	end
  end

  always @ (posedge CLK) begin
    if ( ~RST && WE ) IMem[PC>>2] <= W_Ins; //クロックが立ち上がったら書き込みまち
  end

  assign Ins = RST? 32'd0: IMem[PC>>2];

endmodule
