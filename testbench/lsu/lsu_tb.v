`include "../../core/riscv/riscv_defs.v"
`include "../../core/riscv/riscv_lsu.v"

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
	reg  [ 31:0]  mem_data_rd_i;
	reg           mem_accept_i;
	reg           mem_ack_i;
	reg           mem_error_i;
	reg  [ 10:0]  mem_resp_tag_i;
	reg           mem_load_fault_i;
	reg           mem_store_fault_i;
	wire [ 31:0]  mem_addr_o;
	wire [ 31:0]  mem_data_wr_o;
	wire          mem_rd_o;
	wire [  3:0]  mem_wr_o;
	wire          mem_cacheable_o;
	wire [ 10:0]  mem_req_tag_o;
	wire          mem_invalidate_o;
	wire          mem_writeback_o;
	wire          mem_flush_o;
	wire          writeback_valid_o;
	wire [ 31:0]  writeback_value_o;
	wire [  5:0]  writeback_exception_o;
	wire          stall_o;


	riscv_lsu dut (
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
		.mem_data_rd_i(mem_data_rd_i),
		.mem_accept_i(mem_accept_i),
		.mem_ack_i(mem_ack_i),
		.mem_error_i(mem_error_i),
		.mem_resp_tag_i(mem_resp_tag_i),
		.mem_load_fault_i(mem_load_fault_i),
		.mem_store_fault_i(mem_store_fault_i),
		.mem_addr_o(mem_addr_o),
		.mem_data_wr_o(mem_data_wr_o),
		.mem_rd_o(mem_rd_o),
		.mem_wr_o(mem_wr_o),
		.mem_cacheable_o(mem_cacheable_o),
		.mem_req_tag_o(mem_req_tag_o),
		.mem_invalidate_o(mem_invalidate_o),
		.mem_writeback_o(mem_writeback_o),
		.mem_flush_o(mem_flush_o),
		.writeback_valid_o(writeback_valid_o),
		.writeback_value_o(writeback_value_o),
		.writeback_exception_o(writeback_exception_o),
		.stall_o(stall_o)
	);
	integer seed;
	integer i;
	initial begin
		seed = 123;
		$dumpfile(".lsu_tb.vcd");
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
		mem_data_rd_i = 0;
		mem_accept_i = 0;
		mem_ack_i = 0;
		mem_error_i = 0;
		mem_resp_tag_i = 0;
		mem_load_fault_i = 0;
		mem_store_fault_i = 0;

		#1;
		rst_i = 0;

		for (i = 0; i < 1000; i+= 1) begin
			opcode_valid_i = $random(seed);
			opcode_opcode_i = $random(seed);
			opcode_pc_i = $random(seed);
			opcode_invalid_i = $random(seed);
			opcode_rd_idx_i = $random(seed);
			opcode_ra_idx_i = $random(seed);
			opcode_rb_idx_i = $random(seed);
			opcode_ra_operand_i = $random(seed);
			opcode_rb_operand_i = $random(seed);
			mem_data_rd_i = $random(seed);
			mem_accept_i = $random(seed);
			mem_ack_i = $random(seed);
			mem_error_i = $random(seed);
			mem_resp_tag_i = $random(seed);
			mem_load_fault_i = $random(seed);
			mem_store_fault_i = $random(seed);
			clk_i = 0;
			#1;
			clk_i = 1;
			#1;
		end
	end

endmodule