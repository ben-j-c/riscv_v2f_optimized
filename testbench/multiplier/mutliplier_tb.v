`include "../../core/riscv/riscv_defs.v"
`include "../../core/riscv/riscv_multiplier.v"

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
		.writeback_value_o(writeback_value_o)
	);

	initial begin
		$dumpfile("multiplier_tb.vcd");
		$dumpvars(0, tb);

		clk_i = 0;
		rst_i = 0;
		opcode_valid_i = 0;
		opcode_opcode_i = 0;
		opcode_pc_i = 0;
		opcode_invalid_i = 0;
		opcode_rd_idx_i = 0;
		opcode_ra_idx_i = 0;
		opcode_rb_idx_i = 0;
		opcode_ra_operand_i = 0;
		opcode_rb_operand_i = 0;
		hold_i = 0;
		#1;

		// TEST PAIR 0
		clk_i = 0;
		opcode_ra_operand_i = 3;
		opcode_rb_operand_i = 4;
		opcode_opcode_i= `INST_MUL;
		#1;
		clk_i = 1;
		#1;

		clk_i = 0;
		opcode_opcode_i= `INST_MULH;
		#1;
		clk_i = 1;
		#1;

		clk_i = 0;
		opcode_opcode_i= `INST_MULHSU;
		#1;
		clk_i = 1;
		#1;

		clk_i = 0;
		opcode_opcode_i= `INST_MULHU;
		#1;
		clk_i = 1;
		#1;

		// TEST PAIR 1
		clk_i = 0;
		opcode_ra_operand_i = -50;
		opcode_rb_operand_i = 7;
		opcode_opcode_i= `INST_MUL;
		#1;
		clk_i = 1;
		#1;

		clk_i = 0;
		opcode_opcode_i= `INST_MULH;
		#1;
		clk_i = 1;
		#1;

		clk_i = 0;
		opcode_opcode_i= `INST_MULHSU;
		#1;
		clk_i = 1;
		#1;

		clk_i = 0;
		opcode_opcode_i= `INST_MULHU;
		#1;
		clk_i = 1;
		#1;

		// TEST PAIR 2
		clk_i = 0;
		opcode_ra_operand_i = 800_000_000;
		opcode_rb_operand_i = -50_000;
		opcode_opcode_i= `INST_MUL;
		#1;
		clk_i = 1;
		#1;

		clk_i = 0;
		opcode_opcode_i= `INST_MULH;
		#1;
		clk_i = 1;
		#1;

		clk_i = 0;
		opcode_opcode_i= `INST_MULHSU;
		#1;
		clk_i = 1;
		#1;

		clk_i = 0;
		opcode_opcode_i= `INST_MULHU;
		#1;
		clk_i = 1;
		#1;

		// Same test with hold
		// Same test with hold
		// TEST PAIR 1
		clk_i = 0;
		opcode_ra_operand_i = -50;
		opcode_rb_operand_i = 7;
		opcode_opcode_i= `INST_MUL;
		hold_i = 1;
		#1;
		clk_i = 1;
		#1;

		clk_i = 0;
		opcode_opcode_i= `INST_MULH;
		#1;
		clk_i = 1;
		#1;

		clk_i = 0;
		opcode_opcode_i= `INST_MULHSU;
		#1;
		clk_i = 1;
		#1;

		clk_i = 0;
		opcode_opcode_i= `INST_MULHU;
		#1;
		clk_i = 1;
		#1;

		// TEST PAIR 2
		clk_i = 0;
		opcode_ra_operand_i = 800_000_000;
		opcode_rb_operand_i = -50_000;
		opcode_opcode_i= `INST_MUL;
		#1;
		clk_i = 1;
		#1;

		clk_i = 0;
		opcode_opcode_i= `INST_MULH;
		#1;
		clk_i = 1;
		#1;

		clk_i = 0;
		opcode_opcode_i= `INST_MULHSU;
		#1;
		clk_i = 1;
		#1;

		clk_i = 0;
		opcode_opcode_i= `INST_MULHU;
		#1;
		clk_i = 1;
		#1;

		// Same test with reset
		// Same test with reset
		// TEST PAIR 1
		clk_i = 0;
		opcode_ra_operand_i = -50;
		opcode_rb_operand_i = 7;
		opcode_opcode_i= `INST_MUL;
		hold_i = 0;
		#1;
		clk_i = 1;
		#1;

		clk_i = 0;
		opcode_opcode_i= `INST_MULH;
		#1;
		clk_i = 1;
		#1;

		clk_i = 0;
		opcode_opcode_i= `INST_MULHSU;
		#1;
		clk_i = 1;
		#1;

		clk_i = 0;
		opcode_opcode_i= `INST_MULHU;
		#1;
		clk_i = 1;
		#1;

		// TEST PAIR 2
		clk_i = 0;
		opcode_ra_operand_i = 800_000_000;
		opcode_rb_operand_i = -50_000;
		opcode_opcode_i= `INST_MUL;
		rst_i = 1;
		#1;
		clk_i = 1;
		#1;

		clk_i = 0;
		opcode_opcode_i= `INST_MULH;
		#1;
		clk_i = 1;
		#1;

		clk_i = 0;
		opcode_opcode_i= `INST_MULHSU;
		#1;
		clk_i = 1;
		#1;

		clk_i = 0;
		opcode_opcode_i= `INST_MULHU;
		#1;
		clk_i = 1;
		#1;

		$finish;
	end
endmodule