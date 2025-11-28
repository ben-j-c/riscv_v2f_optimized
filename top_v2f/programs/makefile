AS=/opt/riscv/bin/riscv32-unknown-elf-as
LD=/opt/riscv/bin/riscv32-unknown-elf-ld
OBJCOPY=/opt/riscv/bin/riscv32-unknown-elf-objcopy
V2F=../../../../target/release/v2f

LD_FLAGS = --no-relax
LD_FLAGS += -Tlink.ld

.PHONY: all clean assemble link objcopy program

all: program

clean:
	rm -f *.o *.elf *.bin *.mem

%.o: %.s
	$(AS) -march=rv32im -mabi=ilp32 -o $@ $<

%.elf: %.o
	$(LD) $(LD_FLAGS) -o $@ $<

%.bin: %.elf
	$(OBJCOPY) -O binary $< $@

%.mem: %.bin
	$(V2F) --convert-to-memh -i $< -o $@

assemble: $(patsubst %.s, %.o, $(wildcard *.s))
	

link: $(patsubst %.s, %.elf, $(wildcard *.s))
	

objcopy: $(patsubst %.s, %.bin, $(wildcard *.s))
	

program: $(patsubst %.s, %.mem, $(wildcard *.s))