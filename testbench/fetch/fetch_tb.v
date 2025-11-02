`include "../../core/riscv/riscv_defs.v"
`include "../../core/riscv/riscv_fetch.v"

module tb;
	// Inputs
	reg           clk_i;
	reg           rst_i;
	reg           fetch_accept_i;
	reg           icache_accept_i;
	reg           icache_valid_i;
	reg           icache_error_i;
	reg  [ 31:0]  icache_inst_i;
	reg           icache_page_fault_i;
	reg           fetch_invalidate_i;
	reg           branch_request_i;
	reg  [ 31:0]  branch_pc_i;
	reg  [  1:0]  branch_priv_i;
	wire          fetch_valid_o;
	wire [ 31:0]  fetch_instr_o;
	wire [ 31:0]  fetch_pc_o;
	wire          fetch_fault_fetch_o;
	wire          fetch_fault_page_o;
	wire          icache_rd_o;
	wire          icache_flush_o;
	wire          icache_invalidate_o;
	wire [ 31:0]  icache_pc_o;
	wire [  1:0]  icache_priv_o;
	wire          squash_decode_o;
	riscv_fetch dut (
		.clk_i(clk_i),
		.rst_i(rst_i),
		.fetch_accept_i(fetch_accept_i),
		.icache_accept_i(icache_accept_i),
		.icache_valid_i(icache_valid_i),
		.icache_error_i(icache_error_i),
		.icache_inst_i(icache_inst_i),
		.icache_page_fault_i(icache_page_fault_i),
		.fetch_invalidate_i(fetch_invalidate_i),
		.branch_request_i(branch_request_i),
		.branch_pc_i(branch_pc_i),
		.branch_priv_i(branch_priv_i),
		.fetch_valid_o(fetch_valid_o),
		.fetch_instr_o(fetch_instr_o),
		.fetch_pc_o(fetch_pc_o),
		.fetch_fault_fetch_o(fetch_fault_fetch_o),
		.fetch_fault_page_o(fetch_fault_page_o),
		.icache_rd_o(icache_rd_o),
		.icache_flush_o(icache_flush_o),
		.icache_invalidate_o(icache_invalidate_o),
		.icache_pc_o(icache_pc_o),
		.icache_priv_o(icache_priv_o),
		.squash_decode_o(squash_decode_o)
	);
	integer seed;
	integer i;
	initial begin
		seed = 123;
		$dumpfile("fetch_tb.vcd");
		$dumpvars(0, tb);
		clk_i = 0;
		rst_i = 1;
		fetch_accept_i = 0;
		icache_accept_i = 0;
		icache_valid_i = 0;
		icache_error_i = 0;
		icache_inst_i = 0;
		icache_page_fault_i = 0;
		fetch_invalidate_i = 0;
		branch_request_i = 0;
		branch_pc_i = 0;
		branch_priv_i = 0;

		#1;
		rst_i = 0;

		for (i = 0; i < 1000; i+= 1) begin
			fetch_accept_i = $random(seed);
			icache_accept_i = $random(seed);
			icache_valid_i = $random(seed);
			icache_error_i = $random(seed);
			icache_inst_i = $random(seed);
			icache_page_fault_i = $random(seed);
			fetch_invalidate_i = $random(seed);
			branch_request_i = $random(seed);
			branch_pc_i = $random(seed);
			branch_priv_i = $random(seed);
			clk_i = 0;
			#1;
			clk_i = 1;
			#1;
		end
	end

endmodule