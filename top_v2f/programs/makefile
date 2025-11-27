AS=/opt/riscv/bin/riscv32-unknown-linux-gnu-as
LD=/opt/riscv/bin/riscv32-unknown-linux-gnu-ld
OBJCOPY=/opt/riscv/bin/riscv32-unknown-linux-gnu-objcopy
V2F=../../../../target/release/v2f

.PHONY: all clean assemble link objcopy program

all: objcopy

clean:
	rm -f *.o *.elf *.bin *.mem

%.o: %.s
	$(AS) -march=rv32im -mabi=ilp32 -o $@ $<

%.elf: %.o
	$(LD) -Ttext=0x0000 -o $@ $<

%.bin: %.elf
	$(OBJCOPY) -O binary $< $@

%.mem: %.bin
	$(V2F) --convert-to-memh -i $< -o $@

assemble: $(patsubst %.s, %.o, $(wildcard *.s))
	

link: $(patsubst %.s, %.elf, $(wildcard *.s))
	

objcopy: $(patsubst %.s, %.bin, $(wildcard *.s))
	

program: $(patsubst %.s, %.mem, $(wildcard *.s))