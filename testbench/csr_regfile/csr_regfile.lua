rtl = yosys_load_rtl("../../core/riscv/riscv_csr_regfile.v", "riscv_csr_regfile")
logd = yosys_map_rtl(rtl)


inputs = {}
for index, value in pairs(logd:in_ports()) do
	inputs["tb." .. index] = value
end

outputs = {}
for index, value in pairs(logd:out_ports()) do
	outputs["tb." .. index] = value
end

if not os.execute("../makevcd") then
	error("makevcd failed")
end
sim = logd:new_simulation()
--sim:inspect()
if not sim:apply_vcd(".csr_regfile_tb.vcd", inputs, outputs, 20, true) then
	sim:inspect()
	error("apply vcd failed")
end
print("csr_regfile sim matches VCD")

logd:make_svg()
return logd
