rtl = yosys_load_rtl("../../core/riscv/riscv_regfile.v", "riscv_regfile")
logd = yosys_map_rtl(rtl)

clk_i = logd:find_in_port("clk_i") or error()
rst_i = logd:find_in_port("rst_i") or error()
rd0_i = logd:find_in_port("rd0_i") or error()
rd0_value_i = logd:find_in_port("rd0_value_i") or error()
ra0_i = logd:find_in_port("ra0_i") or error()
rb0_i = logd:find_in_port("rb0_i") or error()
ra0_value_o = logd:find_out_port("ra0_value_o") or error()
rb0_value_o = logd:find_out_port("rb0_value_o") or error()

--inputs = {}
--inputs["tb.data_a"] = data_a
--inputs["tb.data_b"] = data_b
--inputs["tb.select"] = select
--outputs = {}
--outputs["tb.result_y"] = result_y
--os.execute("../makevcd")
--sim = logd:new_simulation()
--if not sim:apply_vcd("tb.vcd", inputs, outputs, 10, true) then
--	error()
--end
--print("regfile sim matches VCD")

logd:make_svg()
return logd
