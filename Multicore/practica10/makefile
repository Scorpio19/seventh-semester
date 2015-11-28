main: main.o simd_alpha.o
	gcc main.o simd_alpha.o -o main -lm

main.o: main.c
	gcc -c main.c

simd_alpha.o: simd_alpha.asm
	nasm -f elf64 simd_alpha.asm
