`include "sys.v"

module sys_tb;
	reg clk;
	reg arst;
	reg [15:0] inspect_addr;
	wire [31:0] vram_addr;
	wire [31:0] vram_data;
	wire [3:0] vram_bs;
	wire vram_en;
	wire [31:0] inspect_q;

	sys dut (
		.clk(clk),
		.arst(arst),
		.inspect_addr(inspect_addr),
		.vram_addr(vram_addr),
		.vram_data(vram_data),
		.vram_bs(vram_bs),
		.vram_en(vram_en),
		.inspect_q(inspect_q)
	);

	integer seed;
	integer i, j, k;
	initial begin
		seed = 123;
		$dumpfile("sys_tb.vcd");
		$dumpvars(0, sys_tb);
		clk = 0;
		arst = 1;
		inspect_addr = 0;
		#1;
		arst = 0;
		#1;

		for (i = 0 ; i < 300; i += 1) begin
			clk = ~clk;
			#1;
		end
	end
endmodule