
module char_display(
	input clk,
	input arst,
	input [31:0] data_addr,
	input [31:0] wr_data,
	input [3:0] wr_bs
);
	parameter ADDR_SET = 0;
	reg [7:0] data[15:0];
	reg [3:0] idx;

	wire en_wr = data_addr == ADDR_SET && |wr_bs;
	wire en_clear = data_addr == (ADDR_SET + 4) && |wr_bs;

	(*keep*) wire[7:0] char_00 = data[00];
	(*keep*) wire[7:0] char_01 = data[01];
	(*keep*) wire[7:0] char_02 = data[02];
	(*keep*) wire[7:0] char_03 = data[03];
	(*keep*) wire[7:0] char_04 = data[04];
	(*keep*) wire[7:0] char_05 = data[05];
	(*keep*) wire[7:0] char_06 = data[06];
	(*keep*) wire[7:0] char_07 = data[07];
	(*keep*) wire[7:0] char_08 = data[08];
	(*keep*) wire[7:0] char_09 = data[09];
	(*keep*) wire[7:0] char_10 = data[10];
	(*keep*) wire[7:0] char_11 = data[11];
	(*keep*) wire[7:0] char_12 = data[12];
	(*keep*) wire[7:0] char_13 = data[13];
	(*keep*) wire[7:0] char_14 = data[14];
	(*keep*) wire[7:0] char_15 = data[15];

	integer i;
	always @(posedge clk or posedge arst) begin
		if (arst) begin
			for (i = 0; i < 16; i = i + 1) begin
				data[i] <= 0;
			end
			idx <= 0;
		end else begin
			if (en_clear) begin
				for (i = 0; i < 16; i = i + 1) begin
					data[i] <= 0;
				end
				idx <= 0;
			end else if (en_wr) begin
				data[idx] <= wr_data;
				idx <= idx + 1;
			end
		end
	end
endmodule