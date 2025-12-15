module writeback_cycle(clk, rst, ResultSrcW, ReadDataW, ALUResultW, ResultW);
    input clk, rst;
    input ResultSrcW;
    input [31:0] ReadDataW, ALUResultW;
    output [31:0] ResultW;


    // module instantiations
    Mux result_mux (.a(ReadDataW), .b(ALUResultW), .s(ResultSrcW), .c(ResultW));

endmodule