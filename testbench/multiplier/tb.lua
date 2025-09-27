rtl = yosys_load_rtl("../../core/riscv/riscv_multiplier.v", "riscv_multiplier")
logd = yosys_map_rtl(rtl)

if false then
	data_a = logd:find_in_port("alu_a_i") or error()
	data_b = logd:find_in_port("alu_b_i") or error()
	select = logd:find_in_port("alu_op_i") or error()
	result_y = logd:find_out_port("alu_p_o") or error()

	inputs = {}
	inputs["tb.data_a"] = data_a
	inputs["tb.data_b"] = data_b
	inputs["tb.select"] = select
	outputs = {}
	outputs["tb.result_y"] = result_y
	os.execute("../makevcd")
	sim = logd:new_simulation()
	if not sim:apply_vcd("tb.vcd", inputs, outputs, 10, true) then
		error()
	end
	print("ALU sim matches VCD")

	logd:make_svg()
end

return logd
