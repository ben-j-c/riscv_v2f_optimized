`include "char_font_decoder_8x8.v"

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

	wire[7:0] char_00 = data[00];
	wire[7:0] char_01 = data[01];
	wire[7:0] char_02 = data[02];
	wire[7:0] char_03 = data[03];
	wire[7:0] char_04 = data[04];
	wire[7:0] char_05 = data[05];
	wire[7:0] char_06 = data[06];
	wire[7:0] char_07 = data[07];
	wire[7:0] char_08 = data[08];
	wire[7:0] char_09 = data[09];
	wire[7:0] char_10 = data[10];
	wire[7:0] char_11 = data[11];
	wire[7:0] char_12 = data[12];
	wire[7:0] char_13 = data[13];
	wire[7:0] char_14 = data[14];
	wire[7:0] char_15 = data[15];

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
	char_font_decoder_8x8 d0(.char_in(char_00));
	char_font_decoder_8x8 d1(.char_in(char_01));
	char_font_decoder_8x8 d2(.char_in(char_02));
	char_font_decoder_8x8 d3(.char_in(char_03));
	char_font_decoder_8x8 d4(.char_in(char_04));
	char_font_decoder_8x8 d5(.char_in(char_05));
	char_font_decoder_8x8 d6(.char_in(char_06));
	char_font_decoder_8x8 d7(.char_in(char_07));
	char_font_decoder_8x8 d8(.char_in(char_08));
	char_font_decoder_8x8 d9(.char_in(char_09));
	char_font_decoder_8x8 d10(.char_in(char_10));
	char_font_decoder_8x8 d11(.char_in(char_11));
	char_font_decoder_8x8 d12(.char_in(char_12));
	char_font_decoder_8x8 d13(.char_in(char_13));
	char_font_decoder_8x8 d14(.char_in(char_14));
	char_font_decoder_8x8 d15(.char_in(char_15));
endmodule