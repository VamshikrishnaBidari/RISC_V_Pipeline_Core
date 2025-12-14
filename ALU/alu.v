module alu (
    A, B, aluControl, result, Z, V, N, C
);
    input [31:0] A, B;
    input [2:0] aluControl;
    output [31:0] result;
    output Z, V, N, C;

    // declaring interim wires
    wire [31:0] a_and_b, a_or_b, not_b, mux_1, sum, mux_2, slt;
    wire carry_out;

    // logic design
    assign a_and_b = A & B;          // AND operation
    assign a_or_b = A | B;           // OR operation
    assign not_b = ~B;               // NOT operation on B

    // 2-to-1 MUX for selecting between B and NOT B
    assign mux_1 = (aluControl[0] == 1'b0) ? B : not_b;
    assign {carry_out, sum} = A + mux_1 + aluControl[0];          // ADD operation
    assign slt = {{31{1'b0}}, sum[31]};  // Set on Less Than operation

    // 4-to-1 MUX for final result selection
    assign mux_2 = (aluControl[2:0] == 3'b000) ? sum :
                   (aluControl[2:0] == 3'b001) ? sum :
                   (aluControl[2:0] == 3'b010) ? a_and_b :
                   (aluControl[2:0] == 3'b011) ? a_or_b :
                   (aluControl[2:0] == 3'b101) ? slt : 32'h00000000;
    
    assign result = mux_2;
    assign Z = &(~result);               // Zero flag
    assign N = result[31];               // Negative flag
    assign C = carry_out & ~aluControl[1];// Carry flag
    assign V = (~aluControl[1]) & (A[31] ^ sum[31]) & (~(aluControl[0] ^ A[31] ^ B[31])); // Overflow flag
endmodule