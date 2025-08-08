module EX(
    CLK, RST, Ins, Rdata1, Rdata2, Ed32, nextPC, Result, newPC, HI, LO
);
    input  CLK, RST;
    input  [31:0] Ins;
    input  [31:0] Rdata1;
    input  [31:0] Rdata2;
    input  [31:0] Ed32;
    input  [31:0] nextPC;
    output [31:0] Result;
    output [31:0] newPC;
    output [31:0] HI;
    output [31:0] LO;

    `include "common_param.vh"

    reg [31:0] hi_reg, lo_reg;
    reg [31:0] Result_reg, newPC_reg;

    assign HI = hi_reg;
    assign LO = lo_reg;
    assign Result = Result_reg;
    assign newPC  = newPC_reg;

    wire [5:0] Op    = Ins[31:26];
    wire [4:0] shamt = Ins[10:6];
    wire [5:0] Func  = Ins[5:0];
    wire [15:0] Imm  = Ins[15:0];
    wire [25:0] Jadr = Ins[25:0];
    wire zero        = (Rdata1 == Rdata2);
    wire nonzero     = (Rdata1 != Rdata2);
    wire signed [31:0] sRdata1 = Rdata1;
    wire signed [31:0] sRdata2 = Rdata2;
    wire signed [31:0] sEd32   = Ed32;

    wire [31:0] sh2   = {{14{Imm[15]}}, Imm, 2'b00};
    wire [31:0] sh2_J = {nextPC[31:28], Jadr, 2'b00};

    wire [31:0] MUX4 = (Op == `BEQ && zero)           ? nextPC + 4 + sh2 :
                       (Op == `BNE && nonzero)        ? nextPC + 4 + sh2 :
                       (Op == `BGTZ && sRdata1 > 0)   ? nextPC + 4 + sh2 :
                       (Op == `BLEZ && sRdata1 <= 0)  ? nextPC + 4 + sh2 :
                       (Op == 6'd1 && Ins[20:16] == `BLTZ_r && sRdata1 < 0) ? nextPC + 4 + sh2 :
                       (Op == 6'd1 && Ins[20:16] == `BGEZ_r && sRdata1 >= 0)? nextPC + 4 + sh2 :
                       nextPC + 4;

    wire [31:0] MUX5 = (Op == `J || Op == `JAL)              ? sh2_J :
                       (Op == `R_FORM && (Func == `JR || Func == `JALR)) ? Rdata1 :
                       MUX4;

    // ALU
    always @(*) begin
        Result_reg = 32'hDEADBEEF;
        newPC_reg  = MUX5;

        case (Op)
            `R_FORM: begin
                case (Func)
                    `ADD, `ADDU:   Result_reg = Rdata1 + Rdata2;
                    `SUB, `SUBU:   Result_reg = Rdata1 - Rdata2;
                    `AND:         Result_reg = Rdata1 & Rdata2;
                    `OR:          Result_reg = Rdata1 | Rdata2;
                    `XOR:         Result_reg = Rdata1 ^ Rdata2;
                    `NOR:         Result_reg = ~(Rdata1 | Rdata2);
                    `SLT:         Result_reg = (sRdata1 < sRdata2) ? 32'd1 : 32'd0;
                    `SLTU:        Result_reg = (Rdata1 < Rdata2) ? 32'd1 : 32'd0;
                    `SLL:         Result_reg = Rdata2 << shamt;
                    `SRL:         Result_reg = Rdata2 >> shamt;
                    `SRA:         Result_reg = sRdata2 >>> shamt;
                    `SLLV:        Result_reg = Rdata2 << Rdata1[4:0];
                    `SRLV:        Result_reg = Rdata2 >> Rdata1[4:0];
                    `SRAV:        Result_reg = sRdata2 >>> Rdata1[4:0];
                    `MFHI:        Result_reg = hi_reg;
                    `MFLO:        Result_reg = lo_reg;
                    default:      Result_reg = 32'hDEADBEEF;
                endcase
            end
            `ADDI:    Result_reg = Rdata1 + Ed32;
            `ADDIU:   Result_reg = Rdata1 + Ed32;
            `ANDI:    Result_reg = Rdata1 & {16'd0, Ed32[15:0]};
            `ORI:     Result_reg = Rdata1 | {16'd0, Ed32[15:0]};
            `XORI:    Result_reg = Rdata1 ^ {16'd0, Ed32[15:0]};
            `SLTI:    Result_reg = (sRdata1 < sEd32) ? 32'd1 : 32'd0;
            `SLTIU:   Result_reg = (Rdata1 < Ed32) ? 32'd1 : 32'd0;
            `LW, `SW_OP:  Result_reg = Rdata1 + Ed32;
            default: ;
        endcase
    end

    // HI/LOの処理
    always @(posedge CLK) begin
        if (RST) begin
            hi_reg <= 32'd0;
            lo_reg <= 32'd0;
        end else if (Op == `R_FORM) begin
            case (Func)
                `MULT:  {hi_reg, lo_reg} <= $signed(Rdata1) * $signed(Rdata2);
                `MULTU: {hi_reg, lo_reg} <= Rdata1 * Rdata2;
                `DIV:   if (Rdata2 != 0) begin
                           lo_reg <= $signed(Rdata1) / $signed(Rdata2);
                           hi_reg <= $signed(Rdata1) % $signed(Rdata2);
                       end
                `DIVU:  if (Rdata2 != 0) begin
                           lo_reg <= Rdata1 / Rdata2;
                           hi_reg <= Rdata1 % Rdata2;
                       end
                `MTHI:  hi_reg <= Rdata1;
                `MTLO:  lo_reg <= Rdata1;
                default:;
            endcase
        end
    end

endmodule

