if true then
	return "Turned off this for now"
end

name = "divider"
module = "riscv_" .. name
module_file = "../../core/riscv/" .. module .. ".v"
vcd_file = "." .. name .. "_tb.vcd"
delay = 20

rtl = yosys_load_rtl(module_file, module, "../../core/riscv")
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
if not sim:apply_vcd(vcd_file, inputs, outputs, 20, true) then
	sim:inspect()
	error("apply vcd failed")
end
print("csr_regfile sim matches VCD")

logd:make_svg()
return logd
