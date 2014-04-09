all: lexico.o pseudosintatico.o
	gcc lexico.o sintatico.o -o analisador
lexico.o: lexico.c
	gcc -c lexico.c -o lexico.o
pseudosintatico.o:
	gcc -c sintatico.c -o sintatico.o
lexico.c: lexico.l
	flex -olexico.c lexico.l
sintatico.c: sintatico.y
	bison -d -osintatico.c sintatico.y
clean:
	rm *.o lexico.c sintatico.c analisador

