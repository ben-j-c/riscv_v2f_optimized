`include "../../core/riscv/riscv_defs.v"
`include "../../core/riscv/riscv_decoder.v"

module tb;
	reg valid_i;
	reg fetch_fault_i;
	reg enable_muldiv_i;
	reg [31:0] opcode_i;
	wire invalid_o;
	wire exec_o;
	wire lsu_o;
	wire branch_o;
	wire mul_o;
	wire div_o;
	wire csr_o;
	wire rd_valid_o;

	riscv_decoder dut (
		.valid_i(valid_i),
		.fetch_fault_i(fetch_fault_i),
		.enable_muldiv_i(enable_muldiv_i),
		.opcode_i(opcode_i),
		.invalid_o(invalid_o),
		.exec_o(exec_o),
		.lsu_o(lsu_o),
		.branch_o(branch_o),
		.mul_o(mul_o),
		.div_o(div_o),
		.csr_o(csr_o),
		.rd_valid_o(rd_valid_o)
	);

	integer seed;
	integer i;
	initial begin
		$dumpfile("tb.vcd");
		$dumpvars(1, tb);

		seed = 123;
		for (i = 0; i < 10000; i = i + 1) begin
			valid_i = $random(seed);
			fetch_fault_i = $random(seed);
			enable_muldiv_i = $random(seed);
			opcode_i = $random(seed);
			#1;
		end
		$finish;
	end
endmodule