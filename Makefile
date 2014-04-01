all: lexico.o pseudosintatico.o
	gcc lexico.o pseudosintatico.o -o sint
lexico.o: lexico.c
	gcc -c lexico.c -o lexico.o
pseudosintatico.o:
	gcc -c pseudosintatico.c -o pseudosintatico.o
lexico.c: lexico.l
	flex -olexico.c lexico.l
clean:
	rm *.o lexico.c sint

