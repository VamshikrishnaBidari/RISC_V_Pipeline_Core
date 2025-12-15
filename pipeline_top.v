`include "Microarchitecture/fetch_cycle.v"
`include "Microarchitecture/decode_cycle.v"
`include "Microarchitecture/execute_cycle.v"
`include "Microarchitecture/writeback_cycle.v"
`include "Microarchitecture/datamem_cycle.v"
`include "Microarchitecture/hazard_unit.v"

module pipeline_top (clk, rst);

    input clk, rst;

    wire stallF, stallD, flushD, PCSrcE, flushE, RegWriteW, RegWriteE, ResultSrcE, MemWriteE, BranchE, ALUSrcE, RegWriteM, ResultSrcM, MemWriteM, ResultSrcW;
    wire [31:0] PCTargetE, InstrD, PCPlus4D, PCD, RD1E, RD2E, ImmExtE, PCPlus4E, ResultW, PCE, ALUResultM, WriteDataM, PCPlus4M, ReadDataW, PCPlus4W, ALUResultW;
    wire [4:0] RDW, RS1E, RS2E, RDE, RS1D, RS2D, RDM;
    wire [2:0] ALUControlE;
    wire [1:0] ForwardAE, ForwardBE;


    // module instantiations
    fetch_cycle FETCH (
        .clk(clk),
        .rst(rst),
        .EN(stallD),
        .flushD(flushD),
        .stallF(stallF),
        .InstrD(InstrD),
        .PCPlus4D(PCPlus4D),
        .PCD(PCD),
        .PCSrcE(PCSrcE),
        .PCTargetE(PCTargetE)
    );

    decode_cycle DECODE (
        .clk(clk), .rst(rst), .flushE(flushE),
        .InstrD(InstrD), .PCD(PCD), .PCPlus4D(PCPlus4D), .RS1D(RS1D), .RS2D(RS2D),
        .RegWriteW(RegWriteW), .RDW(RDW), .ResultW(ResultW), .RS1E(RS1E), .RS2E(RS2E), .RD1E(RD1E), .RD2E(RD2E), .ImmExtE(ImmExtE), .PCPlus4E(PCPlus4E), .RDE(RDE), .PCE(PCE),
        .RegWriteE(RegWriteE), .ResultSrcE(ResultSrcE), .MemWriteE(MemWriteE), .BranchE(BranchE), .ALUControlE(ALUControlE), .ALUSrcE(ALUSrcE)
    );


    execute_cycle EXECUTE (
        .clk(clk), .rst(rst),
        .RD1E(RD1E), .RD2E(RD2E), .ImmExtE(ImmExtE), .PCPlus4E(PCPlus4E), .RDE(RDE), .PCE(PCE), .ForwardAE(ForwardAE), .ForwardBE(ForwardBE), .ResultW(ResultW),
        .RegWriteE(RegWriteE), .ResultSrcE(ResultSrcE), .MemWriteE(MemWriteE), .BranchE(BranchE), .ALUControlE(ALUControlE), .ALUSrcE(ALUSrcE),
        .RegWriteM(RegWriteM), .ResultSrcM(ResultSrcM), .MemWriteM(MemWriteM), .ALUResultM(ALUResultM), .WriteDataM(WriteDataM), .RDM(RDM), .PCPlus4M(PCPlus4M), .PCTargetE(PCTargetE), .PCSrcE(PCSrcE)
    );

    datamem_cycle MEM (
        .clk(clk), .rst(rst), .RegWriteM(RegWriteM), .ResultSrcM(ResultSrcM), .MemWriteM(MemWriteM), .ALUResultM(ALUResultM), .WriteDataM(WriteDataM), .RDM(RDM), .PCPlus4M(PCPlus4M),
        .RegWriteW(RegWriteW), .ResultSrcW(ResultSrcW), .ReadDataW(ReadDataW), .RDW(RDW), .PCPlus4W(PCPlus4W), .ALUResultW(ALUResultW)
    );

    writeback_cycle WB(
        .clk(clk), .rst(rst), .ResultSrcW(ResultSrcW), .ReadDataW(ReadDataW), .ALUResultW(ALUResultW), .ResultW(ResultW)
    );

    // hazard detection unit
    hazard_unit HAZARD (
        .stallF(stallF), .stallD(stallD), .flushD(flushD), .flushE(flushE),
        .ForwardAE(ForwardAE), .ForwardBE(ForwardBE),
        .RS1D(RS1D), .RS2D(RS2D), .RS1E(RS1E), .RS2E(RS2E), .RDE(RDE), .RDM(RDM), .RDW(RDW),
        .PCSrcE(PCSrcE), .ResultSrcE(ResultSrcE),
        .RegWriteM(RegWriteM), .RegWriteW(RegWriteW)
    );

endmodule

// I am not using jal instruction in the design, so PCPlus4W is not used in the writeback stage