SRC := $(wildcard src/*.asm)
OBJ := $(SRC:src/%.asm=obj/%.o)
ASM := nasm -f elf32 -g
LD  := ld -m elf_i386

main.out: $(OBJ)
	$(LD) $^ -o $@

$(OBJ): obj/%.o: src/%.asm
	mkdir -p $(dir $@) && $(ASM) -o $@ $^

.PHONY: clean
clean:
	rm -rf obj main.out
