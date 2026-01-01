loadfile("../basic_test.lua")()

name = "fetch"
module = "riscv_" .. name
module_file = "../../core/riscv/" .. module .. ".v"
vcd_file = name .. "_tb.vcd"
delay = 20

return basic_test(name, module, module_file, vcd_file, delay)
