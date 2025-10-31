`include "../../core/riscv/riscv_defs.v"
`include "../../core/riscv/riscv_mmu_simplified.v"

module tb;
	reg           clk_i;
	reg           rst_i;
	reg  [  1:0]  priv_d_i;
	reg           sum_i;
	reg           mxr_i;
	reg           flush_i;
	reg  [ 31:0]  satp_i;
	reg           fetch_in_rd_i;
	reg           fetch_in_flush_i;
	reg           fetch_in_invalidate_i;
	reg  [ 31:0]  fetch_in_pc_i;
	reg  [  1:0]  fetch_in_priv_i;
	reg           fetch_out_accept_i;
	reg           fetch_out_valid_i;
	reg           fetch_out_error_i;
	reg  [ 31:0]  fetch_out_inst_i;
	reg  [ 31:0]  lsu_in_addr_i;
	reg  [ 31:0]  lsu_in_data_wr_i;
	reg           lsu_in_rd_i;
	reg  [  3:0]  lsu_in_wr_i;
	reg           lsu_in_cacheable_i;
	reg  [ 10:0]  lsu_in_req_tag_i;
	reg           lsu_in_invalidate_i;
	reg           lsu_in_writeback_i;
	reg           lsu_in_flush_i;
	reg  [ 31:0]  lsu_out_data_rd_i;
	reg           lsu_out_accept_i;
	reg           lsu_out_ack_i;
	reg           lsu_out_error_i;
	reg  [ 10:0]  lsu_out_resp_tag_i;
	wire          fetch_in_accept_o;
	wire          fetch_in_valid_o;
	wire          fetch_in_error_o;
	wire [ 31:0]  fetch_in_inst_o;
	wire          fetch_out_rd_o;
	wire          fetch_out_flush_o;
	wire          fetch_out_invalidate_o;
	wire [ 31:0]  fetch_out_pc_o;
	wire          fetch_in_fault_o;
	wire [ 31:0]  lsu_in_data_rd_o;
	wire          lsu_in_accept_o;
	wire          lsu_in_ack_o;
	wire          lsu_in_error_o;
	wire [ 10:0]  lsu_in_resp_tag_o;
	wire [ 31:0]  lsu_out_addr_o;
	wire [ 31:0]  lsu_out_data_wr_o;
	wire          lsu_out_rd_o;
	wire [  3:0]  lsu_out_wr_o;
	wire          lsu_out_cacheable_o;
	wire [ 10:0]  lsu_out_req_tag_o;
	wire          lsu_out_invalidate_o;
	wire          lsu_out_writeback_o;
	wire          lsu_out_flush_o;
	wire          lsu_in_load_fault_o;
	wire          lsu_in_store_fault_o;


	riscv_mmu_simplified dut (
		.clk_i(clk_i),
		.rst_i(rst_i),
		.priv_d_i(priv_d_i),
		.sum_i(sum_i),
		.mxr_i(mxr_i),
		.flush_i(flush_i),
		.satp_i(satp_i),
		.fetch_in_rd_i(fetch_in_rd_i),
		.fetch_in_flush_i(fetch_in_flush_i),
		.fetch_in_invalidate_i(fetch_in_invalidate_i),
		.fetch_in_pc_i(fetch_in_pc_i),
		.fetch_in_priv_i(fetch_in_priv_i),
		.fetch_out_accept_i(fetch_out_accept_i),
		.fetch_out_valid_i(fetch_out_valid_i),
		.fetch_out_error_i(fetch_out_error_i),
		.fetch_out_inst_i(fetch_out_inst_i),
		.lsu_in_addr_i(lsu_in_addr_i),
		.lsu_in_data_wr_i(lsu_in_data_wr_i),
		.lsu_in_rd_i(lsu_in_rd_i),
		.lsu_in_wr_i(lsu_in_wr_i),
		.lsu_in_cacheable_i(lsu_in_cacheable_i),
		.lsu_in_req_tag_i(lsu_in_req_tag_i),
		.lsu_in_invalidate_i(lsu_in_invalidate_i),
		.lsu_in_writeback_i(lsu_in_writeback_i),
		.lsu_in_flush_i(lsu_in_flush_i),
		.lsu_out_data_rd_i(lsu_out_data_rd_i),
		.lsu_out_accept_i(lsu_out_accept_i),
		.lsu_out_ack_i(lsu_out_ack_i),
		.lsu_out_error_i(lsu_out_error_i),
		.lsu_out_resp_tag_i(lsu_out_resp_tag_i),
		//.fetch_in_accept_o(fetch_in_accept_o),
		//.fetch_in_valid_o(fetch_in_valid_o),
		//.fetch_in_error_o(fetch_in_error_o),
		//.fetch_in_inst_o(fetch_in_inst_o),
		//.fetch_out_rd_o(fetch_out_rd_o),
		//.fetch_out_flush_o(fetch_out_flush_o),
		//.fetch_out_invalidate_o(fetch_out_invalidate_o),
		//.fetch_out_pc_o(fetch_out_pc_o),
		//.fetch_in_fault_o(fetch_in_fault_o),
		//.lsu_in_data_rd_o(lsu_in_data_rd_o),
		//.lsu_in_accept_o(lsu_in_accept_o),
		//.lsu_in_ack_o(lsu_in_ack_o),
		//.lsu_in_error_o(lsu_in_error_o),
		//.lsu_in_resp_tag_o(lsu_in_resp_tag_o),
		.lsu_out_addr_o(lsu_out_addr_o)
		//.lsu_out_data_wr_o(lsu_out_data_wr_o),
		//.lsu_out_rd_o(lsu_out_rd_o),
		//.lsu_out_wr_o(lsu_out_wr_o),
		//.lsu_out_cacheable_o(lsu_out_cacheable_o),
		//.lsu_out_req_tag_o(lsu_out_req_tag_o),
		//.lsu_out_invalidate_o(lsu_out_invalidate_o)//,
		//.lsu_out_writeback_o(lsu_out_writeback_o),
		//.lsu_out_flush_o(lsu_out_flush_o),
		//.lsu_in_load_fault_o(lsu_in_load_fault_o),
		//.lsu_in_store_fault_o(lsu_in_store_fault_o)
	);
	integer seed;
	integer i;
	initial begin
		seed = 123;
		$dumpfile(".mmu_simplified_tb.vcd");
		$dumpvars(0, tb);
		clk_i = 0;
		rst_i = 1;
		priv_d_i = 0;
		sum_i = 0;
		mxr_i = 0;
		flush_i = 0;
		satp_i = 0;
		fetch_in_rd_i = 0;
		fetch_in_flush_i = 0;
		fetch_in_invalidate_i = 0;
		fetch_in_pc_i = 0;
		fetch_in_priv_i = 0;
		fetch_out_accept_i = 0;
		fetch_out_valid_i = 0;
		fetch_out_error_i = 0;
		fetch_out_inst_i = 0;
		lsu_in_addr_i = 0;
		lsu_in_data_wr_i = 0;
		lsu_in_rd_i = 0;
		lsu_in_wr_i = 0;
		lsu_in_cacheable_i = 0;
		lsu_in_req_tag_i = 0;
		lsu_in_invalidate_i = 0;
		lsu_in_writeback_i = 0;
		lsu_in_flush_i = 0;
		lsu_out_data_rd_i = 0;
		lsu_out_accept_i = 0;
		lsu_out_ack_i = 0;
		lsu_out_error_i = 0;
		lsu_out_resp_tag_i = 0;

		#1;
		rst_i = 0;

		for (i = 0; i < 10000; i+= 1) begin
			priv_d_i = $random(seed);
			sum_i = $random(seed);
			mxr_i = $random(seed);
			flush_i = $random(seed);
			satp_i = $random(seed);
			fetch_in_rd_i = $random(seed);
			fetch_in_flush_i = $random(seed);
			fetch_in_invalidate_i = $random(seed);
			fetch_in_pc_i = $random(seed);
			fetch_in_priv_i = $random(seed);
			fetch_out_accept_i = $random(seed);
			fetch_out_valid_i = $random(seed);
			fetch_out_error_i = $random(seed);
			fetch_out_inst_i = $random(seed);
			lsu_in_addr_i = $random(seed);
			lsu_in_data_wr_i = $random(seed);
			lsu_in_rd_i = $random(seed);
			lsu_in_wr_i = $random(seed);
			lsu_in_cacheable_i = $random(seed);
			lsu_in_req_tag_i = $random(seed);
			lsu_in_invalidate_i = $random(seed);
			lsu_in_writeback_i = $random(seed);
			lsu_in_flush_i = $random(seed);
			lsu_out_data_rd_i = $random(seed);
			lsu_out_accept_i = $random(seed);
			lsu_out_ack_i = $random(seed);
			lsu_out_error_i = $random(seed);
			lsu_out_resp_tag_i = $random(seed);
			//priv_d_i = 0;
			//sum_i = 0;
			//mxr_i = 0;
			//flush_i = 0;
			//satp_i = 0;
			//fetch_in_rd_i = 0;
			//fetch_in_flush_i = 0;
			//fetch_in_invalidate_i = 0;
			//fetch_in_pc_i = 0;
			//fetch_in_priv_i = 0;
			//fetch_out_accept_i = 0;
			//fetch_out_valid_i = 0;
			//fetch_out_error_i = 0;
			//fetch_out_inst_i = 0;
			//lsu_in_addr_i = 0;
			//lsu_in_data_wr_i = 0;
			//lsu_in_rd_i = 0;
			//lsu_in_wr_i = 0;
			//lsu_in_cacheable_i = 0;
			//lsu_in_req_tag_i = 0;
			//lsu_in_invalidate_i = 0;
			//lsu_in_writeback_i = 0;
			//lsu_in_flush_i = 0;
			//lsu_out_data_rd_i = 0;
			//lsu_out_accept_i = 0;
			//lsu_out_ack_i = 0;
			//lsu_out_error_i = 0;
			//lsu_out_resp_tag_i = i;
			clk_i = 0;
			#1;
			clk_i = 1;
			#1;
		end
	end

endmodule