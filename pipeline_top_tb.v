`timescale 1ns/1ps

module pipeline_top_tb;

	reg clk;
	reg rst;

	pipeline_top dut (
		.clk(clk),
		.rst(rst)
	);

	// clock generation: 10ns period
	initial begin
		clk = 1'b0;
		forever #5 clk = ~clk;
	end

	// stimulus and checks
	initial begin
		integer errors;
		errors = 0;

		// hold reset low, preload memories and registers
		rst = 1'b0;

		// load program, data memory, and initial register file contents
		$readmemh("imem.hex", dut.FETCH.Inst_Mem_F.memory);
		$readmemh("dmem.hex", dut.MEM.u_data_memory.data_mem);
		$readmemh("regs.hex", dut.DECODE.u_register_file.reg_file);

		// deassert reset after setup
		#1 rst = 1'b1;

		// run long enough for pipeline to complete
		repeat (40) @(posedge clk);

		// expected results
		if (dut.DECODE.u_register_file.reg_file[23] !== 32'h00000008) begin
			$display("ERROR: s7(x23) expected 0x00000008, got 0x%08h", dut.DECODE.u_register_file.reg_file[23]);
			errors = errors + 1;
		end

		if (dut.DECODE.u_register_file.reg_file[24] !== 32'h0000000A) begin
			$display("ERROR: s8(x24) expected 0x0000000A, got 0x%08h", dut.DECODE.u_register_file.reg_file[24]);
			errors = errors + 1;
		end

		if (dut.DECODE.u_register_file.reg_file[7] !== 32'h0000003A) begin
			$display("ERROR: t2(x7) expected 0x0000003A, got 0x%08h", dut.DECODE.u_register_file.reg_file[7]);
			errors = errors + 1;
		end

		if (errors == 0)
			$display("TEST PASSED");
		else
			$display("TEST FAILED with %0d error(s)", errors);

		$finish;
	end

	// optional waveform dump
	initial begin
		$dumpfile("wave.vcd");
		$dumpvars(0, pipeline_top_tb);
	end

endmodule
