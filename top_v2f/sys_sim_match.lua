name = "sys"
module = name
module_file = module .. ".v"
snapshot_file = "snapshot.json"
delay = 45

use_json_rtl = true
save_to_disk = true
load_from_disk = true
skip_verification = false
verf = "verf/"
phyd_filename = verf .. "sim_match.phy.json"
logd_filename = verf .. "sim_match.logd.json"

---comment
---@param name string
---@param module string
---@param module_file string
---@param snapshot_file string
---@param delay integer
---@return string
function basic_test(name, module, module_file, snapshot_file, delay)
	rtl = nil
	logd = nil
	phy = nil
	if load_from_disk then
		phy, logd = load_design(phyd_filename, logd_filename)
		print("Loaded design from disk.")
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
		logd:group_io()
		phy = logd:make_phy()
	end

	if save_to_disk then
		phy:save_json(phyd_filename, logd_filename)
	end

	phy:save_svg(verf .. "sim_match.svg")
	phy:save_blueprint(verf .. "sim_match.json")
	print("sim_match.json blueprint created.")

	if skip_verification then
		return "Ended sim early"
	end

	sim = logd:new_simulation()
	arst = logd:find_in_port("arst")
	arst:set_enabled(true)
	arst:set_ith_output_count(0, 1)
	sim:step(delay)

	if not sim:apply_snapshot(snapshot_file, false) then
		sim:inspect()
		error("apply snapshot failed")
	end
	return name .. " matches the game"
end

return basic_test(name, module, module_file, snapshot_file, delay)
