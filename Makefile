all: sintatico.o lexico.o
	gcc sintatico.o lexico.o -o analisador
sintatico.o: sintatico.c
	gcc -c sintatico.c -o sintatico.o
lexico.o: lexico.c
	gcc -c lexico.c -o lexico.o
lexico.c: lexico.l
	flex -olexico.c lexico.l
sintatico.c: sintatico.y
	bison -d -osintatico.c sintatico.y
clean:
	rm *.o lexico.c sintatico.c sintatico.h analisador

