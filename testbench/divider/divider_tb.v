`include "../../core/riscv/riscv_defs.v"
`include "../../core/riscv/riscv_divider.v"

module tb;
	reg           clk_i;
	reg           rst_i;
	reg           opcode_valid_i;
	reg  [ 31:0]  opcode_opcode_i;
	reg  [ 31:0]  opcode_pc_i;
	reg           opcode_invalid_i;
	reg  [  4:0]  opcode_rd_idx_i;
	reg  [  4:0]  opcode_ra_idx_i;
	reg  [  4:0]  opcode_rb_idx_i;
	reg  [ 31:0]  opcode_ra_operand_i;
	reg  [ 31:0]  opcode_rb_operand_i;
	wire          writeback_valid_o;
	wire [ 31:0]  writeback_value_o;

	riscv_divider dut (
		.clk_i(clk_i),
		.rst_i(rst_i),
		.opcode_valid_i(opcode_valid_i),
		.opcode_opcode_i(opcode_opcode_i),
		.opcode_pc_i(opcode_pc_i),
		.opcode_invalid_i(opcode_invalid_i),
		.opcode_rd_idx_i(opcode_rd_idx_i),
		.opcode_ra_idx_i(opcode_ra_idx_i),
		.opcode_rb_idx_i(opcode_rb_idx_i),
		.opcode_ra_operand_i(opcode_ra_operand_i),
		.opcode_rb_operand_i(opcode_rb_operand_i),
		.writeback_valid_o(writeback_valid_o),
		.writeback_value_o(writeback_value_o)
	);

	integer seed;
	integer i;

	initial begin
		$dumpfile(".divider_tb.vcd");
		$dumpvars(1, tb);

		clk_i = 0;
		rst_i = 1;
		opcode_valid_i = 0;
		opcode_opcode_i = 0;
		opcode_pc_i = 0;
		opcode_invalid_i = 0;
		opcode_rd_idx_i = 0;
		opcode_ra_idx_i = 0;
		opcode_rb_idx_i = 0;
		opcode_ra_operand_i = 0;
		opcode_rb_operand_i = 0;
		#1;
		rst_i = 0;
		opcode_valid_i = 1;
		for (i = 0; i < 10000; i += 1) begin
			if (i % 4 == 0) begin
				opcode_opcode_i = `INST_DIV;
			end else if (i % 4 == 1) begin
				opcode_opcode_i = `INST_DIVU;
			end else if (i % 4 == 2) begin
				opcode_opcode_i = `INST_REM;
			end else if (i % 4 == 3) begin
				opcode_opcode_i = `INST_REMU;
			end
			clk_i = 0;
			opcode_ra_operand_i = $random(seed);
			opcode_rb_operand_i = $random(seed);
			#1;
			clk_i = 1;
			#1;
			
		end
	end

endmodule