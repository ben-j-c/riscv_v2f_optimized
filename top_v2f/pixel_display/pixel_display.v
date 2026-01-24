
module pixel_display(
		input [31:0] data_addr,
		input [31:0] wr_data,
		input [3:0] wr_bs,
		output [15:0] row_0,
	);

	v2f_programmable_ram #(
			.SIZE(1 << ABITS),
			.PROGRAM_FILE("program.mem"),
			.ABITS(ABITS),
			.RD_PORTS(1),
			.RD_CLK_ENABLE(3'b0),
			.RD_CLK_POLARITY(3'b0)
		) ram (
		.RD_CLK({clk, clk, 1'b0}),
		.RD_EN({instr_en, data_en, 1'b0}),
		.RD_ARST({arst, arst, 1'b0}),
		.RD_SRST(3'b0),
		.RD_ADDR({instr_addr[17:2], data_addr[17:2], inspect_addr[15:0]}),
		.RD_DATA({instr_q, data_q, inspect_q}),
		.WR_CLK(clk),
		.WR_EN(|wr_bs && data_dst),
		.WR_ADDR(data_addr[17:2]),
		.WR_DATA(wr_data),
		.BYTE_SELECT(wr_bs),
		.ARST(arst)
	);

endmodule