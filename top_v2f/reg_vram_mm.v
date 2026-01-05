module reg_vram_mm(
	clk,
	arst,
	en,
	addr,
	data
);
	parameter ADDR_SET = 0;

	input clk;
	input en;
	input arst;
	input [31:0] addr;
	input [31:0] data;

	(*keep*) reg [31:0] q;

	always @ (posedge clk, posedge arst) begin
		if (arst) begin
			q <= 0;
		end
		else if (en && addr == ADDR_SET) begin
			q <= data;
		end
	end

endmodule