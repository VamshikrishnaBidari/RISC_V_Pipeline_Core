module instruction_memory(A, RD, rst);

    input [31:0] A;
    input rst;
    output [31:0] RD;

    // 1024 x 32-bit instruction memory
    reg [31:0] memory [1023:0];

    assign RD = (rst==1'b0)? {32{1'b0}} : memory [A[31:2]];

endmodule