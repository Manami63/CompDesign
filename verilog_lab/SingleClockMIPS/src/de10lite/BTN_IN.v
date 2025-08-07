module BTN_IN (
    input        CLK, RST,
    input  [3:0] nBIN,
    output reg [3:0] BOUT
);

reg [20:0] cnt;
wire en40hz = (cnt == 1250000-1);

always @(posedge CLK) begin
    if (RST)
        cnt <= 21'b0;
    else if (en40hz)
        cnt <= 21'b0;
    else
        cnt <= cnt + 21'b1;
end

reg [3:0] ff1, ff2;

always @(posedge CLK) begin
    if (RST) begin
        ff2 <= 4'b0;
        ff1 <= 4'b0;
    end
    else if (en40hz) begin
        ff2 <= ff1;
        ff1 <= nBIN;
    end
end

wire [3:0] temp = ~ff1 & ff2 & {4{en40hz}};

always @(posedge CLK) begin
    if (RST)
        BOUT <= 4'b0;
    else
        BOUT <= temp;
end

endmodule
