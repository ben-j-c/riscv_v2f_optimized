//`include "char_font_decoder_8x8.v"

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

	// These will all be connected together in the lua
	(*keep, v2f_signal="signal_0"*) wire[7:0] char_00 = data[00];
	(*keep, v2f_signal="signal_1"*) wire[7:0] char_01 = data[01];
	(*keep, v2f_signal="signal_2"*) wire[7:0] char_02 = data[02];
	(*keep, v2f_signal="signal_3"*) wire[7:0] char_03 = data[03];
	(*keep, v2f_signal="signal_4"*) wire[7:0] char_04 = data[04];
	(*keep, v2f_signal="signal_5"*) wire[7:0] char_05 = data[05];
	(*keep, v2f_signal="signal_6"*) wire[7:0] char_06 = data[06];
	(*keep, v2f_signal="signal_7"*) wire[7:0] char_07 = data[07];
	(*keep, v2f_signal="signal_8"*) wire[7:0] char_08 = data[08];
	(*keep, v2f_signal="signal_9"*) wire[7:0] char_09 = data[09];
	(*keep, v2f_signal="signal_a"*) wire[7:0] char_10 = data[10];
	(*keep, v2f_signal="signal_b"*) wire[7:0] char_11 = data[11];
	(*keep, v2f_signal="signal_c"*) wire[7:0] char_12 = data[12];
	(*keep, v2f_signal="signal_d"*) wire[7:0] char_13 = data[13];
	(*keep, v2f_signal="signal_e"*) wire[7:0] char_14 = data[14];
	(*keep, v2f_signal="signal_f"*) wire[7:0] char_15 = data[15];

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