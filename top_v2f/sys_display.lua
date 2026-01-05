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
	return logd
end

---@param computer EnsembleAPI
---@param x integer
---@param y integer
---@return DisplayPanel
function add_hex_display(computer, x, y)
	disp = {}
	for i = 0, 7 do
		display = computer:add_display_panel(x + 7 - i, y)
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
	return disp[7]
end

---@param computer EnsembleAPI
---@param x integer
---@param y integer
---@param sig Signal
---@return Arithmetic, Arithmetic
function add_hex_driver(computer, x, y, sig)
	d0_shr = computer:add_arithmetic(x + 00, y, sig >> 0, sig) or error()
	d1_shr = computer:add_arithmetic(x + 02, y, sig >> 4, sig) or error()
	d2_shr = computer:add_arithmetic(x + 04, y, sig >> 8, sig) or error()
	d3_shr = computer:add_arithmetic(x + 06, y, sig >> 12, sig) or error()
	d4_shr = computer:add_arithmetic(x + 08, y, sig >> 16, sig) or error()
	d5_shr = computer:add_arithmetic(x + 10, y, sig >> 20, sig) or error()
	d6_shr = computer:add_arithmetic(x + 12, y, sig >> 24, sig) or error()
	d7_shr = computer:add_arithmetic(x + 14, y, sig >> 28, sig) or error()
	d0_and = computer:add_arithmetic(x + 00, y + 1, sig & 0xF, Signal("signal-0")) or error()
	d1_and = computer:add_arithmetic(x + 02, y + 1, sig & 0xF, Signal("signal-1")) or error()
	d2_and = computer:add_arithmetic(x + 04, y + 1, sig & 0xF, Signal("signal-2")) or error()
	d3_and = computer:add_arithmetic(x + 06, y + 1, sig & 0xF, Signal("signal-3")) or error()
	d4_and = computer:add_arithmetic(x + 08, y + 1, sig & 0xF, Signal("signal-4")) or error()
	d5_and = computer:add_arithmetic(x + 10, y + 1, sig & 0xF, Signal("signal-5")) or error()
	d6_and = computer:add_arithmetic(x + 12, y + 1, sig & 0xF, Signal("signal-6")) or error()
	d7_and = computer:add_arithmetic(x + 14, y + 1, sig & 0xF, Signal("signal-7")) or error()

	computer:connect(d0_shr.output.red, d0_and.input)
	computer:connect(d1_shr.output.red, d1_and.input)
	computer:connect(d2_shr.output.red, d2_and.input)
	computer:connect(d3_shr.output.red, d3_and.input)
	computer:connect(d4_shr.output.red, d4_and.input)
	computer:connect(d5_shr.output.red, d5_and.input)
	computer:connect(d6_shr.output.red, d6_and.input)
	computer:connect(d7_shr.output.red, d7_and.input)

	computer:connect(d0_shr.input.red, d1_shr.input)
	computer:connect(d1_shr.input.red, d2_shr.input)
	computer:connect(d2_shr.input.red, d3_shr.input)
	computer:connect(d3_shr.input.red, d4_shr.input)
	computer:connect(d4_shr.input.red, d5_shr.input)
	computer:connect(d5_shr.input.red, d6_shr.input)
	computer:connect(d6_shr.input.red, d7_shr.input)

	computer:connect(d0_and.output.red, d1_and.output)
	computer:connect(d1_and.output.red, d2_and.output)
	computer:connect(d2_and.output.red, d3_and.output)
	computer:connect(d3_and.output.red, d4_and.output)
	computer:connect(d4_and.output.red, d5_and.output)
	computer:connect(d5_and.output.red, d6_and.output)
	computer:connect(d6_and.output.red, d7_and.output)
	return d0_shr, d7_and
end

---@param computer EnsembleAPI
---@param x integer
---@param y integer
---@param sig Signal
---@return Arithmetic
function add_hex_driver_and_display(computer, x, y, sig)
	driver_in, driver_out = add_hex_driver(computer, x, y, sig)
	disp = add_hex_display(computer, x + 18, y)
	computer:connect(driver_out.output.red, disp.input)
	return driver_in
end

---@param computer EnsembleAPI
---@param x integer
---@param y integer
---@param sig Signal
---@param name string
---@return Arithmetic
function add_lamp_indicator(computer, x, y, sig, name)
	ret = computer:add_arithmetic(x, y, sig + 0, sig) or error("failed to place")
	ret:set_description(name)
	lamp = computer:add_lamp(x + 2, y, Expr(sig, "!=", 0)) or error("failed to place")
	computer:connect(ret.output.red, lamp.input)
	return ret
