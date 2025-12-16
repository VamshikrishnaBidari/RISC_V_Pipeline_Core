module decode_cycle(clk, rst, flushE,
                    InstrD, PCD, PCPlus4D, RS1D, RS2D,
                    RegWriteW, RDW, ResultW, RS1E, RS2E, RD1E, RD2E, ImmExtE, PCPlus4E, RDE, PCE,
                    RegWriteE, ResultSrcE, MemWriteE, BranchE, ALUControlE, ALUSrcE);
    input clk, rst;
    input [31:0] InstrD, PCD, PCPlus4D;
    input RegWriteW;
    input [4:0] RDW;
    input [31:0] ResultW;
    input flushE;
    output [4:0] RS1D, RS2D;
    output [4:0] RS1E, RS2E;
    output [31:0] RD1E, RD2E, ImmExtE, PCPlus4E;
    output [4:0] RDE;
    output [31:0] PCE;
    output RegWriteE, ResultSrcE, MemWriteE, BranchE;
    output [2:0] ALUControlE;
    output ALUSrcE;

    // combinational decode outputs (D stage)
    wire RegWriteD, ResultSrcD, MemWriteD, BranchD, ALUSrcD;
    wire [2:0] ALUControlD;

    // register file outputs (D stage)
    wire [31:0] RD1D, RD2D, ImmExtD;
    wire [1:0]  ImmSrcD;

    assign RS1D = InstrD[19:15];
    assign RS2D = InstrD[24:20];

    // pipeline registers to E stage
    reg RegWriteE_r, ResultSrcE_r, MemWriteE_r, BranchE_r, ALUSrcE_r;
    reg [2:0] ALUControlE_r;
    reg [31:0] RD1E_r, RD2E_r, ImmExtE_r, PCPlus4E_r, PCE_r;
    reg [4:0] RDE_r, RS1E_r, RS2E_r;

    // register file
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

    // immediate generation
    sign_extend u_sign_extend (
        .In(InstrD),
        .ImmExt(ImmExtD),
        .ImmSrc(ImmSrcD)
    );

    // main/control decode (combinational)
    Control_Unit_Top u_cut (
        .opcode(InstrD[6:0]),
        .funct7(InstrD[31:25]),
        .funct3(InstrD[14:12]),
        .RegWrite(RegWriteD),
        .MemWrite(MemWriteD),
        .Branch(BranchD),
        .ALUSrc(ALUSrcD),
        .ResultSrc(ResultSrcD),
        .ImmSrc(ImmSrcD),
        .ALUControl(ALUControlD)
    );

    // sequential pipeline regs D->E
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            RegWriteE_r   <= 1'b0;
            ResultSrcE_r  <= 1'b0;
            MemWriteE_r   <= 1'b0;
            BranchE_r     <= 1'b0;
            ALUSrcE_r     <= 1'b0;
            ALUControlE_r <= 3'b0;
            RD1E_r        <= 32'b0;
            RD2E_r        <= 32'b0;
            ImmExtE_r     <= 32'b0;
            PCPlus4E_r    <= 32'b0;
            PCE_r         <= 32'b0;
            RDE_r         <= 5'b0;
            RS1E_r        <= 5'b0;
            RS2E_r        <= 5'b0;
        end else if (flushE) begin
            RegWriteE_r   <= 1'b0;
            ResultSrcE_r  <= 1'b0;
            MemWriteE_r   <= 1'b0;
            BranchE_r     <= 1'b0;
            ALUSrcE_r     <= 1'b0;
            ALUControlE_r <= 3'b0;
            RD1E_r        <= 32'b0;
            RD2E_r        <= 32'b0;
            ImmExtE_r     <= 32'b0;
            PCPlus4E_r    <= 32'b0;
            PCE_r         <= 32'b0;
            RDE_r         <= 5'b0;
            RS1E_r        <= 5'b0;
            RS2E_r        <= 5'b0;
        end else begin
            RegWriteE_r   <= RegWriteD;
            ResultSrcE_r  <= ResultSrcD;
            MemWriteE_r   <= MemWriteD;
            BranchE_r     <= BranchD;
            ALUSrcE_r     <= ALUSrcD;
            ALUControlE_r <= ALUControlD;
            RD1E_r        <= RD1D;
            RD2E_r        <= RD2D;
            ImmExtE_r     <= ImmExtD;
            PCPlus4E_r    <= PCPlus4D;
            PCE_r         <= PCD;
            RDE_r         <= InstrD[11:7];
            RS1E_r        <= RS1D;
            RS2E_r        <= RS2D;
        end
    end

    // outputs to EX stage
    assign RS1E       = RS1E_r;
    assign RS2E       = RS2E_r;
    assign RD1E       = RD1E_r;
    assign RD2E       = RD2E_r;
    assign ImmExtE    = ImmExtE_r;
    assign PCPlus4E   = PCPlus4E_r;
    assign PCE        = PCE_r;
    assign RDE        = RDE_r;
    assign RegWriteE  = RegWriteE_r;
    assign ResultSrcE = ResultSrcE_r;
    assign MemWriteE  = MemWriteE_r;
    assign BranchE    = BranchE_r;
    assign ALUControlE= ALUControlE_r;
    assign ALUSrcE    = ALUSrcE_r;

endmodule