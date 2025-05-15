# HW11_313
This program takes the number of bytes of data and translates the data into the output buffer.

Assemble: nasm -f elf32 translate.asm -o translate.o

Link: ld -m elf_i386 translate.o -o translate

Run: ./translate
