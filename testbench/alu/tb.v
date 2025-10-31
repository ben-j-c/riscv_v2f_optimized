`include "../../core/riscv/riscv_defs.v"
`include "../../core/riscv/riscv_alu.v"

module tb;
	reg signed [31:0] alu_a_i;
	reg signed [31:0] alu_b_i;
	reg [31:0] alu_op_i;
	wire signed [31:0] alu_p_o;

	riscv_alu dut (
		.alu_a_i(alu_a_i),
		.alu_b_i(alu_b_i),
		.alu_op_i(alu_op_i[3:0]),
		.alu_p_o(alu_p_o)
	);

	integer i;
	integer op_select;
	integer seed;
	initial begin
		seed = 123;
		$dumpfile(".alu_tb.vcd");
		$dumpvars(0, tb);

		for (i = 0; i < 50; i = i + 1) begin
			alu_a_i = $random(seed);
			alu_b_i = $random(seed);

			for (op_select = 0; op_select < 16; op_select = op_select + 1) begin
				alu_op_i = op_select;
				#1;
			end
		end
		$finish;
	end
endmodule