module P_C(clk, rst, EN, PC, PC_NEXT);
    input clk, rst, EN;
    input [31:0] PC_NEXT;
    output reg [31:0] PC;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            PC <= 32'h00000000; // Reset PC to 0
        end else if (!EN) begin // active low enable
            PC <= PC_NEXT;      // Update PC when enabled
        end
        // else hold PC on stall
    end
endmodule