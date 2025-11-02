loadfile("../basic_test.lua")()

name = "exec"
module = "riscv_" .. name
module_file = "../../core/riscv/" .. module .. ".v"
vcd_file = name .. "_tb.vcd"
delay = 40

return basic_test(name, module, module_file, vcd_file, delay)
