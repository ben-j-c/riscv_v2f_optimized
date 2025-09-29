`include "../../core/riscv/riscv_defs.v"
`include "../../core/riscv/riscv_regfile.v"

module tb;
	reg clk_i;
	reg rst_i;
	reg [4:0] rd0_i;
	reg [31:0] rd0_value_i;
	reg [4:0] ra0_i;
	reg [4:0] rb0_i;
	wire [31:0] ra0_value_o;
	wire [31:0] rb0_value_o;

	riscv_regfile dut (
		.clk_i(clk_i),
		.rst_i(rst_i),
		.rd0_i(rd0_i),
		.rd0_value_i(rd0_value_i),
		.ra0_i(ra0_i),
		.rb0_i(rb0_i),
		.ra0_value_o(ra0_value_o),
		.rb0_value_o(rb0_value_o)
	);

	initial begin
		
		$finish;
	end
endmodule