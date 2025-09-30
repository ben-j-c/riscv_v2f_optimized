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

inputs = {}
inputs["tb.clk_i"] = clk_i
inputs["tb.rst_i"] = rst_i
inputs["tb.rd0_i"] = rd0_i
inputs["tb.rd0_value_i"] = rd0_value_i
inputs["tb.ra0_i"] = ra0_i
inputs["tb.rb0_i"] = rb0_i
outputs = {}
outputs["tb.ra0_value_o"] = ra0_value_o
outputs["tb.rb0_value_o"] = rb0_value_o
os.execute("../makevcd")
sim = logd:new_simulation()
if not sim:apply_vcd("tb.vcd", inputs, outputs, 10, true) then
	error()
end
print("regfile sim matches VCD")

logd:make_svg()
return logd
