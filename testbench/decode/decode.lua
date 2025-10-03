rtl = yosys_load_rtl("../../core/riscv/riscv_decode.v", "riscv_decode", "../../core/riscv")
logd = yosys_map_rtl(rtl)


clk_i = logd:find_in_port("clk_i") or error()
rst_i = logd:find_in_port("rst_i") or error()
fetch_in_valid_i = logd:find_in_port("fetch_in_valid_i") or error()
fetch_in_instr_i = logd:find_in_port("fetch_in_instr_i") or error()
fetch_in_pc_i = logd:find_in_port("fetch_in_pc_i") or error()
fetch_in_fault_fetch_i = logd:find_in_port("fetch_in_fault_fetch_i") or error()
fetch_in_fault_page_i = logd:find_in_port("fetch_in_fault_page_i") or error()
fetch_out_accept_i = logd:find_in_port("fetch_out_accept_i") or error()
squash_decode_i = logd:find_in_port("squash_decode_i") or error()
fetch_in_accept_o = logd:find_out_port("fetch_in_accept_o") or error()
fetch_out_valid_o = logd:find_out_port("fetch_out_valid_o") or error()
fetch_out_instr_o = logd:find_out_port("fetch_out_instr_o") or error()
fetch_out_pc_o = logd:find_out_port("fetch_out_pc_o") or error()
fetch_out_fault_fetch_o = logd:find_out_port("fetch_out_fault_fetch_o") or error()
fetch_out_fault_page_o = logd:find_out_port("fetch_out_fault_page_o") or error()
fetch_out_instr_exec_o = logd:find_out_port("fetch_out_instr_exec_o") or error()
fetch_out_instr_lsu_o = logd:find_out_port("fetch_out_instr_lsu_o") or error()
fetch_out_instr_branch_o = logd:find_out_port("fetch_out_instr_branch_o") or error()
fetch_out_instr_mul_o = logd:find_out_port("fetch_out_instr_mul_o") or error()
fetch_out_instr_div_o = logd:find_out_port("fetch_out_instr_div_o") or error()
fetch_out_instr_csr_o = logd:find_out_port("fetch_out_instr_csr_o") or error()
fetch_out_instr_rd_valid_o = logd:find_out_port("fetch_out_instr_rd_valid_o") or error()
fetch_out_instr_invalid_o = logd:find_out_port("fetch_out_instr_invalid_o") or error()

inputs = {}
inputs["clk_i"] = clk_i
inputs["rst_i"] = rst_i
inputs["fetch_in_valid_i"] = fetch_in_valid_i
inputs["fetch_in_instr_i"] = fetch_in_instr_i
inputs["fetch_in_pc_i"] = fetch_in_pc_i
inputs["fetch_in_fault_fetch_i"] = fetch_in_fault_fetch_i
inputs["fetch_in_fault_page_i"] = fetch_in_fault_page_i
inputs["fetch_out_accept_i"] = fetch_out_accept_i
inputs["squash_decode_i"] = squash_decode_i

outputs = {}
outputs["fetch_in_accept_o"] = fetch_in_accept_o
outputs["fetch_out_valid_o"] = fetch_out_valid_o
outputs["fetch_out_instr_o"] = fetch_out_instr_o
outputs["fetch_out_pc_o"] = fetch_out_pc_o
outputs["fetch_out_fault_fetch_o"] = fetch_out_fault_fetch_o
outputs["fetch_out_fault_page_o"] = fetch_out_fault_page_o
outputs["fetch_out_instr_exec_o"] = fetch_out_instr_exec_o
outputs["fetch_out_instr_lsu_o"] = fetch_out_instr_lsu_o
outputs["fetch_out_instr_branch_o"] = fetch_out_instr_branch_o
outputs["fetch_out_instr_mul_o"] = fetch_out_instr_mul_o
outputs["fetch_out_instr_div_o"] = fetch_out_instr_div_o
outputs["fetch_out_instr_csr_o"] = fetch_out_instr_csr_o
outputs["fetch_out_instr_rd_valid_o"] = fetch_out_instr_rd_valid_o
outputs["fetch_out_instr_invalid_o"] = fetch_out_instr_invalid_o

if not os.execute("../makevcd") then
	error("makevcd failed")
end
sim = logd:new_simulation()
if not sim:apply_vcd("tb.vcd", inputs, outputs, 10, true) then
	sim:inspect()
	error("apply vcd failed")
end
print("decoder sim matches VCD")

logd:make_svg()
return logd
