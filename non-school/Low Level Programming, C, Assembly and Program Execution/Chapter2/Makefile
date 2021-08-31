
all: hello print_rax print_call strlen

hello:
	nasm -felf64 hello.asm -o hello.o
	ld -o hello hello.o
	chmod u+x hello

print_rax:
	nasm -felf64 print_rax.asm -o print_rax.o
	ld -o print_rax print_rax.o
	chmod u+x print_rax

print_call:
	nasm -felf64 print_call.asm -o print_call.o
	ld -o print_call print_call.o
	chmod u+x print_call

strlen:
	nasm -felf64 strlen.asm -o strlen.o
	ld -o strlen strlen.o
	chmod u+x strlen

clean:
	rm hello hello.o
	rm print_rax print_rax.o
	rm print_call.o print_call
	rm strlen.o strlen
