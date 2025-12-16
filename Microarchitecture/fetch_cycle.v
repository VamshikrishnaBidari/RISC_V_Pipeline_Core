module fetch_cycle (clk, rst, stallF, EN, flushD, InstrD, PCPlus4D, PCD, PCSrcE, PCTargetE);

    input clk, rst;
    input stallF, EN, flushD;
    input PCSrcE;
    input [31:0] PCTargetE;
    output [31:0] InstrD, PCPlus4D, PCD;

    wire [31:0] PCNextF, PCPlus4_F, PCF, InstrF;
    reg  [31:0] InstrF_reg, PCF_reg, PCPlus4F_reg;
    
    // Next PC mux
    Mux PC_Mux (
        .a(PCPlus4_F),
        .b(PCTargetE),
        .s(PCSrcE),
        .c(PCNextF)
    );

    // PC register: output PCF, input PCNextF, stall active-low
    P_C Program_Counter (
        .clk(clk),
        .rst(rst),
        .EN(stallF),
        .PC(PCF),
        .PC_NEXT(PCNextF)
    );

    // PC + 4
    PC_Adder PCadder_F (
        .c(PCPlus4_F),
        .a(PCF),
        .b(32'd4)
    );

    // Instruction memory
    instruction_memory Inst_Mem_F (
        .A(PCF), 
        .RD(InstrF), 
        .rst(rst)
    );                                                                                                                       

    // IF/ID pipeline regs
    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            InstrF_reg    <= 32'b0;
            PCF_reg       <= 32'b0;
            PCPlus4F_reg  <= 32'b0;
        end else if (flushD) begin
            InstrF_reg    <= 32'b0;
            PCF_reg       <= 32'b0;
            PCPlus4F_reg  <= 32'b0;
        end else if (!EN) begin
            InstrF_reg    <= InstrF;
            PCF_reg       <= PCF;
            PCPlus4F_reg  <= PCPlus4_F;
        end
        // else hold on stall
    end

    assign InstrD    = InstrF_reg;
    assign PCD       = PCF_reg;
    assign PCPlus4D  = PCPlus4F_reg;

endmodule