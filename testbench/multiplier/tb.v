`include "../../core/riscv/riscv_defs.v"
`include "../../core/riscv/riscv_alu.v"

module tb;
	reg clk_i;
	reg rst_i;
	reg opcode_valid_i;
	reg [31:0]opcode_opcode_i;
	reg [31:0]opcode_pc_i;
	reg opcode_invalid_i;
	reg [4:0]opcode_rd_idx_i;
	reg [4:0]opcode_ra_idx_i;
	reg [4:0]opcode_rb_idx_i;
	reg [31:0]opcode_ra_operand_i;
	reg [31:0]opcode_rb_operand_i;
	reg hold_i;

	wire [31:0] writeback_value_o;

	riscv_multiplier dut (
		.clk_i(clk_i),
		.rst_i(rst_i),
		.opcode_valid_i(opcode_valid_i),
		.opcode_opcode_i(opcode_opcode_i),
		.opcode_pc_i(opcode_pc_i),
		.opcode_invalid_i(opcode_invalid_i),
		.opcode_rd_idx_i(opcode_rd_idx_i),
		.opcode_ra_idx_i(opcode_ra_idx_i),
		.opcode_rb_idx_i(opcode_rb_idx_i),
		.opcode_ra_operand_i(opcode_ra_operand_i),
		.opcode_rb_operand_i(opcode_rb_operand_i),
		.hold_i(hold_i),
		.writeback_value_o(writeback_value_o),
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