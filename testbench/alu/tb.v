`include "../../core/riscv/riscv_defs.v"
`include "../../core/riscv/riscv_alu.v"

module tb;
	reg signed [31:0] data_a;
	reg signed [31:0] data_b;
	reg [31:0] select;
	wire signed [31:0] result_y;

	riscv_alu dut (
		.alu_a_i(data_a),
		.alu_b_i(data_b),
		.alu_op_i(select[3:0]),
		.alu_p_o(result_y)
	);

	integer i;
	integer op_select;
	integer seed;
	initial begin
		seed = 123;
		$dumpfile("tb.vcd");
		$dumpvars(1, tb);

		for (i = 0; i < 50; i = i + 1) begin
			data_a = $random(seed);
			data_b = $random(seed);

			for (op_select = 0; op_select < 16; op_select = op_select + 1) begin
				select = op_select;
				#1;
			end
		end
		$finish;
	end
endmodule