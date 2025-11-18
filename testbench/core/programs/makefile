AS=/opt/riscv/bin/riscv32-unknown-linux-gnu-as
LD=/opt/riscv/bin/riscv32-unknown-linux-gnu-ld
OBJCOPY=/opt/riscv/bin/riscv32-unknown-linux-gnu-objcopy

all: objcopy

clean:
	rm *.o *.elf *.bin

%.o: %.s
	$(AS) -march=rv32im -mabi=ilp32 -o $@ $<

%.elf: %.o
	$(LD) -Ttext=0x0000 -o $@ $<

%.bin: %.elf
	$(OBJCOPY) -O binary $< $@

assemble: $(wildcard *.s)
	

link: $(patsubst %.s, %.elf, $(wildcard *.s))
	

objcopy: $(patsubst %.s, %.bin, $(wildcard *.s))
	
