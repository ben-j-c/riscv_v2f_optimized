rtl = yosys_load_rtl("../../core/riscv/riscv_decoder.v", "riscv_decoder")
logd = yosys_map_rtl(rtl)

valid_i = logd:find_in_port("valid_i") or error()
fetch_fault_i = logd:find_in_port("fetch_fault_i") or error()
enable_muldiv_i = logd:find_in_port("enable_muldiv_i") or error()
opcode_i = logd:find_in_port("opcode_i") or error()

invalid_o = logd:find_out_port("invalid_o") or error()
exec_o = logd:find_out_port("exec_o") or error()
lsu_o = logd:find_out_port("lsu_o") or error()
branch_o = logd:find_out_port("branch_o") or error()
mul_o = logd:find_out_port("mul_o") or error()
div_o = logd:find_out_port("div_o") or error()
csr_o = logd:find_out_port("csr_o") or error()
rd_valid_o = logd:find_out_port("rd_valid_o") or error()

inputs = {}
inputs["tb.valid_i"] = valid_i
inputs["tb.fetch_fault_i"] = fetch_fault_i
inputs["tb.enable_muldiv_i"] = enable_muldiv_i
inputs["tb.opcode_i"] = opcode_i

outputs = {}
outputs["tb.invalid_o"] = invalid_o
outputs["tb.exec_o"] = exec_o
outputs["tb.lsu_o"] = lsu_o
outputs["tb.branch_o"] = branch_o
outputs["tb.mul_o"] = mul_o
outputs["tb.div_o"] = div_o
outputs["tb.csr_o"] = csr_o
outputs["tb.rd_valid_o"] = rd_valid_o

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
