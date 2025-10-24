`include "../../core/riscv/riscv_defs.v"
`include "../../core/riscv/riscv_lsu_simplified.v"

module tb;
	reg               clk_i;
	reg               rst_i;
	reg  [31:0]       data_in_i;
	reg               push_i;
	reg               pop_i;
	wire [31:0]       data_out_o;
	wire              accept_o;
	wire              valid_o;

	riscv_lsu_fifo #(
		.WIDTH(32),
		.DEPTH(2),
		.ADDR_W(1)
	) dut (
		.clk_i(clk_i),
		.rst_i(rst_i),
		.data_in_i(data_in_i),
		.push_i(push_i),
		.pop_i(pop_i),
		.data_out_o(data_out_o),
		.accept_o(accept_o),
		.valid_o(valid_o)
	);
	integer seed;
	integer i;
	initial begin
		seed = 1;
		$dumpfile(".lsu_fifo_tb.vcd");
		$dumpvars(0, tb);
		clk_i = 0;
		rst_i = 1;
		data_in_i = 0;
		push_i = 0;
		pop_i = 0;

		#1;
		rst_i = 0;

		for (i = 0; i < 1000; i+= 1) begin
			data_in_i = i;
			push_i = $random(seed);
			pop_i = $random(seed);
			clk_i = 0;
			#1;
			clk_i = 1;
			#1;
		end
	end

endmodule