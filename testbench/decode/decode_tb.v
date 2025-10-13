`include "../../core/riscv/riscv_defs.v"
`include "../../core/riscv/riscv_decode.v"

module tb;
    reg           clk_i;
    reg           rst_i;
    reg           fetch_in_valid_i;
    reg  [ 31:0]  fetch_in_instr_i;
    reg  [ 31:0]  fetch_in_pc_i;
    reg           fetch_in_fault_fetch_i;
    reg           fetch_in_fault_page_i;
    reg           fetch_out_accept_i;
    reg           squash_decode_i;
    wire          fetch_in_accept_o;
    wire          fetch_out_valid_o;
    wire [ 31:0]  fetch_out_instr_o;
    wire [ 31:0]  fetch_out_pc_o;
    wire          fetch_out_fault_fetch_o;
    wire          fetch_out_fault_page_o;
    wire          fetch_out_instr_exec_o;
    wire          fetch_out_instr_lsu_o;
    wire          fetch_out_instr_branch_o;
    wire          fetch_out_instr_mul_o;
    wire          fetch_out_instr_div_o;
    wire          fetch_out_instr_csr_o;
    wire          fetch_out_instr_rd_valid_o;
    wire          fetch_out_instr_invalid_o;

	riscv_decode dut (
		.clk_i(clk_i),
		.rst_i(rst_i),
		.fetch_in_valid_i(fetch_in_valid_i),
		.fetch_in_instr_i(fetch_in_instr_i),
		.fetch_in_pc_i(fetch_in_pc_i),
		.fetch_in_fault_fetch_i(fetch_in_fault_fetch_i),
		.fetch_in_fault_page_i(fetch_in_fault_page_i),
		.fetch_out_accept_i(fetch_out_accept_i),
		.squash_decode_i(squash_decode_i),
		.fetch_in_accept_o(fetch_in_accept_o),
		.fetch_out_valid_o(fetch_out_valid_o),
		.fetch_out_instr_o(fetch_out_instr_o),
		.fetch_out_pc_o(fetch_out_pc_o),
		.fetch_out_fault_fetch_o(fetch_out_fault_fetch_o),
		.fetch_out_fault_page_o(fetch_out_fault_page_o),
		.fetch_out_instr_exec_o(fetch_out_instr_exec_o),
		.fetch_out_instr_lsu_o(fetch_out_instr_lsu_o),
		.fetch_out_instr_branch_o(fetch_out_instr_branch_o),
		.fetch_out_instr_mul_o(fetch_out_instr_mul_o),
		.fetch_out_instr_div_o(fetch_out_instr_div_o),
		.fetch_out_instr_csr_o(fetch_out_instr_csr_o),
		.fetch_out_instr_rd_valid_o(fetch_out_instr_rd_valid_o),
		.fetch_out_instr_invalid_o(fetch_out_instr_invalid_o)
	);

	integer seed;
	integer i;
	initial begin
		$dumpfile("tb.vcd");
		$dumpvars(1, tb);

		seed = 123;
		for (i = 0; i < 10000; i = i + 1) begin
			clk_i = $random(seed);
			rst_i = $random(seed);
			fetch_in_valid_i = $random(seed);
			fetch_in_instr_i = $random(seed);
			fetch_in_pc_i = $random(seed);
			fetch_in_fault_fetch_i = $random(seed);
			fetch_in_fault_page_i = $random(seed);
			fetch_out_accept_i = $random(seed);
			squash_decode_i = $random(seed);
			#1;
		end
		$finish;
	end
endmodule