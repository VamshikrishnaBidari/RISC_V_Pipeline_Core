`include "alu_decoder.v"
`include "main_decoder.v"

module Control_Unit_Top (
    input  [6:0] opcode, funct7,
    input  [2:0] funct3,
    output       RegWrite, MemWrite, Branch, ALUSrc, ResultSrc,
    output [1:0] ImmSrc,
    output [2:0] ALUControl
);
    wire [1:0] ALUOp;
    wire       op5      = opcode[5];
    wire       funct7_5 = funct7[5];

    main_decoder u_main_decoder (
        .op(opcode),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .ALUOp(ALUOp),
        .Branch(Branch)
    );

    alu_decoder u_alu_decoder (
        .ALUOp(ALUOp),
        .op5(op5),
        .funct7_5(funct7_5),
        .funct3(funct3),
        .aluControl(ALUControl)
    );

endmodule