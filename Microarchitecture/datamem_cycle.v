module datamem_cycle (clk, rst, RegWriteM, ResultSrcM, MemWriteM, ALUResultM, WriteDataM, RDM, PCPlus4M,
                    RegWriteW, ResultSrcW, ReadDataW, RDW, PCPlus4W, ALUResultW);
    
    input clk, rst;
    input RegWriteM, ResultSrcM, MemWriteM;
    input [31:0] ALUResultM, WriteDataM, PCPlus4M;
    input [4:0] RDM;
    output RegWriteW, ResultSrcW;
    output [31:0] ReadDataW, PCPlus4W, ALUResultW;
    output [4:0] RDW;

    wire [31:0] ReadDataM;

    // pipeline registers
    reg RegWriteM_r, ResultSrcM_r;
    reg [31:0] ALUResultM_r, ReadDataM_r, PCPlus4M_r;
    reg [4:0] RDM_r;

    // module instantiations
    data_memory u_data_memory (.A(ALUResultM), .WD(WriteDataM), .WE(MemWriteM), .RD(ReadDataM), .clk(clk), .rst(rst));

    // sequential logic for pipeline registers
    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            RegWriteM_r    <= 1'b0;
            ResultSrcM_r   <= 1'b0;
            ALUResultM_r   <= 32'b0;
            ReadDataM_r    <= 32'b0;
            PCPlus4M_r     <= 32'b0;
            RDM_r          <= 5'b0;
        end else begin
            RegWriteM_r    <= RegWriteM;
            ResultSrcM_r   <= ResultSrcM;
            ALUResultM_r   <= ALUResultM;
            ReadDataM_r    <= ReadDataM;
            PCPlus4M_r     <= PCPlus4M;
            RDM_r          <= RDM;
        end
    end

    // output assignments
    assign RegWriteW = RegWriteM_r;
    assign ResultSrcW = ResultSrcM_r;
    assign ReadDataW = ReadDataM_r;
    assign PCPlus4W = PCPlus4M_r;
    assign RDW = RDM_r;
    assign ALUResultW = ALUResultM_r;

endmodule