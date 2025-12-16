module register_file(clk, rst, WE3, A1, A2, A3, WD3, RD1, RD2);
    input clk, rst;               // Clock and reset signals
    input WE3;                    // Write enable for register 3
    input [4:0] A1, A2, A3;      // Register addresses
    input [31:0] WD3;            // Write data for register 3
    output [31:0] RD1, RD2;      // Read data outputs

    // 32 x 32-bit register file
    reg [31:0] reg_file [31:0];


    // Read operations
    // Read with same-cycle bypass
    assign RD1 = (!rst) ? 32'b0 :
                 (WE3 && (A1 == A3) && (A3 != 5'd0)) ? WD3 : reg_file[A1];

    assign RD2 = (!rst) ? 32'b0 :
                 (WE3 && (A2 == A3) && (A3 != 5'd0)) ? WD3 : reg_file[A2];
    // Write operation
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            // On reset, initialize all registers to zero
            integer i;
            for (i = 0; i < 32; i = i + 1) begin
                reg_file[i] <= 32'b0;
            end
        end else if (WE3 && A3 != 5'd0) begin
            reg_file[A3] <= WD3; // Write data to register A3
        end
    end
endmodule