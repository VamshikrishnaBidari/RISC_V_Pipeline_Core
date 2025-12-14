module P_C(clk, rst, PC, PC_NEXT);
    input clk, rst;
    input [31:0] PC_NEXT;
    output reg [31:0] PC;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            PC <= 32'h00000000; // Reset PC to 0
        end else begin
            PC <= PC_NEXT; // Update PC to next value
        end
    end
endmodule