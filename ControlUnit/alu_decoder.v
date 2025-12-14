module alu_decoder(ALUOp, op5, funct7_5, funct3, aluControl);
    // Input and output declarations
    input [1:0] ALUOp;
    input op5;               // Bit 5 of the opcode
    input funct7_5;         // Bit 5 of funct7
    input [2:0] funct3;     // funct3 field
    output [2:0] aluControl;

    // concatenate op5 and funct7_5 to form a 2-bit signal
    wire [1:0] op5_funct7_5;
    assign op5_funct7_5 = {op5, funct7_5};

    // ALU control signal generation based on ALUOp and instruction fields
    assign aluControl = (ALUOp == 2'b00) ? 3'b000 :                     // Load/Store: ADD
                        (ALUOp == 2'b01) ? 3'b001 :                     // Branch: SUB
                        (ALUOp == 2'b10 && funct3 == 3'b010) ? 3'b101 : // SLT
                        (ALUOp == 2'b10 && funct3 == 3'b110) ? 3'b011 : // OR
                        (ALUOp == 2'b10 && funct3 == 3'b111) ? 3'b010 : // AND
                        (ALUOp == 2'b10 && funct3 == 3'b000 && op5_funct7_5 == 2'b11) ? 3'b001 : // SUB
                        (ALUOp == 2'b10 && funct3 == 3'b000 && op5_funct7_5 != 2'b11) ? 3'b000 : // ADD
                        3'b000; // Default case
endmodule                            