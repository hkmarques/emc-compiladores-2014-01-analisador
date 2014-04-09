all: lexico.o sintatico.o
	gcc lexico.o sintatico.o -o analisador
sintatico.o: sintatico.c
	gcc -c sintatico.c -o sintatico.o
sintatico.c: sintatico.y
	bison -d -osintatico.c sintatico.y
lexico.o: lexico.c
	gcc -c lexico.c -o lexico.o
lexico.c: lexico.l
	flex -olexico.c lexico.l
clean:
	rm *.o lexico.c sintatico.c sintatico.h analisador

