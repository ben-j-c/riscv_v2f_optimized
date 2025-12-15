`include "sys.v"

module sys_tb;
	reg clk;
	reg arst;
	reg [31:0] inspect_addr;
	wire [31:0] vram_addr;
	wire [31:0] vram_data;
	wire [3:0] vram_bs;
	wire vram_en;
	wire [31:0] inspect_q;

	sys dut (
		.clk(clk),
		.arst(arst),
		.inspect_addr(inspect_addr[15:0]),
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
		//inspect_addr = 32'h8824;
		inspect_addr = 32'h0;
		#1;
		arst = 0;
		#1;

		for (i = 0 ; i < 30*2; i += 1) begin
			clk = ~clk;
			#1;
		end

		for (i = 0; i < 32'h0010; i += 1) begin
			inspect_addr = i;
			#1;
			$display("0x%04x %02x %02x %02x %02x", inspect_addr[15:0],
				inspect_q[31:24],
				inspect_q[23:16],
				inspect_q[15:8],
				inspect_q[7:0]);
		end
	end
endmodule