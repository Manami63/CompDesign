module SEG7DEC(DIN,dot_enable,seg_out);
	input [3:0] DIN;
        input dot_enable;
        output reg[7:0] seg_out;
        reg [7:0] nHEX;

always @(*)
begin
 case(DIN)
	4'h0: nHEX = 8'b11000000;
        4'h1: nHEX = 8'b11111001;
        4'h2: nHEX = 8'b10100100;
        4'h3: nHEX = 8'b10110000;
        4'h4: nHEX = 8'b10011001;
        4'h5: nHEX = 8'b10010010;
        4'h6: nHEX = 8'b10000010;
        4'h7: nHEX = 8'b11111000;
        4'h8: nHEX = 8'b10000000;
        4'h9: nHEX = 8'b10010000;
        4'hA: nHEX = 8'b11111111;
        default: nHEX = 8'b11111111; // ????
 endcase

 if(dot_enable)
        seg_out = nHEX & 8'b01111111;
 else
        seg_out = nHEX | 8'b10000000;

end
endmodule


	
	