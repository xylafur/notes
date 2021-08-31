all: main

main:
	nasm -felf64 main.asm -o main.o
	ld -o main main.o
	chmod u+x main

clean:
	rm main.o main
