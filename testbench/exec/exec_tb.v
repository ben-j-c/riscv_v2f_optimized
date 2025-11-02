`include "../../core/riscv/riscv_defs.v"
`include "../../core/riscv/riscv_alu.v"
`include "../../core/riscv/riscv_exec.v"

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
	reg           hold_i;
	wire          branch_request_o;
	wire          branch_is_taken_o;
	wire          branch_is_not_taken_o;
	wire [ 31:0]  branch_source_o;
	wire          branch_is_call_o;
	wire          branch_is_ret_o;
	wire          branch_is_jmp_o;
	wire [ 31:0]  branch_pc_o;
	wire          branch_d_request_o;
	wire [ 31:0]  branch_d_pc_o;
	wire [  1:0]  branch_d_priv_o;
	wire [ 31:0]  writeback_value_o;
	riscv_exec dut (
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
		.hold_i(hold_i),
		.branch_request_o(branch_request_o),
		.branch_is_taken_o(branch_is_taken_o),
		.branch_is_not_taken_o(branch_is_not_taken_o),
		.branch_source_o(branch_source_o),
		.branch_is_call_o(branch_is_call_o),
		.branch_is_ret_o(branch_is_ret_o),
		.branch_is_jmp_o(branch_is_jmp_o),
		.branch_pc_o(branch_pc_o),
		.branch_d_request_o(branch_d_request_o),
		.branch_d_pc_o(branch_d_pc_o),
		.branch_d_priv_o(branch_d_priv_o),
		.writeback_value_o(writeback_value_o)
	);
	integer seed;
	integer i;
	initial begin
		seed = 123;
		$dumpfile("exec_tb.vcd");
		$dumpvars(0, tb);
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
		hold_i = 0;

		#1;
		rst_i = 0;

		for (i = 0; i < 1000; i+= 1) begin
			clk_i = 0;
			opcode_valid_i = $random(seed);
			opcode_opcode_i = $random(seed);
			opcode_pc_i = $random(seed);
			opcode_invalid_i = $random(seed);
			opcode_rd_idx_i = $random(seed);
			opcode_ra_idx_i = $random(seed);
			opcode_rb_idx_i = $random(seed);
			opcode_ra_operand_i = $random(seed);
			opcode_rb_operand_i = $random(seed);
			hold_i = $random(seed);
			#1;
			clk_i = 1;
			#1;
		end
	end

endmodule