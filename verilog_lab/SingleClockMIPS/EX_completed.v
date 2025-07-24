
module EX(CLK, RST, Ins, Rdata1, Rdata2, Ed32, nextPC, Result, newPC);
`include "common_param.vh"
input CLK, RST;
input [31:0] Ins, Rdata1, Rdata2, Ed32, nextPC;
output [31:0] Result, newPC;

reg [31:0] HI, LO;
reg [31:0] Result_reg, newPC_reg;
assign Result = Result_reg;
assign newPC = newPC_reg;

always @(*) begin
    Result_reg = ALU(Ins, Rdata1, Rdata2, Ed32, nextPC);

    // newPC default: sequential
    newPC_reg = nextPC + 4;

    case (Ins[31:26])
        J: begin
            newPC_reg = {nextPC[31:28], Ins[25:0], 2'b00}; // absolute jump
        end
        JAL: begin
            newPC_reg = {nextPC[31:28], Ins[25:0], 2'b00};
        end
        BEQ: begin
            if (Rdata1 == Rdata2)
                newPC_reg = nextPC + 4 + {{14{Ins[15]}}, Ins[15:0], 2'b00}; // PC-relative
        end
        BNE: begin
            if (Rdata1 != Rdata2)
                newPC_reg = nextPC + 4 + {{14{Ins[15]}}, Ins[15:0], 2'b00};
        end
        BGTZ: begin
            if ($signed(Rdata1) > 0)
                newPC_reg = nextPC + 4 + {{14{Ins[15]}}, Ins[15:0], 2'b00};
        end
        BLEZ: begin
            if ($signed(Rdata1) <= 0)
                newPC_reg = nextPC + 4 + {{14{Ins[15]}}, Ins[15:0], 2'b00};
        end
        6'd1: begin // BLTZ/BGEZ
            if (Ins[20:16] == BLTZ_r && $signed(Rdata1) < 0)
                newPC_reg = nextPC + 4 + {{14{Ins[15]}}, Ins[15:0], 2'b00};
            else if (Ins[20:16] == BGEZ_r && $signed(Rdata1) >= 0)
                newPC_reg = nextPC + 4 + {{14{Ins[15]}}, Ins[15:0], 2'b00};
        end
        R_FORM: begin
            case (Ins[5:0])
                JR: newPC_reg = Rdata1;
                JALR: newPC_reg = Rdata1;
            endcase
        end
    endcase
end

// HI, LO update
always @(posedge CLK) begin
    if (RST) begin
        HI <= 32'd0;
        LO <= 32'd0;
    end else begin
        case (Ins[31:26])
            R_FORM: begin
                case (Ins[5:0])
                    MULT:  {HI, LO} <= $signed(Rdata1) * $signed(Rdata2);
                    MULTU: {HI, LO} <= Rdata1 * Rdata2;
                    DIV: if (Rdata2 != 0) begin
                        LO <= $signed(Rdata1) / $signed(Rdata2);
                        HI <= $signed(Rdata1) % $signed(Rdata2);
                    end
                    DIVU: if (Rdata2 != 0) begin
                        LO <= Rdata1 / Rdata2;
                        HI <= Rdata1 % Rdata2;
                    end
                    MTHI: HI <= Rdata1;
                    MTLO: LO <= Rdata1;
                endcase
            end
        endcase
    end
end

function [31:0] ALU;
    input [31:0] Ins, Rdata1, Rdata2, Ed32, nextPC;
    reg [4:0] shamt;
    begin
        shamt = Ins[10:6];
        case (Ins[31:26])
            R_FORM: begin
                case (Ins[5:0])
                    ADD:  ALU = Rdata1 + Rdata2;
                    ADDU: ALU = Rdata1 + Rdata2;
                    SUB:  ALU = Rdata1 - Rdata2;
                    SUBU: ALU = Rdata1 - Rdata2;
                    AND:  ALU = Rdata1 & Rdata2;
                    OR:   ALU = Rdata1 | Rdata2;
                    XOR:  ALU = Rdata1 ^ Rdata2;
                    NOR:  ALU = ~(Rdata1 | Rdata2);
                    SLT:  ALU = ($signed(Rdata1) < $signed(Rdata2)) ? 32'd1 : 32'd0;
                    SLTU: ALU = (Rdata1 < Rdata2) ? 32'd1 : 32'd0;
                    SLL:  ALU = Rdata2 << shamt;
                    SRL:  ALU = Rdata2 >> shamt;
                    SRA:  ALU = $signed(Rdata2) >>> shamt;
                    MFHI: ALU = HI;
                    MFLO: ALU = LO;
                    default: ALU = 32'hDEADBEEF;
                endcase
            end
            ADDI:  ALU = Rdata1 + Ed32;
            ADDIU: ALU = Rdata1 + Ed32;
            ANDI:  ALU = Rdata1 & {16'd0, Ed32[15:0]};
            ORI:   ALU = Rdata1 | {16'd0, Ed32[15:0]};
            XORI:  ALU = Rdata1 ^ {16'd0, Ed32[15:0]};
            SLTI:  ALU = ($signed(Rdata1) < $signed(Ed32)) ? 32'd1 : 32'd0;
            SLTIU: ALU = (Rdata1 < Ed32) ? 32'd1 : 32'd0;
            default: ALU = 32'hDEADBEEF;
        endcase
    end
endfunction

endmodule
