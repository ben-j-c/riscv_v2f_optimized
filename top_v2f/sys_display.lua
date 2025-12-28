---comment
---@param module string
---@param module_file string
---@return LogicalDesignAPI
function compile(module, module_file, use_json_rtl, skip_synth)
	rtl = nil
	logd = nil
	if skip_synth then
		logd = load_mapped_rtl(module .. "_rtl_map.json")
	else
		if use_json_rtl then
			if not os.execute("yosys -s rtl.ys") then
				error("rtl compile failed")
			end
			rtl = yosys_load_rtl(module .. "_rtl.json", module, "../core/riscv")
		else
			rtl = yosys_load_rtl(module_file, module, "../core/riscv")
		end
		logd = yosys_map_rtl(rtl)
	end

	inputs = {}
	for index, value in pairs(logd:in_ports()) do
		inputs["sys_tb." .. index] = value
	end

	outputs = {}
	for index, value in pairs(logd:out_ports()) do
		outputs["sys_tb.dut." .. index] = value
		print(index)
	end

	logd:make_svg()
	logd:group_io()
	return logd
end

---@param computer EnsembleAPI
---@param x integer
---@param y integer
---@return DisplayPanel
function add_hex_display(computer, x, y)
	disp = {}
	for i = 0, 7 do
		display = computer:add_display_panel(x + i, y)
		if display == nil then
			computer:make_svg("failed_place.svg")
			error("failed to place")
		end
		disp[i] = display
		if i > 0 then
			computer:connect(disp[i].input.red, disp[i - 1].input)
		end
		-- 0 through 9
		for j = 0, 9 do
			display:add_entry(Expr("signal-" .. i, "==", j), Signal("signal-" .. j))
		end
		-- hex digits
		for j = 10, 15 do
			char = string.char(65 + j - 10)
			display:add_entry(Expr("signal-" .. i, "==", j), Signal("signal-" .. char))
		end
		-- error case
		display:add_entry(Expr("signal-" .. i, ">", 15), Signal("signal-X"))
	end
	return disp[0]
end

name = "sys"
module = name
module_file = module .. ".v"
delay = 60

logd = compile(module, module_file, true, true)

computer = make_ensemble()
computer:freeze_and_place(name, logd:make_phy(), 0, 0)

width = computer.width
height = computer.height

disp_prefix = name .. ".fab.disp_"

displays = {}


-- first place all displays because routing can take up space
for i = 0, 7 do
	disp = add_hex_display(computer, width + 20, 2 + i * 2)
	displays[i] = disp
end

-- connect displays
for i = 0, 7 do
	for j = 0, 6 do
		first = computer:find_out_port(disp_prefix .. i .. "_signal_" .. j) or error()
		second = computer:find_out_port(disp_prefix .. i .. "_signal_" .. (j + 1)) or error()
		computer:connect(first.input.red, second.input)
	end
	first = computer:find_out_port(disp_prefix .. i .. "_signal_0") or error()
	disp = displays[i]
	computer:connect(first.input.red, disp.input)
end

inspect_q = computer:find_out_port(name .. ".inspect_q") or error()
lamp = computer:add_lamp(width + 20, 50, Expr("signal-0", "!=", 0)) or error()
computer:connect(inspect_q.input.red, lamp.input)


computer:make_svg("final.svg")

return computer
