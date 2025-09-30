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

	integer seed;
	integer i;
	initial begin
		$dumpfile("tb.vcd");
		$dumpvars(1, tb);

		seed = 123;
		for (i = 0; i < 100; i = i + 1) begin
			clk_i = 0;
			rst_i = $random(seed);
			rd0_i = $random(seed);
			rd0_value_i = $random(seed);
			ra0_i = $random(seed);
			rb0_i = $random(seed);
			#1;
			clk_i = 1;
			#1;
		end
		$finish;
	end
endmodule