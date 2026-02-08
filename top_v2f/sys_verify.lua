---comment
---@param name string
---@param module string
---@param module_file string
---@param vcd_file string
---@param delay integer
---@return LogicalDesignAPI
function basic_test(name, module, module_file, vcd_file, delay, use_json_rtl)
	rtl = nil
	if use_json_rtl then
		if not os.execute("yosys -s rtl.ys") then
			error("rtl compile failed")
		end
		rtl = yosys_load_rtl(module .. "_rtl.json", module, "../core/riscv")
	else
		rtl = yosys_load_rtl(module_file, module, "../core/riscv")
	end
	logd = yosys_map_rtl(rtl)

	inputs = {}
	for index, value in pairs(logd:in_ports()) do
		inputs["sys_tb." .. index] = value
	end

	outputs = {}
	for index, value in pairs(logd:out_ports()) do
		outputs["sys_tb.dut." .. index] = value
	end

	if not os.execute("./makevcd") then
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

name = "sys"
module = name
module_file = module .. ".v"
vcd_file = name .. "_tb.vcd"
delay = 63

basic_test(name, module, module_file, vcd_file, delay, true)
return "Test successful"
