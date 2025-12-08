`include "../core/riscv/riscv_core.v"
`include "fabric.v"

module sys(
	input clk,
	input arst,
	input [15:0] inspect_addr,
	output [31:0] inspect_q,
	output [31:0] vram_addr,
	output [31:0] vram_data,
	output [3:0] vram_bs,
	output vram_en
);
	wire          clk_i;
	(*keep*)wire          rst_i;
	(*keep*)wire [ 31:0]  mem_d_data_rd_i; // port
	(*keep*)wire          mem_d_accept_i;// constant 1
	(*keep*)wire          mem_d_ack_i; // enable piped
	(*keep*)wire          mem_d_error_i; // constant 0
	(*keep*)wire [ 10:0]  mem_d_resp_tag_i; // need to be piped
	(*keep*)wire          mem_i_accept_i; // constant 1
	(*keep*)wire          mem_i_valid_i; // constant 1
	(*keep*)wire          mem_i_error_i; // constant 0
	(*keep*)wire [ 31:0]  mem_i_inst_i; // port
	(*keep*)wire          intr_i; // constant 0
	(*keep*)wire [ 31:0]  reset_vector_i; // constant 0
	(*keep*)wire [ 31:0]  cpu_id_i; // constant 0
	(*keep*)wire [ 31:0]  mem_d_addr_o; // port
	(*keep*)wire [ 31:0]  mem_d_data_wr_o; // port
	(*keep*)wire          mem_d_rd_o; // enable
	(*keep*)wire [  3:0]  mem_d_wr_o; // important
	(*keep*)wire          mem_d_cacheable_o; // dont care
	(*keep*)wire [ 10:0]  mem_d_req_tag_o; // need to be piped
	(*keep*)wire          mem_d_invalidate_o; // dont care
	(*keep*)wire          mem_d_writeback_o;
	(*keep*)wire          mem_d_flush_o; // dont care
	(*keep*)wire          mem_i_rd_o;
	(*keep*)wire          mem_i_flush_o; // dont care
	(*keep*)wire          mem_i_invalidate_o; // dont care
	(*keep*)wire [ 31:0]  mem_i_pc_o;

	riscv_core core(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.mem_d_data_rd_i(mem_d_data_rd_i),
		.mem_d_accept_i(mem_d_accept_i),
		.mem_d_ack_i(mem_d_ack_i),
		.mem_d_error_i(mem_d_error_i),
		.mem_d_resp_tag_i(mem_d_resp_tag_i),
		.mem_i_accept_i(mem_i_accept_i),
		.mem_i_valid_i(mem_i_valid_i),
		.mem_i_error_i(mem_i_error_i),
		.mem_i_inst_i(mem_i_inst_i),
		.intr_i(intr_i),
		.reset_vector_i(reset_vector_i),
		.cpu_id_i(cpu_id_i),
		.mem_d_addr_o(mem_d_addr_o),
		.mem_d_data_wr_o(mem_d_data_wr_o),
		.mem_d_rd_o(mem_d_rd_o),
		.mem_d_wr_o(mem_d_wr_o),
		.mem_d_cacheable_o(mem_d_cacheable_o),
		.mem_d_req_tag_o(mem_d_req_tag_o),
		.mem_d_invalidate_o(mem_d_invalidate_o),
		.mem_d_writeback_o(mem_d_writeback_o),
		.mem_d_flush_o(mem_d_flush_o),
		.mem_i_rd_o(mem_i_rd_o),
		.mem_i_flush_o(mem_i_flush_o),
		.mem_i_invalidate_o(mem_i_invalidate_o),
		.mem_i_pc_o(mem_i_pc_o)
	);

	(*keep*)wire instr_en;
	(*keep*)wire instr_flush;
	(*keep*)wire instr_invalidate;
	(*keep*)wire [31:0] instr_addr;
	(*keep*)wire [31:0] instr_q;
	(*keep*)wire instr_accept;
	(*keep*)wire instr_valid;
	(*keep*)wire instr_error;
	(*keep*)wire data_en;
	(*keep*)wire data_flush;
	(*keep*)wire data_invalidate;
	(*keep*)wire [31:0] data_addr;
	(*keep*)wire [31:0] data_q;
	(*keep*)wire data_accept;
	(*keep*)wire data_valid;
	(*keep*)wire data_error;
	(*keep*)wire data_ack;
	(*keep*)wire [10:0] data_tag_d;
	(*keep*)wire [10:0] data_tag_q;
	(*keep*)wire [31:0] wr_data;
	(*keep*)wire [3:0] wr_bs;

	fabric fab (
		.clk(clk),
		.arst(arst),
		.instr_en(instr_en),
		.instr_flush(instr_flush),
		.instr_invalidate(instr_invalidate),
		.instr_addr(instr_addr),
		.instr_q(instr_q),
		.instr_accept(instr_accept),
		.instr_valid(instr_valid),
		.instr_error(instr_error),
		.data_en(data_en),
		.data_addr(data_addr),
		.data_q(data_q),
		.data_accept(data_accept),
		.data_valid(data_valid),
		.data_error(data_error),
		.data_ack(data_ack),
		.data_tag_d(data_tag_d),
		.data_tag_q(data_tag_q),
		.inspect_addr(inspect_addr),
		.inspect_q(inspect_q),
		.wr_data(wr_data),
		.wr_bs(wr_bs),
		.vram_addr(vram_addr),
		.vram_data(vram_data),
		.vram_bs(vram_bs),
		.vram_en(vram_en)
	);
	assign clk_i = clk;
	assign rst_i = arst;

	assign data_addr = mem_d_addr_o;
	assign wr_data = mem_d_data_wr_o;
	assign data_en = mem_d_rd_o;
	assign wr_bs = mem_d_wr_o;
	assign mem_d_data_rd_i = data_q;
	assign mem_d_accept_i = data_accept;
	assign mem_d_ack_i = data_ack;
	assign mem_d_error_i = data_error;
	assign mem_d_resp_tag_i = data_tag_q;
	assign data_tag_d = mem_d_req_tag_o;

	assign intr_i = 1'b0;
	assign reset_vector_i = 1'b0;
	assign cpu_id_i = 32'h12345678;
	
	assign instr_en = mem_i_rd_o;
	assign instr_flush = mem_i_flush_o;
	assign instr_invalidate = mem_i_invalidate_o;
	assign instr_addr = mem_i_pc_o;
	assign mem_i_accept_i = instr_accept;
	assign mem_i_valid_i = instr_valid;
	assign mem_i_error_i = instr_error;
	assign mem_i_inst_i = instr_q;
endmodule