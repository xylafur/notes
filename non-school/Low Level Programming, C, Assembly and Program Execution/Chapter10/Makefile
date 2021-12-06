square:
	gcc -c -std=c89 -pedantic -Wall main_square.c
	gcc -c -std=c89 -pedantic -Wall square.c
	gcc -o main square.o main_square.o

objdump: square
	objdump -t main_square.o
	objdump -t square.o
	objdump -t main

clean:
	rm -rf main square.o main_square.o


