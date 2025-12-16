module instruction_memory(A, RD, rst);

    input [31:0] A;
    input rst;
    output [31:0] RD;

    // 1024 x 32-bit instruction memory
    reg [31:0] memory [0:1023];

    // safe read: return NOP on reset or out-of-range
    assign RD = (rst == 1'b0)             ? 32'h00000013 :         // NOP during reset
                (A[31:2] < 1024)          ? memory[A[31:2]] :
                                            32'h00000013;          // NOP for OOB

endmodule