name = "pipe_ctrl"
module = "riscv_" .. name
module_file = "../../core/riscv/" .. module .. ".v"
yosys_vcd_file = name .. "_yosys_sim.vcd"
tb_vcd_file = name .. "_tb.vcd"
delay = 40

if not os.execute("../makevcd") then
	error("makevcd failed")
end

rtl = yosys_load_rtl(module_file, module, "../../core/riscv")
rtl:set_net_promotion(true)
rtl:yosys_sim(tb_vcd_file, yosys_vcd_file)
logd = yosys_map_rtl(rtl)

inputs = {}
for index, value in pairs(logd:in_ports()) do
	inputs[module .. "." .. index] = value
end

outputs = {}
for index, value in pairs(logd:out_ports()) do
	outputs[module .. "." .. index] = value
end

sim = logd:new_simulation()
if not sim:apply_vcd(yosys_vcd_file, inputs, outputs, delay, true) then
	sim:inspect()
	error("apply vcd failed")
end
print("csr_regfile sim matches VCD")

logd:make_svg()
return logd
