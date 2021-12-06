all: main

main:
	nasm -felf64 main.asm -o main.o
	nasm -felf64 lib.asm -o lib.o
	nasm -felf64 dict.asm -o dict.o
	ld -o main main.o lib.o dict.o
	chmod u+x main

clean:
	rm lib.o main.o dict.o main
