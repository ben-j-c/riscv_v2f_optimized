`include "../../core/riscv/riscv_defs.v"
`include "../../core/riscv/riscv_csr_regfile.v"

module tb;
	reg clk_i;
	reg rst_i;
	reg ext_intr_i;
	reg timer_intr_i;
	reg [31:0] cpu_id_i;
	reg [31:0] misa_i;
	reg [5:0] exception_i;
	reg [31:0] exception_pc_i;
	reg [31:0] exception_addr_i;
	reg csr_ren_i;
	reg [11:0] csr_raddr_i;
	reg [11:0] csr_waddr_i;
	reg [31:0] csr_wdata_i;
	wire [31:0] csr_rdata_o;
	wire csr_branch_o;
	wire [31:0] csr_target_o;
	wire [1:0] priv_o;
	wire [31:0] status_o;
	wire [31:0] satp_o;
	wire [31:0] interrupt_o;

	riscv_csr_regfile dut (
		.clk_i(clk_i),
		.rst_i(rst_i),
		.ext_intr_i(ext_intr_i),
		.timer_intr_i(timer_intr_i),
		.cpu_id_i(cpu_id_i),
		.misa_i(misa_i),
		.exception_i(exception_i),
		.exception_pc_i(exception_pc_i),
		.exception_addr_i(exception_addr_i),
		.csr_ren_i(csr_ren_i),
		.csr_raddr_i(csr_raddr_i),
		.csr_rdata_o(csr_rdata_o),
		.csr_waddr_i(csr_waddr_i),
		.csr_wdata_i(csr_wdata_i),
		.csr_branch_o(csr_branch_o),
		.csr_target_o(csr_target_o),
		.priv_o(priv_o),
		.status_o(status_o),
		.satp_o(satp_o),
		.interrupt_o(interrupt_o)
	);

	initial begin
		$dumpfile(".csr_reg_file_tb.vcd");
		$dumpvars(1, tb);
		clk_i = 0;
		rst_i = 0;
		ext_intr_i = 0;
		timer_intr_i = 0;
		cpu_id_i = 0;
		misa_i = 0;
		exception_i = 0;
		exception_pc_i = 0;
		exception_addr_i = 0;
		csr_ren_i = 0;
		csr_raddr_i = 0;
		csr_waddr_i = 0;
		csr_wdata_i = 0;
		#1;
		rst_i = 1;
		#1;
		rst_i = 0;
		begin
			clk_i = 0;
			#1;
			clk_i = 1;
			#1;
		end
	end
endmodule