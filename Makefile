AS := nasm
LDFLAGS := -melf_i386
SOURCES := $(wildcard *.s)
TARGETS := $(patsubst %.s, %, $(SOURCES))

all: $(TARGETS)

%: %.s
	$(AS) -fbin $^ -o $@.bin
	$(AS) -felf32 $^ -o $@.o
	$(LD) $(LDFLAGS) $@.o -o $@

clean:
	$(RM) $(TARGETS) *.o *.bin
