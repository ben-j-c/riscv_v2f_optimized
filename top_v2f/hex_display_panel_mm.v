`include "hex_display_panel.v"

module hex_display_panel_mm(
	clk,
	arst,
	en,
	addr,
	data_in_signal_D,
	data_out_signal_0,
	data_out_signal_1,
	data_out_signal_2,
	data_out_signal_3,
	data_out_signal_4,
	data_out_signal_5,
	data_out_signal_6,
	data_out_signal_7
);
	parameter ADDR_SET = 0;

	input clk;
	input en;
	input arst;
	input [31:0] addr;
	input [31:0] data_in_signal_D;
	
	output [3:0] data_out_signal_0;
	output [3:0] data_out_signal_1;
	output [3:0] data_out_signal_2;
	output [3:0] data_out_signal_3;
	output [3:0] data_out_signal_4;
	output [3:0] data_out_signal_5;
	output [3:0] data_out_signal_6;
	output [3:0] data_out_signal_7;

	reg [31:0] data_in_internal;

	hex_display_panel u0(
		.data_in_signal_D(data_in_internal),
		.data_out_signal_0(data_out_signal_0),
		.data_out_signal_1(data_out_signal_1),
		.data_out_signal_2(data_out_signal_2),
		.data_out_signal_3(data_out_signal_3),
		.data_out_signal_4(data_out_signal_4),
		.data_out_signal_5(data_out_signal_5),
		.data_out_signal_6(data_out_signal_6),
		.data_out_signal_7(data_out_signal_7)
	);

	always @ (posedge clk, posedge arst) begin
		if (arst) begin
			data_in_internal <= 0;
		end
		else if (en && addr == ADDR_SET) begin
			data_in_internal <= data_in_signal_D;
		end
	end

endmodule