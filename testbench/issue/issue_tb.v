`include "../../core/riscv/riscv_defs.v"
`include "../../core/riscv/riscv_pipe_ctrl.v"
`include "../../core/riscv/riscv_regfile.v"
`include "../../core/riscv/riscv_issue.v"

module tb;
	reg           clk_i;
	reg           rst_i;
	reg           fetch_valid_i;
	reg  [ 31:0]  fetch_instr_i;
	reg  [ 31:0]  fetch_pc_i;
	reg           fetch_fault_fetch_i;
	reg           fetch_fault_page_i;
	reg           fetch_instr_exec_i;
	reg           fetch_instr_lsu_i;
	reg           fetch_instr_branch_i;
	reg           fetch_instr_mul_i;
	reg           fetch_instr_div_i;
	reg           fetch_instr_csr_i;
	reg           fetch_instr_rd_valid_i;
	reg           fetch_instr_invalid_i;
	reg           branch_exec_request_i;
	reg           branch_exec_is_taken_i;
	reg           branch_exec_is_not_taken_i;
	reg  [ 31:0]  branch_exec_source_i;
	reg           branch_exec_is_call_i;
	reg           branch_exec_is_ret_i;
	reg           branch_exec_is_jmp_i;
	reg  [ 31:0]  branch_exec_pc_i;
	reg           branch_d_exec_request_i;
	reg  [ 31:0]  branch_d_exec_pc_i;
	reg  [  1:0]  branch_d_exec_priv_i;
	reg           branch_csr_request_i;
	reg  [ 31:0]  branch_csr_pc_i;
	reg  [  1:0]  branch_csr_priv_i;
	reg  [ 31:0]  writeback_exec_value_i;
	reg           writeback_mem_valid_i;
	reg  [ 31:0]  writeback_mem_value_i;
	reg  [  5:0]  writeback_mem_exception_i;
	reg  [ 31:0]  writeback_mul_value_i;
	reg           writeback_div_valid_i;
	reg  [ 31:0]  writeback_div_value_i;
	reg  [ 31:0]  csr_result_e1_value_i;
	reg           csr_result_e1_write_i;
	reg  [ 31:0]  csr_result_e1_wdata_i;
	reg  [  5:0]  csr_result_e1_exception_i;
	reg           lsu_stall_i;
	reg           take_interrupt_i;
	wire          fetch_accept_o;
	wire          branch_request_o;
	wire [ 31:0]  branch_pc_o;
	wire [  1:0]  branch_priv_o;
	wire          exec_opcode_valid_o;
	wire          lsu_opcode_valid_o;
	wire          csr_opcode_valid_o;
	wire          mul_opcode_valid_o;
	wire          div_opcode_valid_o;
	wire [ 31:0]  opcode_opcode_o;
	wire [ 31:0]  opcode_pc_o;
	wire          opcode_invalid_o;
	wire [  4:0]  opcode_rd_idx_o;
	wire [  4:0]  opcode_ra_idx_o;
	wire [  4:0]  opcode_rb_idx_o;
	wire [ 31:0]  opcode_ra_operand_o;
	wire [ 31:0]  opcode_rb_operand_o;
	wire [ 31:0]  lsu_opcode_opcode_o;
	wire [ 31:0]  lsu_opcode_pc_o;
	wire          lsu_opcode_invalid_o;
	wire [  4:0]  lsu_opcode_rd_idx_o;
	wire [  4:0]  lsu_opcode_ra_idx_o;
	wire [  4:0]  lsu_opcode_rb_idx_o;
	wire [ 31:0]  lsu_opcode_ra_operand_o;
	wire [ 31:0]  lsu_opcode_rb_operand_o;
	wire [ 31:0]  mul_opcode_opcode_o;
	wire [ 31:0]  mul_opcode_pc_o;
	wire          mul_opcode_invalid_o;
	wire [  4:0]  mul_opcode_rd_idx_o;
	wire [  4:0]  mul_opcode_ra_idx_o;
	wire [  4:0]  mul_opcode_rb_idx_o;
	wire [ 31:0]  mul_opcode_ra_operand_o;
	wire [ 31:0]  mul_opcode_rb_operand_o;
	wire [ 31:0]  csr_opcode_opcode_o;
	wire [ 31:0]  csr_opcode_pc_o;
	wire          csr_opcode_invalid_o;
	wire [  4:0]  csr_opcode_rd_idx_o;
	wire [  4:0]  csr_opcode_ra_idx_o;
	wire [  4:0]  csr_opcode_rb_idx_o;
	wire [ 31:0]  csr_opcode_ra_operand_o;
	wire [ 31:0]  csr_opcode_rb_operand_o;
	wire          csr_writeback_write_o;
	wire [ 11:0]  csr_writeback_waddr_o;
	wire [ 31:0]  csr_writeback_wdata_o;
	wire [  5:0]  csr_writeback_exception_o;
	wire [ 31:0]  csr_writeback_exception_pc_o;
	wire [ 31:0]  csr_writeback_exception_addr_o;
	wire          exec_hold_o;
	wire          mul_hold_o;
	wire          interrupt_inhibit_o;
	riscv_issue dut (
		.clk_i(clk_i),
		.rst_i(rst_i),
		.fetch_valid_i(fetch_valid_i),
		.fetch_instr_i(fetch_instr_i),
		.fetch_pc_i(fetch_pc_i),
		.fetch_fault_fetch_i(fetch_fault_fetch_i),
		.fetch_fault_page_i(fetch_fault_page_i),
		.fetch_instr_exec_i(fetch_instr_exec_i),
		.fetch_instr_lsu_i(fetch_instr_lsu_i),
		.fetch_instr_branch_i(fetch_instr_branch_i),
		.fetch_instr_mul_i(fetch_instr_mul_i),
		.fetch_instr_div_i(fetch_instr_div_i),
		.fetch_instr_csr_i(fetch_instr_csr_i),
		.fetch_instr_rd_valid_i(fetch_instr_rd_valid_i),
		.fetch_instr_invalid_i(fetch_instr_invalid_i),
		.branch_exec_request_i(branch_exec_request_i),
		.branch_exec_is_taken_i(branch_exec_is_taken_i),
		.branch_exec_is_not_taken_i(branch_exec_is_not_taken_i),
		.branch_exec_source_i(branch_exec_source_i),
		.branch_exec_is_call_i(branch_exec_is_call_i),
		.branch_exec_is_ret_i(branch_exec_is_ret_i),
		.branch_exec_is_jmp_i(branch_exec_is_jmp_i),
		.branch_exec_pc_i(branch_exec_pc_i),
		.branch_d_exec_request_i(branch_d_exec_request_i),
		.branch_d_exec_pc_i(branch_d_exec_pc_i),
		.branch_d_exec_priv_i(branch_d_exec_priv_i),
		.branch_csr_request_i(branch_csr_request_i),
		.branch_csr_pc_i(branch_csr_pc_i),
		.branch_csr_priv_i(branch_csr_priv_i),
		.writeback_exec_value_i(writeback_exec_value_i),
		.writeback_mem_valid_i(writeback_mem_valid_i),
		.writeback_mem_value_i(writeback_mem_value_i),
		.writeback_mem_exception_i(writeback_mem_exception_i),
		.writeback_mul_value_i(writeback_mul_value_i),
		.writeback_div_valid_i(writeback_div_valid_i),
		.writeback_div_value_i(writeback_div_value_i),
		.csr_result_e1_value_i(csr_result_e1_value_i),
		.csr_result_e1_write_i(csr_result_e1_write_i),
		.csr_result_e1_wdata_i(csr_result_e1_wdata_i),
		.csr_result_e1_exception_i(csr_result_e1_exception_i),
		.lsu_stall_i(lsu_stall_i),
		.take_interrupt_i(take_interrupt_i),
		.fetch_accept_o(fetch_accept_o),
		.branch_request_o(branch_request_o),
		.branch_pc_o(branch_pc_o),
		.branch_priv_o(branch_priv_o),
		.exec_opcode_valid_o(exec_opcode_valid_o),
		.lsu_opcode_valid_o(lsu_opcode_valid_o),
		.csr_opcode_valid_o(csr_opcode_valid_o),
		.mul_opcode_valid_o(mul_opcode_valid_o),
		.div_opcode_valid_o(div_opcode_valid_o),
		.opcode_opcode_o(opcode_opcode_o),
		.opcode_pc_o(opcode_pc_o),
		.opcode_invalid_o(opcode_invalid_o),
		.opcode_rd_idx_o(opcode_rd_idx_o),
		.opcode_ra_idx_o(opcode_ra_idx_o),
		.opcode_rb_idx_o(opcode_rb_idx_o),
		.opcode_ra_operand_o(opcode_ra_operand_o),
		.opcode_rb_operand_o(opcode_rb_operand_o),
		.lsu_opcode_opcode_o(lsu_opcode_opcode_o),
		.lsu_opcode_pc_o(lsu_opcode_pc_o),
		.lsu_opcode_invalid_o(lsu_opcode_invalid_o),
		.lsu_opcode_rd_idx_o(lsu_opcode_rd_idx_o),
		.lsu_opcode_ra_idx_o(lsu_opcode_ra_idx_o),
		.lsu_opcode_rb_idx_o(lsu_opcode_rb_idx_o),
		.lsu_opcode_ra_operand_o(lsu_opcode_ra_operand_o),
		.lsu_opcode_rb_operand_o(lsu_opcode_rb_operand_o),
		.mul_opcode_opcode_o(mul_opcode_opcode_o),
		.mul_opcode_pc_o(mul_opcode_pc_o),
		.mul_opcode_invalid_o(mul_opcode_invalid_o),
		.mul_opcode_rd_idx_o(mul_opcode_rd_idx_o),
		.mul_opcode_ra_idx_o(mul_opcode_ra_idx_o),
		.mul_opcode_rb_idx_o(mul_opcode_rb_idx_o),
		.mul_opcode_ra_operand_o(mul_opcode_ra_operand_o),
		.mul_opcode_rb_operand_o(mul_opcode_rb_operand_o),
		.csr_opcode_opcode_o(csr_opcode_opcode_o),
		.csr_opcode_pc_o(csr_opcode_pc_o),
		.csr_opcode_invalid_o(csr_opcode_invalid_o),
		.csr_opcode_rd_idx_o(csr_opcode_rd_idx_o),
		.csr_opcode_ra_idx_o(csr_opcode_ra_idx_o),
		.csr_opcode_rb_idx_o(csr_opcode_rb_idx_o),
		.csr_opcode_ra_operand_o(csr_opcode_ra_operand_o),
		.csr_opcode_rb_operand_o(csr_opcode_rb_operand_o),
		.csr_writeback_write_o(csr_writeback_write_o),
		.csr_writeback_waddr_o(csr_writeback_waddr_o),
		.csr_writeback_wdata_o(csr_writeback_wdata_o),
		.csr_writeback_exception_o(csr_writeback_exception_o),
		.csr_writeback_exception_pc_o(csr_writeback_exception_pc_o),
		.csr_writeback_exception_addr_o(csr_writeback_exception_addr_o),
		.exec_hold_o(exec_hold_o),
		.mul_hold_o(mul_hold_o),
		.interrupt_inhibit_o(interrupt_inhibit_o)
	);
	integer seed;
	integer i;
	initial begin
		seed = 123;
		$dumpfile(".issue_tb.vcd");
		$dumpvars(0, tb);
		clk_i = 0;
		rst_i = 1;
		fetch_valid_i = 0;
		fetch_instr_i = 0;
		fetch_pc_i = 0;
		fetch_fault_fetch_i = 0;
		fetch_fault_page_i = 0;
		fetch_instr_exec_i = 0;
		fetch_instr_lsu_i = 0;
		fetch_instr_branch_i = 0;
		fetch_instr_mul_i = 0;
		fetch_instr_div_i = 0;
		fetch_instr_csr_i = 0;
		fetch_instr_rd_valid_i = 0;
		fetch_instr_invalid_i = 0;
		branch_exec_request_i = 0;
		branch_exec_is_taken_i = 0;
		branch_exec_is_not_taken_i = 0;
		branch_exec_source_i = 0;
		branch_exec_is_call_i = 0;
		branch_exec_is_ret_i = 0;
		branch_exec_is_jmp_i = 0;
		branch_exec_pc_i = 0;
		branch_d_exec_request_i = 0;
		branch_d_exec_pc_i = 0;
		branch_d_exec_priv_i = 0;
		branch_csr_request_i = 0;
		branch_csr_pc_i = 0;
		branch_csr_priv_i = 0;
		writeback_exec_value_i = 0;
		writeback_mem_valid_i = 0;
		writeback_mem_value_i = 0;
		writeback_mem_exception_i = 0;
		writeback_mul_value_i = 0;
		writeback_div_valid_i = 0;
		writeback_div_value_i = 0;
		csr_result_e1_value_i = 0;
		csr_result_e1_write_i = 0;
		csr_result_e1_wdata_i = 0;
		csr_result_e1_exception_i = 0;
		lsu_stall_i = 0;
		take_interrupt_i = 0;

		#1;
		rst_i = 0;

		for (i = 0; i < 1000; i+= 1) begin
			fetch_valid_i = $random(seed);
			fetch_instr_i = $random(seed);
			fetch_pc_i = $random(seed);
			fetch_fault_fetch_i = $random(seed);
			fetch_fault_page_i = $random(seed);
			fetch_instr_exec_i = $random(seed);
			fetch_instr_lsu_i = $random(seed);
			fetch_instr_branch_i = $random(seed);
			fetch_instr_mul_i = $random(seed);
			fetch_instr_div_i = $random(seed);
			fetch_instr_csr_i = $random(seed);
			fetch_instr_rd_valid_i = $random(seed);
			fetch_instr_invalid_i = $random(seed);
			branch_exec_request_i = $random(seed);
			branch_exec_is_taken_i = $random(seed);
			branch_exec_is_not_taken_i = $random(seed);
			branch_exec_source_i = $random(seed);
			branch_exec_is_call_i = $random(seed);
			branch_exec_is_ret_i = $random(seed);
			branch_exec_is_jmp_i = $random(seed);
			branch_exec_pc_i = $random(seed);
			branch_d_exec_request_i = $random(seed);
			branch_d_exec_pc_i = $random(seed);
			branch_d_exec_priv_i = $random(seed);
			branch_csr_request_i = $random(seed);
			branch_csr_pc_i = $random(seed);
			branch_csr_priv_i = $random(seed);
			writeback_exec_value_i = $random(seed);
			writeback_mem_valid_i = $random(seed);
			writeback_mem_value_i = $random(seed);
			writeback_mem_exception_i = $random(seed);
			writeback_mul_value_i = $random(seed);
			writeback_div_valid_i = $random(seed);
			writeback_div_value_i = $random(seed);
			csr_result_e1_value_i = $random(seed);
			csr_result_e1_write_i = $random(seed);
			csr_result_e1_wdata_i = $random(seed);
			csr_result_e1_exception_i = $random(seed);
			lsu_stall_i = $random(seed);
			take_interrupt_i = $random(seed);
			clk_i = 0;
			#1;
			clk_i = 1;
			#1;
		end
	end

endmodule