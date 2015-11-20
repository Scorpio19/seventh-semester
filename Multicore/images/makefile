main: main.o simd_light.o
	gcc main.o simd_light.o -o main -lm

main.o: main.c
	gcc -c main.c

simd_light.o: simd_light.asm
	nasm -f elf64 simd_light.asm
