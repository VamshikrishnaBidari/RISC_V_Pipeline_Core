module PC_Adder(c, a, b);
    input [31:0] a, b;          // 32-bit input operands
    output [31:0] c;            // 32-bit output result

    assign c = a + b;           // Perform addition
endmodule