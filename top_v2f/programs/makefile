AS=/opt/riscv/bin/riscv32-unknown-elf-as
CC=/opt/riscv/bin/riscv32-unknown-elf-gcc
LD=/opt/riscv/bin/riscv32-unknown-elf-ld
OBJCOPY=/opt/riscv/bin/riscv32-unknown-elf-objcopy
V2F=../../../../target/release/v2f

ARCH = -march=rv32im -mabi=ilp32
CFLAGS = $(ARCH) -ffreestanding -nostdlib -O2 -Wall
ASFLAGS = $(ARCH)
LD_FLAGS = --no-relax -Tlink.ld

STARTUP := start.o
C_SRCS := $(wildcard *.c)
S_SRCS := $(wildcard *.s)
C_OBJS := $(C_SRCS:.c=.o)
S_OBJS := $(S_SRCS:.s=.o)
S_OBJS := $(filter-out $(STARTUP), $(S_OBJS))


C_MEMS := $(C_SRCS:.c=.mem)
S_MEMS := $(S_OBJS:.o=.mem)

.PHONY: all clean program

all: program

program: $(C_MEMS) $(S_MEMS)

clean:
	rm -f *.o *.elf *.bin *.mem

$(C_OBJS): %.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

$(S_OBJS) $(STARTUP): %.o: %.s
	$(AS) $(ASFLAGS) -o $@ $<

$(C_SRCS:.c=.elf): %.elf: %.o $(STARTUP)
	$(LD) $(LD_FLAGS) -o $@ $(STARTUP) $<

$(S_OBJS:.o=.elf): %.elf: %.o
	$(LD) $(LD_FLAGS) -o $@ $<

# Binaries

%.bin: %.elf
	$(OBJCOPY) -O binary $< $@

%.mem: %.bin
	$(V2F) --convert-to-memh -i $< -o $@