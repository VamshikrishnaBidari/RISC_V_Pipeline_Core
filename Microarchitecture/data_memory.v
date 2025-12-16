module data_memory(A, WD, WE, RD, clk, rst);
    input [31:0] A;      // Address input - byte addressed
    input [31:0] WD;     // Write data input
    input WE;            // Write enable
    input clk, rst;      // Clock and reset
    output [31:0] RD;    // Read data output

    // 1024 x 32-bit data memory
    reg [31:0] data_mem [0:1023];

    wire [9:0] waddr = A[31:2]; // Word aligned address

    // Read operation
    assign RD = (~rst)            ? 32'h00000000 :
                (waddr < 1024)    ? data_mem[waddr] :
                                     32'h00000000;

    // Write operation
    always @(posedge clk) begin
        if (WE) begin
            data_mem[waddr] <= WD;
        end
    end
endmodule