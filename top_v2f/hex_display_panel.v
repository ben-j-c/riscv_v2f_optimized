module hex_display_panel(
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
	input [31:0] data_in_signal_D;
	
	output [3:0] data_out_signal_0;
	output [3:0] data_out_signal_1;
	output [3:0] data_out_signal_2;
	output [3:0] data_out_signal_3;
	output [3:0] data_out_signal_4;
	output [3:0] data_out_signal_5;
	output [3:0] data_out_signal_6;
	output [3:0] data_out_signal_7;

	assign data_out_signal_0 = data_in_signal_D[3:0];
	assign data_out_signal_1 = data_in_signal_D[7:4];
	assign data_out_signal_2 = data_in_signal_D[11:8];
	assign data_out_signal_3 = data_in_signal_D[15:12];
	assign data_out_signal_4 = data_in_signal_D[19:16];
	assign data_out_signal_5 = data_in_signal_D[23:20];
	assign data_out_signal_6 = data_in_signal_D[27:24];
	assign data_out_signal_7 = data_in_signal_D[31:28];

endmodule