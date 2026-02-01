name = "char_font_decoder_8x8"
module = name
module_file = module .. ".v"
vcd_file = name .. "_tb.vcd"
delay = 30

rtl = yosys_load_rtl(module_file, module)
logd = yosys_map_rtl(rtl)

return "built"
