
module fabric
	(
	input clk,
	input arst,

	input instr_en,
	input instr_flush,
	input instr_invalidate,
	input [31:0] instr_addr,
	output [31:0] instr_q,
	output instr_accept,
	output reg instr_valid,
	output reg instr_error,

	input data_en,
	input [31:0] data_addr,
	input [31:0] wr_data,
	input [3:0] wr_bs,
	input [10:0] data_tag_d,
	output [31:0] data_q,
	output data_accept,
	output reg data_valid,
	output reg data_error,
	output reg data_ack,
	output reg [10:0] data_tag_q,

	input [15:0] inspect_addr,
	output [31:0] inspect_q,

	output [31:0] vram_addr,
	output [31:0] vram_data,
	output [3:0] vram_bs,
	output vram_en
);
	localparam ABITS = 16;
	localparam BEGIN_VRAM = 32'h00040000;
	localparam END_VRAM = 32'h00080000;

	assign instr_accept = 1'b1;
	(*keep*) wire instr_valid_internal = instr_addr < (4 << ABITS);
	always @(posedge clk, posedge arst) begin 
		if (arst) begin
			instr_valid <= 0;
			instr_error <= 0;
		end
		else if (instr_en) begin
			instr_valid <= instr_valid_internal;
			instr_error <= !instr_valid_internal;
		end
	end

	(*keep*)wire data_dst = data_addr < (4 << ABITS);
	(*keep*)wire vram_dst = data_addr >= BEGIN_VRAM && data_addr < END_VRAM;
	(*keep*)wire rd_wr_en = |wr_bs || data_en;
	assign data_accept = 1'b1;
	(*keep*)wire data_valid_internal = data_dst || vram_dst;
	always @ (posedge clk, posedge arst) begin
		if (arst) begin
			data_valid <= 0;
			data_error <= 0;
			data_ack <= 0;
			data_tag_q <= 0;
		end
		else if (rd_wr_en) begin
			data_valid <= data_valid_internal;
			data_error <= !data_valid_internal;
			data_ack <= (|wr_bs || data_en) && data_valid_internal;
			data_tag_q <= data_tag_d;
		end
	end

	assign vram_addr = data_addr;
	assign vram_data = wr_data;
	assign vram_bs = wr_bs;
	assign vram_en = vram_dst;

	v2f_programmable_ram #(
			.SIZE(1 << ABITS),
			.PROGRAM_FILE("program.mem"),
			.ABITS(ABITS),
			.RD_PORTS(3),
			.RD_CLK_ENABLE(3'b110),
			.RD_CLK_POLARITY(3'b110)
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