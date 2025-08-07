// common_param.vh

// グローバルなdefineマクロとして記述
`define WIDTH        32
`define IMEM_SIZE    128
`define REGFILE_SIZE 32
`define DMEM_SIZE    128

`define R_FORM   6'd0
`define LW       6'd35
`define SW_OP    6'd43

`define ADD      6'd32
`define ADDU     6'd33
`define SUB      6'd34
`define SUBU     6'd35
`define AND      6'd36
`define OR       6'd37
`define XOR      6'd38
`define NOR      6'd39
`define SLT      6'd42
`define SLTU     6'd43

`define ADDI     6'd8
`define ADDIU    6'd9
`define SLTI     6'd10
`define SLTIU    6'd11
`define ANDI     6'd12
`define ORI      6'd13
`define XORI     6'd14
//`define LUI      6'd15

`define SLL      6'd0
`define SRL      6'd2
`define SRA      6'd3
`define SLLV     6'd4
`define SRLV     6'd6
`define SRAV     6'd7

`define MFHI     6'd16
`define MTHI     6'd17
`define MFLO     6'd18
`define MTLO     6'd19
`define MULT     6'd24
`define MULTU    6'd25
`define DIV      6'd26
`define DIVU     6'd27

`define JR       6'd8
`define JALR     6'd9

`define BLTZ     6'd1
`define BGEZ     6'd1
`define J        6'd2
`define JAL      6'd3
`define BEQ      6'd4
`define BNE      6'd5
`define BLEZ     6'd6
`define BGTZ     6'd7

`define BLTZ_r   5'd0
`define BGEZ_r   5'd1
