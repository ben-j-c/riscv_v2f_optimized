`include "../../core/riscv/riscv_defs.v"
`include "../../core/riscv/riscv_alu.v"
`include "../../core/riscv/riscv_csr.v"
`include "../../core/riscv/riscv_decode.v"
`include "../../core/riscv/riscv_divider.v"
`include "../../core/riscv/riscv_exec.v"
`include "../../core/riscv/riscv_fetch.v"
`include "../../core/riscv/riscv_issue.v"
`include "../../core/riscv/riscv_lsu.v"
`include "../../core/riscv/riscv_mmu.v"
`include "../../core/riscv/riscv_pipe_ctrl.v"
`include "../../core/riscv/riscv_regfile.v"
`include "../../core/riscv/riscv_core.v"

module tb;
	wire          clk_i;
	wire          rst_i;
	wire [ 31:0]  mem_d_data_rd_i; // port
	wire          mem_d_accept_i;// constant 1
	wire          mem_d_ack_i; // enable piped
	wire          mem_d_error_i; // constant 0
	wire [ 10:0]  mem_d_resp_tag_i; // need to be piped
	wire          mem_i_accept_i; // constant 1
	wire          mem_i_valid_i; // constant 1
	wire          mem_i_error_i; // constant 0
	wire [ 31:0]  mem_i_inst_i; // port
	wire          intr_i; // constant 0
	wire [ 31:0]  reset_vector_i; // constant 0
	wire [ 31:0]  cpu_id_i; // constant 0
	wire [ 31:0]  mem_d_addr_o; // port
	wire [ 31:0]  mem_d_data_wr_o; // port
	wire          mem_d_rd_o; // enable
	wire [  3:0]  mem_d_wr_o; // important
	wire          mem_d_cacheable_o; // dont care
	wire [ 10:0]  mem_d_req_tag_o; // need to be piped
	wire          mem_d_invalidate_o; // dont care
	wire          mem_d_writeback_o;
	wire          mem_d_flush_o; // dont care
	wire          mem_i_rd_o;
	wire          mem_i_flush_o; // dont care
	wire          mem_i_invalidate_o; // dont care
	wire [ 31:0]  mem_i_pc_o;
	riscv_core dut (
		.clk_i(clk_i),
		.rst_i(rst_i),
		.mem_d_data_rd_i(mem_d_data_rd_i),
		.mem_d_accept_i(mem_d_accept_i),
		.mem_d_ack_i(mem_d_ack_i),
		.mem_d_error_i(mem_d_error_i),
		.mem_d_resp_tag_i(mem_d_resp_tag_i),
		.mem_i_accept_i(mem_i_accept_i),
		.mem_i_valid_i(mem_i_valid_i),
		.mem_i_error_i(mem_i_error_i),
		.mem_i_inst_i(mem_i_inst_i),
		.intr_i(intr_i),
		.reset_vector_i(reset_vector_i),
		.cpu_id_i(cpu_id_i),
		.mem_d_addr_o(mem_d_addr_o),
		.mem_d_data_wr_o(mem_d_data_wr_o),
		.mem_d_rd_o(mem_d_rd_o),
		.mem_d_wr_o(mem_d_wr_o),
		.mem_d_cacheable_o(mem_d_cacheable_o),
		.mem_d_req_tag_o(mem_d_req_tag_o),
		.mem_d_invalidate_o(mem_d_invalidate_o),
		.mem_d_writeback_o(mem_d_writeback_o),
		.mem_d_flush_o(mem_d_flush_o),
		.mem_i_rd_o(mem_i_rd_o),
		.mem_i_flush_o(mem_i_flush_o),
		.mem_i_invalidate_o(mem_i_invalidate_o),
		.mem_i_pc_o(mem_i_pc_o)
	);
	integer seed;
	integer i;
	initial begin
		seed = 123;
		$dumpfile("core_tb.vcd");
		$dumpvars(0, tb);

	end

endmodule