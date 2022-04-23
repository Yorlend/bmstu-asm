all:
	nasm -f elf64 copy_string.asm -o copy_string.o && \
	gcc -c main.c && \
	gcc main.o copy_string.o

.PHONY: clean

clean:
	rm *.o *.out *.s
