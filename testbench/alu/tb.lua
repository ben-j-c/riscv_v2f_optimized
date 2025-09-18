rtl = yosys_load_rtl("../../core/riscv/riscv/riscv_alu.v", "alu")
logd = yosys_map_rtl(rtl)

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
