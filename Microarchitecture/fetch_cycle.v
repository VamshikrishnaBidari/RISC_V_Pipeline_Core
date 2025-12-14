`include "instruction_memory.v"
`include "PC_Adder.v"
`include "P_C.v"
`include "mux.v"

module fetch_cycle (clk, rst, InstrD, PCPlus4D, PCD, PCSrcE, PCTargetE);

    input clk, rst;
    input PCSrcE;
    input [31:0] PCTargetE;
    output [31:0] InstrD, PCPlus4D, PCD;

    wire [31:0] PC_F, PCPlus4_F, PCF, InstrF;
    reg [31:0] InstrF_reg, PCF_reg, PCPlus4F_reg;
    
    // module declarations
    Mux PC_Mux (.a(PCPlus4_F),
                .b(PCTargetE),
                .s(PCSrcE),
                .c(PC_F));

    P_C Program_Counter (.clk(clk),
                        .rst(rst),
                        .PC(PC_F),
                        .PC_NEXT(PCF));

    PC_Adder PCadder_F (.c(PCPlus4_F),
                        .a(PCF),
                        .b(32'd4));

    instruction_memory Inst_Mem_F  (.A(PCF), 
                                    .RD(InstrF), 
                                    .rst(rst));

    // sequential logic
    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            InstrF_reg <= 32'b0;
            PCF_reg <= 32'b0;
            PCPlus4F_reg <= 32'b0;
        end
        else begin
            InstrF_reg <= InstrF;
            PCF_reg <= PCF;
            PCPlus4F_reg <= PCPlus4_F;
        end
    end

    // output assignments
    assign InstrD = InstrF_reg;
    assign PCD = PCF_reg;
    assign PCPlus4D = PCPlus4F_reg;

endmodule