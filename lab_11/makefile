all:
	nasm -felf64 -F dwarf -g -o main.o -l main.lst main.asm && \
	ld -s -m elf_x86_64 main.o -o main -lc --dynamic-linker /lib64/ld-linux-x86-64.so.2 -lgtk-3 -lgobject-2.0 -lglib-2.0 -lgdk_pixbuf-2.0 -lgdk-3 -lpango-1.0 -latk-1.0 -lgio-2.0 -lpangoft2-1.0  -lpangocairo-1.0 -lcairo -lfreetype -lfontconfig  -lgmodule-2.0 -lgthread-2.0 -lrt

.PHONY: clean

clean:
	rm -rf *.o *.lst main
