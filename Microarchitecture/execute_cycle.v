`include "PC_Adder.v"
`include "/ALU/alu.v"
`include "mux.v"

module execute_cycle(clk, rst,
                    RD1E, RD2E, ImmExtE, PCPlus4E, RDE, PCE,
                    RegWriteE, ResultSrcE, MemWriteE, BranchE, ALUControlE, ALUSrcE,
                    RegWriteM, ResultSrcM, MemWriteM, ALUResultM, WriteDataM, RDM, PCPlus4M, PCTargetE, PCSrcE);
        input clk, rst;
        input [31:0] RD1E, RD2E, ImmExtE, PCPlus4E, PCE;
        input [4:0] RDE;
        input RegWriteE, ResultSrcE, MemWriteE, BranchE;
        input [2:0] ALUControlE;
        input ALUSrcE;
        output RegWriteM, ResultSrcM, MemWriteM;
        output [31:0] ALUResultM, WriteDataM, PCPlus4M;
        output [4:0] RDM;
        output [31:0] PCTargetE;
        output PCSrcE;

        wire [31:0] SrcBE, ALUResultE;
        wire zeroE;

        // pipeline registers
        reg RegWriteE_r, ResultSrcE_r, MemWriteE_r;
        reg [31:0] ALUResultE_r, WriteDataE_r, PCPlus4E_r;
        reg [4:0] RDE_r;

        // module instantiations
        mux u_alu_src_mux (
            .a(RD2E),
            .b(ImmExtE),
            .s(ALUSrcE),
            .c(SrcBE)
        );

        alu u_alu (
            .A(RD1E), .B(SrcBE), .aluControl(ALUControlE), .result(ALUResultE), .Z(zeroE), .V(), .N(), .C()
        );

        PC_Adder u_pc_adder (
            .c(PCTargetE), .a(PCE), .b(ImmExtE)
        );

        // sequential logic for pipeline registers
        always @(posedge clk or negedge rst) begin
            if(!rst) begin
                RegWriteE_r   <= 1'b0;
                ResultSrcE_r  <= 1'b0;
                MemWriteE_r   <= 1'b0;
                ALUResultE_r  <= 32'b0;
                WriteDataE_r  <= 32'b0;
                PCPlus4E_r    <= 32'b0;
                RDE_r         <= 5'b0;
            end else begin
                RegWriteE_r   <= RegWriteE;
                ResultSrcE_r  <= ResultSrcE;
                MemWriteE_r   <= MemWriteE;
                ALUResultE_r  <= ALUResultE;
                WriteDataE_r  <= RD2E;
                PCPlus4E_r    <= PCPlus4E;
                RDE_r         <= RDE;
            end
        end

        // output assignments
        assign PCSrcE = BranchE & zeroE;
        assign RegWriteM = RegWriteE_r;
        assign ResultSrcM = ResultSrcE_r;
        assign MemWriteM = MemWriteE_r;
        assign ALUResultM = ALUResultE_r;
        assign WriteDataM = WriteDataE_r;
        assign PCPlus4M = PCPlus4E_r;
        assign RDM = RDE_r;
        
endmodule