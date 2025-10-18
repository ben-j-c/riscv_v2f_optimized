rtl = yosys_load_rtl("../../core/riscv/riscv_multiplier.v", "riscv_multiplier")
logd = yosys_map_rtl(rtl)


clk_i = logd:find_in_port("clk_i") or error()
rst_i = logd:find_in_port("rst_i") or error()
opcode_valid_i = logd:find_in_port("opcode_valid_i") or error()
opcode_opcode_i = logd:find_in_port("opcode_opcode_i") or error()
opcode_pc_i = logd:find_in_port("opcode_pc_i") or error()
opcode_invalid_i = logd:find_in_port("opcode_invalid_i") or error()
opcode_rd_idx_i = logd:find_in_port("opcode_rd_idx_i") or error()
opcode_ra_idx_i = logd:find_in_port("opcode_ra_idx_i") or error()
opcode_rb_idx_i = logd:find_in_port("opcode_rb_idx_i") or error()
opcode_ra_operand_i = logd:find_in_port("opcode_ra_operand_i") or error()
opcode_rb_operand_i = logd:find_in_port("opcode_rb_operand_i") or error()
hold_i = logd:find_in_port("hold_i") or error()

writeback_value_o = logd:find_out_port("writeback_value_o") or error()

inputs = {}
inputs["tb.clk_i"] = clk_i
inputs["tb.rst_i"] = rst_i
inputs["tb.opcode_valid_i"] = opcode_valid_i
inputs["tb.opcode_opcode_i"] = opcode_opcode_i
inputs["tb.opcode_pc_i"] = opcode_pc_i
inputs["tb.opcode_invalid_i"] = opcode_invalid_i
inputs["tb.opcode_rd_idx_i"] = opcode_rd_idx_i
inputs["tb.opcode_ra_idx_i"] = opcode_ra_idx_i
inputs["tb.opcode_rb_idx_i"] = opcode_rb_idx_i
inputs["tb.opcode_ra_operand_i"] = opcode_ra_operand_i
inputs["tb.opcode_rb_operand_i"] = opcode_rb_operand_i
inputs["tb.hold_i"] = hold_i
outputs = {}
outputs["tb.writeback_value_o"] = writeback_value_o
os.execute("../makevcd")
sim = logd:new_simulation()
if not sim:apply_vcd("tb.vcd", inputs, outputs, 5, true) then
	error()
end
print("riscv_multiplier sim matches VCD")

logd:make_svg()
return logd