end

name = "sys"
module = name
module_file = module .. ".v"
delay = 60
program = "check_vram"

if not os.execute("./build_mem " .. program) then
	error("build_mem failed")
end

logd = compile(module, module_file, true, false)

computer = make_ensemble()
computer:freeze_and_place(name, logd:make_phy(), 0, 0)

width = computer.width
height = computer.height

-- Hex ports for 32 bit values
hex_ports = {
	name .. ".fab.vram_reg_0.q",
	name .. ".fab.vram_reg_1.q",
	name .. ".fab.vram_reg_2.q",
	name .. ".fab.vram_reg_3.q",
	name .. ".fab.vram_reg_4.q",
	name .. ".fab.vram_reg_5.q",
	name .. ".fab.vram_reg_6.q",
	name .. ".fab.vram_reg_7.q",
	"",
	name .. ".instr_addr",
	name .. ".instr_q",
	name .. ".mem_d_addr_o",
	name .. ".mem_d_data_rd_i",
	name .. ".mem_d_wr_o",
	name .. ".mem_d_data_wr_o",
	"",
	name .. ".core.u_issue.u_regfile.REGFILE.x1_ra_w",
	name .. ".core.u_issue.u_regfile.REGFILE.x2_sp_w",
	name .. ".core.u_issue.u_regfile.REGFILE.x3_gp_w",
	name .. ".core.u_issue.u_regfile.REGFILE.x4_tp_w",
	name .. ".core.u_issue.u_regfile.REGFILE.x5_t0_w",
	name .. ".core.u_issue.u_regfile.REGFILE.x6_t1_w",
	name .. ".core.u_issue.u_regfile.REGFILE.x7_t2_w",
	name .. ".core.u_issue.u_regfile.REGFILE.x8_s0_w",
	name .. ".core.u_issue.u_regfile.REGFILE.x9_s1_w",
	name .. ".core.u_issue.u_regfile.REGFILE.x10_a0_w",
	name .. ".core.u_issue.u_regfile.REGFILE.x11_a1_w",
	name .. ".core.u_issue.u_regfile.REGFILE.x12_a2_w",
	name .. ".core.u_issue.u_regfile.REGFILE.x13_a3_w",
	name .. ".core.u_issue.u_regfile.REGFILE.x14_a4_w",
	name .. ".core.u_issue.u_regfile.REGFILE.x15_a5_w",
	name .. ".core.u_issue.u_regfile.REGFILE.x16_a6_w",
	name .. ".core.u_issue.u_regfile.REGFILE.x17_a7_w",
	name .. ".core.u_issue.u_regfile.REGFILE.x18_s2_w",
}
hex_ports_sinks = {}
for idx, name in pairs(hex_ports) do
	if name == "" then
		goto continue
	end
	port = computer:find_out_port(name) or error()
	driver = add_hex_driver_and_display(computer, width + 20, (idx - 1) * 2, port.signals[1])
	driver:set_description(name)
	hex_ports_sinks[name] = driver.input
	::continue::
end

-- Lamps for single bit values
indicator_ports = {
	name .. ".mem_d_error_i",
	name .. ".mem_i_error_i",
	name .. ".vram_en",
	name .. ".mem_d_rd_o",
	name .. ".mem_i_rd_o",
}
indicator_ports_sinks = {}
for idx, name in pairs(indicator_ports) do
	port = computer:find_out_port(name) or error()
	indicator = add_lamp_indicator(computer, width + 20, 80 + idx - 1, port.signals[1], name)
	indicator_ports_sinks[name] = indicator.input
end

-- connect displays
for name, sink in pairs(hex_ports_sinks) do
	port = computer:find_out_port(name) or error()
	computer:connect(port.input.red, sink)
end

for name, sink in pairs(indicator_ports_sinks) do
	port = computer:find_out_port(name) or error()
	computer:connect(port.input.red, sink)
end


-- pull out the clock and reset to a more convenient location

clk = computer:find_in_port(name .. ".clk") or error()
rst = computer:find_in_port(name .. ".arst") or error()

clk_user = computer:add_constant(width + 60, 0, { clk.signals[1] }, { 1 }) or error()
clk_user:set_enabled(false)
rst_user = computer:add_constant(width + 60, 1, { rst.signals[1] }, { 1 }) or error()
clk_user:set_description("clk")
rst_user:set_description("rst")

computer:connect(clk_user.output.red, clk.output)
computer:connect(rst_user.output.red, rst.output)


computer:make_svg("final.svg")

return computer
