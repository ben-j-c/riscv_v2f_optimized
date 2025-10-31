`include "../../core/riscv/riscv_defs.v"
`include "../../core/riscv/riscv_pipe_ctrl.v"

module tb;
	reg           clk_i;
	reg           rst_i;

	// Issue
	reg           issue_valid_i;
	reg           issue_accept_i;
	reg           issue_stall_i;
	reg           issue_lsu_i;
	reg           issue_csr_i;
	reg           issue_div_i;
	reg           issue_mul_i;
	reg           issue_branch_i;
	reg           issue_rd_valid_i;
	reg  [4:0]    issue_rd_i;
	reg  [5:0]    issue_exception_i;
	reg           take_interrupt_i;
	reg           issue_branch_taken_i;
	reg [31:0]    issue_branch_target_i;
	reg [31:0]    issue_pc_i;
	reg [31:0]    issue_opcode_i;
	reg [31:0]    issue_operand_ra_i;
	reg [31:0]    issue_operand_rb_i;

	// Execution stage 1: ALU result
	reg [31:0]    alu_result_e1_i;

	// Execution stage 1: CSR read result / early exceptions
	reg [ 31:0]   csr_result_value_e1_i;
	reg           csr_result_write_e1_i;
	reg [ 31:0]   csr_result_wdata_e1_i;
	reg [  5:0]   csr_result_exception_e1_i;

	// Execution stage 1
	wire          load_e1_o;
	wire          store_e1_o;
	wire          mul_e1_o;
	wire          branch_e1_o;
	wire [  4:0]  rd_e1_o;
	wire [31:0]   pc_e1_o;
	wire [31:0]   opcode_e1_o;
	wire [31:0]   operand_ra_e1_o;
	wire [31:0]   operand_rb_e1_o;

	// Execution stage 2: Other results
	reg           mem_complete_i;
	reg [31:0]    mem_result_e2_i;
	reg  [5:0]    mem_exception_e2_i;
	reg [31:0]    mul_result_e2_i;

	// Execution stage 2
	wire          load_e2_o;
	wire          mul_e2_o;
	wire [  4:0]  rd_e2_o;
	wire [31:0]   result_e2_o;

	reg           div_complete_i;
	reg  [31:0]   div_result_i;
	wire          valid_wb_o;
	wire          csr_wb_o;
	wire [  4:0]  rd_wb_o;
	wire [31:0]   result_wb_o;
	wire [31:0]   pc_wb_o;
	wire [31:0]   opcode_wb_o;
	wire [31:0]   operand_ra_wb_o;
	wire [31:0]   operand_rb_wb_o;
	wire [5:0]    exception_wb_o;
	wire          csr_write_wb_o;
	wire [11:0]   csr_waddr_wb_o;
	wire [31:0]   csr_wdata_wb_o;
	wire          stall_o;
	wire          squash_e1_e2_o;
	reg           squash_e1_e2_i;
	reg           squash_wb_i;

	riscv_pipe_ctrl dut(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.issue_valid_i(issue_valid_i),
		.issue_accept_i(issue_accept_i),
		.issue_stall_i(issue_stall_i),
		.issue_lsu_i(issue_lsu_i),
		.issue_csr_i(issue_csr_i),
		.issue_div_i(issue_div_i),
		.issue_mul_i(issue_mul_i),
		.issue_branch_i(issue_branch_i),
		.issue_rd_valid_i(issue_rd_valid_i),
		.issue_rd_i(issue_rd_i),
		.issue_exception_i(issue_exception_i),
		.take_interrupt_i(take_interrupt_i),
		.issue_branch_taken_i(issue_branch_taken_i),
		.issue_branch_target_i(issue_branch_target_i),
		.issue_pc_i(issue_pc_i),
		.issue_opcode_i(issue_opcode_i),
		.issue_operand_ra_i(issue_operand_ra_i),
		.issue_operand_rb_i(issue_operand_rb_i),
		.alu_result_e1_i(alu_result_e1_i),
		.csr_result_value_e1_i(csr_result_value_e1_i),
		.csr_result_write_e1_i(csr_result_write_e1_i),
		.csr_result_wdata_e1_i(csr_result_wdata_e1_i),
		.csr_result_exception_e1_i(csr_result_exception_e1_i),
		.load_e1_o(load_e1_o),
		.store_e1_o(store_e1_o),
		.mul_e1_o(mul_e1_o),
		.branch_e1_o(branch_e1_o),
		.rd_e1_o(rd_e1_o),
		.pc_e1_o(pc_e1_o),
		.opcode_e1_o(opcode_e1_o),
		.operand_ra_e1_o(operand_ra_e1_o),
		.operand_rb_e1_o(operand_rb_e1_o),
		.mem_complete_i(mem_complete_i),
		.mem_result_e2_i(mem_result_e2_i),
		.mem_exception_e2_i(mem_exception_e2_i),
		.mul_result_e2_i(mul_result_e2_i),
		.load_e2_o(load_e2_o),
		.mul_e2_o(mul_e2_o),
		.rd_e2_o(rd_e2_o),
		.result_e2_o(result_e2_o),
		.div_complete_i(div_complete_i),
		.div_result_i(div_result_i),
		.valid_wb_o(valid_wb_o),
		.csr_wb_o(csr_wb_o),
		.rd_wb_o(rd_wb_o),
		.result_wb_o(result_wb_o),
		.pc_wb_o(pc_wb_o),
		.opcode_wb_o(opcode_wb_o),
		.operand_ra_wb_o(operand_ra_wb_o),
		.operand_rb_wb_o(operand_rb_wb_o),
		.exception_wb_o(exception_wb_o),
		.csr_write_wb_o(csr_write_wb_o),
		.csr_waddr_wb_o(csr_waddr_wb_o),
		.csr_wdata_wb_o(csr_wdata_wb_o),
		.stall_o(stall_o),
		.squash_e1_e2_o(squash_e1_e2_o),
		.squash_e1_e2_i(squash_e1_e2_i),
		.squash_wb_i(squash_wb_i)
	);
	integer i;
	integer seed;
	initial begin
		seed = 123;
		$dumpfile(".pipe_ctrl_tb.vcd");
		$dumpvars(0, tb);
		clk_i = 0;
		rst_i = 1;
		#1;
		clk_i = 1;
		for (i = 0; i < 10000 ; i += 1 ) begin
			// For all reg, $random(seed)
			issue_valid_i = $random(seed);
			issue_accept_i = $random(seed);
			issue_stall_i = $random(seed);
			issue_lsu_i = $random(seed);
			issue_csr_i = $random(seed);
			issue_div_i = $random(seed);
			issue_mul_i = $random(seed);
			issue_branch_i = $random(seed);
			issue_rd_valid_i = $random(seed);
			issue_rd_i = $random(seed);
			issue_exception_i = $random(seed);
			take_interrupt_i = $random(seed);
			issue_branch_taken_i = $random(seed);
			issue_branch_target_i = $random(seed);
			issue_pc_i = $random(seed);
			issue_opcode_i = $random(seed);
			issue_operand_ra_i = $random(seed);
			issue_operand_rb_i = $random(seed);
			alu_result_e1_i = $random(seed);
			csr_result_value_e1_i = $random(seed);
			csr_result_write_e1_i = $random(seed);
			csr_result_wdata_e1_i = $random(seed);
			csr_result_exception_e1_i = $random(seed);
			mem_complete_i = $random(seed);
			mem_result_e2_i = $random(seed);
			mem_exception_e2_i = $random(seed);
			mul_result_e2_i = $random(seed);
			div_complete_i = $random(seed);
			div_result_i = $random(seed);
			squash_e1_e2_i = $random(seed);
			squash_wb_i = $random(seed);
			#1;
			clk_i = ~clk_i;
			rst_i = 0;
		end
	end
endmodule