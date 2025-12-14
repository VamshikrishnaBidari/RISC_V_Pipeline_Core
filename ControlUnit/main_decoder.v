module main_decoder(op, RegWrite, MemWrite, ResultSrc, ALUSrc, ImmSrc, ALUOp, Branch);
    input  [6:0] op;
    output       RegWrite, MemWrite, ResultSrc, ALUSrc, Branch;
    output [1:0] ImmSrc, ALUOp;

    wire is_r   = (op == 7'b0110011);
    wire is_lw  = (op == 7'b0000011);
    wire is_sw  = (op == 7'b0100011);
    wire is_beq = (op == 7'b1100011);

    assign RegWrite  = is_r | is_lw;
    assign MemWrite  = is_sw;
    assign ResultSrc = is_lw;
    assign ALUSrc    = is_lw | is_sw;
    assign Branch    = is_beq;

    assign ImmSrc = is_sw ? 2'b01 :
                    is_beq ? 2'b10 :
                             2'b00;

    assign ALUOp = is_beq ? 2'b01 :
                   is_r   ? 2'b10 :
                            2'b00;
endmodule