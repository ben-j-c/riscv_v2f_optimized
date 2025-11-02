---comment
---@param name string
---@param module string
---@param module_file string
---@param vcd_file string
---@param delay integer
---@return LogicalDesignAPI
function basic_test(name, module, module_file, vcd_file, delay)
	rtl = yosys_load_rtl(module_file, module, "../../core/riscv")
	logd = yosys_map_rtl(rtl)

	inputs = {}
	for index, value in pairs(logd:in_ports()) do
		inputs["tb." .. index] = value
	end

	outputs = {}
	for index, value in pairs(logd:out_ports()) do
		outputs["tb.dut." .. index] = value
	end

	if not os.execute("../makevcd") then
		error("makevcd failed")
	end
	sim = logd:new_simulation()
	if not sim:apply_vcd(vcd_file, inputs, outputs, delay, true) then
		sim:inspect()
		error("apply vcd failed")
	end
	print(name .. " sim matches VCD")

	logd:make_svg()
	return logd
end
