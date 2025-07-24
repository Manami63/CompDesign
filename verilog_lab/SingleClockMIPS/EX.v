module EX(CLK, RST, Ins, Rdata1, Rdata2, Ed32, nextPC, Result, newPC);
`include "common_param.vh"
 input CLK, RST;
 input [31:0] Ins, Rdata, Rdata2, Ed32, nextPC;
 output [31:0] Result, newPC;

    assign (Result, newPC) = ALU(Ins, Rdata1, Rdata2, Ed32, nextPC);

    function[63:0] ALU;
        input [31:0] Ins, Rdata1, Rdata2, Ed32, nextPC;
        begin
            case (Ins[31:26])         //先頭の6 bitがオペレーションコード 
                R_FORM:               //6'd0:    // R from
                    begin
                        case (Ins[5:0])
                            ADD:        //　それぞれの処理かく 
                                ALU = Rdata1 + Rdata2;
                            ADDU:
                                ALU = $unsigned(Rata1) + $unsigned(Rdata2);
                            SUB:
                                ALU = Rdata1 - Rdata2;
                            SUBU:
                                ALU = $unsigned(Rdata1) - $unsigned(Rdata2);
                            AND:
                                ALU = Rdata1 & Rdata2;
                            OR:
                                ALU = Rdata1 | Rdata2;
                            XOR:
                                ALU = Rdata1 ^ Rdata2;
                            NOR:
                                ALU = ~(Rdata1 | Rdata2);
                            SLT:    //比較  
                                begin
                                    if(Rdata1 < Rdata2)
                                end
                            SLTU:
                        default

                        endcase
                    end
                ADDI:
                    ALU = Rdata1 + Ed32;
            default
            endcase
        end

    endfunction

endmodule

// hi, low, rdのデータ移動命令と，掛け算？分岐命令？はfunctionじゃなくてalwaysで記述する
// ALU = (Result, newPC)