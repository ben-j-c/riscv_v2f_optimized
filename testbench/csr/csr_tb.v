`include "../../core/riscv/riscv_defs.v"
`include "../../core/riscv/riscv_csr.v"

module tb;
	reg           clk_i;
	reg           rst_i;
	reg           intr_i;
	reg           opcode_valid_i;
	reg  [ 31:0]  opcode_opcode_i;
	reg  [ 31:0]  opcode_pc_i;
	reg           opcode_invalid_i;
	reg  [  4:0]  opcode_rd_idx_i;
	reg  [  4:0]  opcode_ra_idx_i;
	reg  [  4:0]  opcode_rb_idx_i;
	reg  [ 31:0]  opcode_ra_operand_i;
	reg  [ 31:0]  opcode_rb_operand_i;
	reg           csr_writeback_write_i;
	reg  [ 11:0]  csr_writeback_waddr_i;
	reg  [ 31:0]  csr_writeback_wdata_i;
	reg  [  5:0]  csr_writeback_exception_i;
	reg  [ 31:0]  csr_writeback_exception_pc_i;
	reg  [ 31:0]  csr_writeback_exception_addr_i;
	reg  [ 31:0]  cpu_id_i;
	reg  [ 31:0]  reset_vector_i;
	reg           interrupt_inhibit_i;
	wire [ 31:0]  csr_result_e1_value_o;
	wire          csr_result_e1_write_o;
	wire [ 31:0]  csr_result_e1_wdata_o;
	wire [  5:0]  csr_result_e1_exception_o;
	wire          branch_csr_request_o;
	wire [ 31:0]  branch_csr_pc_o;
	wire [  1:0]  branch_csr_priv_o;
	wire          take_interrupt_o;
	wire          ifence_o;
	wire [  1:0]  mmu_priv_d_o;
	wire          mmu_sum_o;
	wire          mmu_mxr_o;
	wire          mmu_flush_o;
	wire [ 31:0]  mmu_satp_o;

	riscv_csr dut (
		.clk_i(clk_i),
		.rst_i(rst_i),
		.intr_i(intr_i),
		.opcode_valid_i(opcode_valid_i),
		.opcode_opcode_i(opcode_opcode_i),
		.opcode_pc_i(opcode_pc_i),
		.opcode_invalid_i(opcode_invalid_i),
		.opcode_rd_idx_i(opcode_rd_idx_i),
		.opcode_ra_idx_i(opcode_ra_idx_i),
		.opcode_rb_idx_i(opcode_rb_idx_i),
		.opcode_ra_operand_i(opcode_ra_operand_i),
		.opcode_rb_operand_i(opcode_rb_operand_i),
		.csr_writeback_write_i(csr_writeback_write_i),
		.csr_writeback_waddr_i(csr_writeback_waddr_i),
		.csr_writeback_wdata_i(csr_writeback_wdata_i),
		.csr_writeback_exception_i(csr_writeback_exception_i),
		.csr_writeback_exception_pc_i(csr_writeback_exception_pc_i),
		.csr_writeback_exception_addr_i(csr_writeback_exception_addr_i),
		.cpu_id_i(cpu_id_i),
		.reset_vector_i(reset_vector_i),
		.interrupt_inhibit_i(interrupt_inhibit_i),
		.csr_result_e1_value_o(csr_result_e1_value_o),
		.csr_result_e1_write_o(csr_result_e1_write_o),
		.csr_result_e1_wdata_o(csr_result_e1_wdata_o),
		.csr_result_e1_exception_o(csr_result_e1_exception_o),
		.branch_csr_request_o(branch_csr_request_o),
		.branch_csr_pc_o(branch_csr_pc_o),
		.branch_csr_priv_o(branch_csr_priv_o),
		.take_interrupt_o(take_interrupt_o),
		.ifence_o(ifence_o),
		.mmu_priv_d_o(mmu_priv_d_o),
		.mmu_sum_o(mmu_sum_o),
		.mmu_mxr_o(mmu_mxr_o),
		.mmu_flush_o(mmu_flush_o),
		.mmu_satp_o(mmu_satp_o)
	);
	integer seed;
	integer i;
	initial begin
		seed = 123;
		$dumpfile(".csr_tb.vcd");
		$dumpvars(1, tb);
		clk_i = 0;
		rst_i = 0;
		intr_i = 0;
		opcode_valid_i = 0;
		opcode_opcode_i = 0;
		opcode_pc_i = 0;
		opcode_invalid_i = 0;
		opcode_rd_idx_i = 0;
		opcode_ra_idx_i = 0;
		opcode_rb_idx_i = 0;
		opcode_ra_operand_i = 0;
		opcode_rb_operand_i = 0;
		csr_writeback_write_i = 0;
		csr_writeback_waddr_i = 0;
		csr_writeback_wdata_i = 0;
		csr_writeback_exception_i = 0;
		csr_writeback_exception_pc_i = 0;
		csr_writeback_exception_addr_i = 0;
		cpu_id_i = 0;
		reset_vector_i = 0;
		interrupt_inhibit_i = 0;

		#1;
		rst_i = 1;
		#1;
		clk_i = 1;
		#1;
		rst_i = 0;
		clk_i = 0;

		for (i = 0; i < 10000; i+= 1) begin
			intr_i = $random(seed);
			opcode_valid_i = $random(seed);
			opcode_opcode_i = $random(seed);
			opcode_pc_i = $random(seed);
			opcode_invalid_i = $random(seed);
			opcode_rd_idx_i = $random(seed);
			opcode_ra_idx_i = $random(seed);
			opcode_rb_idx_i = $random(seed);
			opcode_ra_operand_i = $random(seed);
			opcode_rb_operand_i = $random(seed);
			csr_writeback_write_i = $random(seed);
			csr_writeback_waddr_i = $random(seed);
			csr_writeback_wdata_i = $random(seed);
			csr_writeback_exception_i = $random(seed);
			csr_writeback_exception_pc_i = $random(seed);
			csr_writeback_exception_addr_i = $random(seed);
			cpu_id_i = $random(seed);
			reset_vector_i = $random(seed);
			interrupt_inhibit_i = $random(seed);
			clk_i = ~clk_i;
			#1;
		end
	end

endmodule