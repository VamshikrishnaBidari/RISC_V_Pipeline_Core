`include "register_file.v"
`include "sign_extend.v"
`include "/ControlUnit/control_unit_top.v"

module decode_cycle(clk, rst, flushE,
                    InstrD, PCD, PCPlus4D, RS1D, RS2D,
                    RegWriteW, RDW, ResultW, RS1E, RS2E, RD1E, RD2E, ImmExtE, PCPlus4E, RDE, PCE,
                    RegWriteE, ResultSrcE, MemWriteE, BranchE, ALUControlE, ALUSrcE);
        input clk, rst;
        input [31:0] InstrD, PCD, PCPlus4D;
        input RegWriteW;
        input [4:0] RDW;
        input [31:0] ResultW;
        output [31:0] RD1E, RD2E, ImmExtE, PCPlus4E;
        output [4:0] RDE;
        output [31:0] PCE;
        output RegWriteE, ResultSrcE, MemWriteE, BranchE;
        output [2:0] ALUControlE;
        output ALUSrcE;
        output [4:0] RS1D, RS2D;
        input flushE;
        output [4:0] RS1E, RS2E;

        // internal wires. later
        wire [31:0] RD1D, RD2D, ImmExtD;
        wire [1:0] ImmSrcD;
        
        assign RS1D = InstrD[19:15];
        assign RS2D = InstrD[24:20];

        // pipeline registers
        reg RegWriteD_r, ResultSrcD_r, MemWriteD_r, BranchD_r, ALUSrcD_r;
        reg [2:0] ALUControlD_r;
        reg [31:0] RD1D_r, RD2D_r, ImmExtD_r, PCPlus4D_r, PCD_r;
        reg [4:0] RDD_r, RS1D_r, RS2D_r;

        // module instantiations
        register_file u_register_file (
            .clk(clk),
            .rst(rst),
            .WE3(RegWriteW),
            .A1(InstrD[19:15]), 
            .A2(InstrD[24:20]), 
            .A3(RDW), 
            .WD3(ResultW), 
            .RD1(RD1D), 
            .RD2(RD2D)
        );

        sign_extend u_sign_extend (
            .In(InstrD), .ImmExt(ImmExtD), .ImmSrc(ImmSrcD)
        );

        control_unit_top u_cut (
            .opcode(InstrD[6:0]),
            .funct7(InstrD[31:25]),
            .funct3(InstrD[14:12]),
            .RegWrite(RegWriteE),
            .MemWrite(MemWriteE),
            .Branch(BranchE),
            .ALUSrc(ALUSrcE),
            .ResultSrc(ResultSrcE),
            .ImmSrc(ImmSrcD),
            .ALUControl(ALUControlE)
        );

        // sequential logic for pipeline registers
        always @(posedge clk or negedge rst) begin
            if(!rst) begin
                // reset all pipeline registers
                RegWriteD_r <= 1'b0;
                ResultSrcD_r <= 1'b0;
                MemWriteD_r <= 1'b0;
                BranchD_r <= 1'b0;
                ALUSrcD_r <= 1'b0;
                ALUControlD_r <= 3'b0;
                RD1D_r <= 32'b0;
                RD2D_r <= 32'b0;
                ImmExtD_r <= 32'b0;
                PCPlus4D_r <= 32'b0;
                PCD_r <= 32'b0;
                RDD_r <= 5'b0;
                RS1D <= 5'b0;
                RS2D <= 5'b0;
            end else if (flushE) begin
                // flush pipeline registers on flush signal
                RegWriteD_r <= 1'b0;
                ResultSrcD_r <= 1'b0;
                MemWriteD_r <= 1'b0;
                BranchD_r <= 1'b0;
                ALUSrcD_r <= 1'b0;
                ALUControlD_r <= 3'b0;
                RD1D_r <= 32'b0;
                RD2D_r <= 32'b0;
                ImmExtD_r <= 32'b0;
                PCPlus4D_r <= 32'b0;
                PCD_r <= 32'b0;
                RDD_r <= 5'b0;
                RS1D <= 5'b0;
                RS2D <= 5'b0;
            end else begin
                // capture values into pipeline registers
                RegWriteD_r <= RegWriteE;
                ResultSrcD_r <= ResultSrcE;
                MemWriteD_r <= MemWriteE;
                BranchD_r <= BranchE;
                ALUSrcD_r <= ALUSrcE;
                ALUControlD_r <= ALUControlE;
                RD1D_r <= RD1D;
                RD2D_r <= RD2D;
                ImmExtD_r <= ImmExtD;
                PCPlus4D_r <= PCPlus4D;
                PCD_r <= PCD;
                RDD_r <= InstrD[11:7];
                RS1D_r <= RS1D;
                RS2D_r <= RS2D;
            end
        end

        // output assignments
        assign RS1E = RS1D_r;
        assign RS2E = RS2D_r;
        assign RD1E = RD1D_r;
        assign RD2E = RD2D_r;
        assign ImmExtE = ImmExtD_r;
        assign PCPlus4E = PCPlus4D_r;
        assign PCE = PCD_r;
        assign RDE = RDD_r;
        assign RegWriteE = RegWriteD_r;
        assign ResultSrcE = ResultSrcD_r;
        assign MemWriteE = MemWriteD_r;
        assign BranchE = BranchD_r;
        assign ALUControlE = ALUControlD_r;
        assign ALUSrcE = ALUSrcD_r;

endmodule