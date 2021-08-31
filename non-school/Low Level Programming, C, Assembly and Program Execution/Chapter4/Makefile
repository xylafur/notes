all: mappings_loop mmap

mappings_loop:
	nasm -felf64 mappings_loop.asm -o hello.o
	ld -o mappings_loop hello.o
	chmod u+x mappings_loop

mmap:
	nasm -felf64 mmap.asm -o mmap.o
	ld -o mmap mmap.o
	chmod u+x mmap



clean:
	rm mappings_loop hello.o
	rm mmap mmap.o
