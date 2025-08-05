`include "common_param.vh"

module Ex(
    input  wire        CLK,
    input  wire        RST,
    input  wire [31:0] Ins,     // 命令
    input  wire [31:0] Rdata1,  // レジスタ値1
    input  wire [31:0] Rdata2,  // レジスタ値2
    input  wire [31:0] Ed32,    // 即値拡張
    input  wire [31:0] nextPC,  // PC+4
    output wire [31:0] Result,  // ALU/乗算/除算/ロード値
    output wire [31:0] newPC,   // 分岐・ジャンプ時の新PC
    output wire [31:0] HI,
    output wire [31:0] LO
);

    reg [31:0] hi_reg, lo_reg;
    reg [31:0] Result_reg, newPC_reg;

    assign HI = hi_reg;
    assign LO = lo_reg;
    assign Result = Result_reg;
    assign newPC = newPC_reg;

    wire [5:0] op    = Ins[31:26];
    wire [4:0] rs    = Ins[25:21];
    wire [4:0] rt    = Ins[20:16];
    wire [4:0] rd    = Ins[15:11];
    wire [4:0] shamt = Ins[10:6];
    wire [5:0] func  = Ins[5:0];
    wire signed [31:0] sRdata1 = Rdata1;
    wire signed [31:0] sRdata2 = Rdata2;
    wire signed [31:0] sEd32   = Ed32;

    // ALU, 分岐, ジャンプ, HI/LO, newPC判定
    always @(*) begin
        Result_reg = 32'hDEADBEEF;
        newPC_reg  = nextPC + 4;

        case (op)
            R_FORM: begin
                case (func)
                    ADD, ADDU:   Result_reg = Rdata1 + Rdata2;
                    SUB, SUBU:   Result_reg = Rdata1 - Rdata2;
                    AND:         Result_reg = Rdata1 & Rdata2;
                    OR:          Result_reg = Rdata1 | Rdata2;
                    XOR:         Result_reg = Rdata1 ^ Rdata2;
                    NOR:         Result_reg = ~(Rdata1 | Rdata2);
                    SLT:         Result_reg = (sRdata1 < sRdata2) ? 32'd1 : 32'd0;
                    SLTU:        Result_reg = (Rdata1 < Rdata2) ? 32'd1 : 32'd0;
                    SLL:         Result_reg = Rdata2 << shamt;
                    SRL:         Result_reg = Rdata2 >> shamt;
                    SRA:         Result_reg = sRdata2 >>> shamt;
                    SLLV:        Result_reg = Rdata2 << Rdata1[4:0];
                    SRLV:        Result_reg = Rdata2 >> Rdata1[4:0];
                    SRAV:        Result_reg = sRdata2 >>> Rdata1[4:0];
                    MFHI:        Result_reg = hi_reg;
                    MFLO:        Result_reg = lo_reg;
                    JR:          newPC_reg  = Rdata1;
                    JALR: begin
                        newPC_reg  = Rdata1;
                        // jalr時、rdにPC+4を書き込む制御はWBで
                    end
                    default:     Result_reg = 32'hDEADBEEF;
                endcase
            end
            ADDI:    Result_reg = Rdata1 + Ed32;
            ADDIU:   Result_reg = Rdata1 + Ed32;
            ANDI:    Result_reg = Rdata1 & {16'd0, Ed32[15:0]};
            ORI:     Result_reg = Rdata1 | {16'd0, Ed32[15:0]};
            XORI:    Result_reg = Rdata1 ^ {16'd0, Ed32[15:0]};
            SLTI:    Result_reg = (sRdata1 < sEd32) ? 32'd1 : 32'd0;
            SLTIU:   Result_reg = (Rdata1 < Ed32) ? 32'd1 : 32'd0;
            LW, SW:  Result_reg = Rdata1 + Ed32;
            BEQ:     if (Rdata1 == Rdata2)
                          newPC_reg = nextPC + 4 + {{14{Ins[15]}}, Ins[15:0], 2'b00};
            BNE:     if (Rdata1 != Rdata2)
                          newPC_reg = nextPC + 4 + {{14{Ins[15]}}, Ins[15:0], 2'b00};
            BGTZ:    if (sRdata1 > 0)
                          newPC_reg = nextPC + 4 + {{14{Ins[15]}}, Ins[15:0], 2'b00};
            BLEZ:    if (sRdata1 <= 0)
                          newPC_reg = nextPC + 4 + {{14{Ins[15]}}, Ins[15:0], 2'b00};
            J:       newPC_reg = {nextPC[31:28], Ins[25:0], 2'b00};
            JAL:     newPC_reg = {nextPC[31:28], Ins[25:0], 2'b00};
            6'd1: begin
                if (rt == BLTZ_r && sRdata1 < 0)
                    newPC_reg = nextPC + 4 + {{14{Ins[15]}}, Ins[15:0], 2'b00};
                else if (rt == BGEZ_r && sRdata1 >= 0)
                    newPC_reg = nextPC + 4 + {{14{Ins[15]}}, Ins[15:0], 2'b00};
            end
            default: ;
        endcase
    end

    // HI/LOレジスタ
    always @(posedge CLK) begin
        if (RST) begin
            hi_reg <= 32'd0;
            lo_reg <= 32'd0;
        end else if (op == R_FORM) begin
            case (func)
                MULT:  {hi_reg, lo_reg} <= $signed(Rdata1) * $signed(Rdata2);
                MULTU: {hi_reg, lo_reg} <= Rdata1 * Rdata2;
                DIV:   if (Rdata2 != 0) begin
                           lo_reg <= $signed(Rdata1) / $signed(Rdata2);
                           hi_reg <= $signed(Rdata1) % $signed(Rdata2);
                       end
                DIVU:  if (Rdata2 != 0) begin
                           lo_reg <= Rdata1 / Rdata2;
                           hi_reg <= Rdata1 % Rdata2;
                       end
                MTHI:  hi_reg <= Rdata1;
                MTLO:  lo_reg <= Rdata1;
                default:;
            endcase
        end
    end
endmodule