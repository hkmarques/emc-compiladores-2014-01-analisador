#include<stdlib.h>
#include<stdio.h>
#include "tokenConst.h"

/* Variaveis globais externas definidas no código gerado pelo Flex */
extern int yylex();
extern char* yytext; 
extern FILE*  yyin; /*variavel global gerada pelo Flex para armazenar 
                      o ponterio para o arquivo de entrada */
extern int numLinha;

void yyerror(char *msg){
        printf("%s\n", msg);
        exit(1);
}

int tok;     
int main(int argc, char** argv){
   if(argc!=2)
	yyerror("Uso correto: ./pseudoSintatico nome_arq_entrada");
   yyin=fopen(argv[1], "r");
   if(!yyin){
	yyerror("arquivo não pode ser aberto\n");
 	exit(1);
   }
   while(1){
	tok=yylex();
	switch(tok){
        case IDENTIFICADOR:
	     printf("Encontei o identificador %s na linha %d \n", yytext,numLinha);
             break;	
	case '[':
	     printf("Encontei um [ na linha %d \n", numLinha);
             break;
	case INTCONST:
	     printf("Encontrei um número inteiro: %s na linha %d \n", yytext, numLinha);
	     break;
	case ']':
             printf("Encontei um ] na linha %d\n", numLinha );
             break;
	case '(':
	     printf("Encontei um ( na linha %d \n", numLinha);
             break;
	case ')':
	     printf("Encontei um ) na linha %d \n", numLinha);
             break;
        case LE:
	     printf("Encontei um  %s na linha %d\n", yytext, numLinha);
             break;
	case PROGRAMA:
	     printf("Encontei a palavra reservada %s na linha %d \n", yytext, numLinha);
             break;
	case LEIA:
	     printf("Encontei a palavra reservada %s na linha %d \n", yytext, numLinha);
             break;
	case ENQUANTO:
             printf("Encontei a palavra reservada %s na linha %d\n", yytext, numLinha);
             break;
	case TYPE_CAR:
             printf("Encontei a palavra reservada %s na linha %d\n", yytext, numLinha);
             break;
	case TYPE_INT:
             printf("Encontei a palavra reservada %s na linha %d\n", yytext, numLinha);
             break;
	case RETURN:
             printf("Encontei a palavra reservada %s na linha %d\n", yytext, numLinha);
             break;
	case ESCREVA:
             printf("Encontei a palavra reservada %s na linha %d\n", yytext, numLinha);
             break;
	case NOVALINHA:
             printf("Encontei uma quebra de linha na linha %d\n", numLinha);
             break;
	case SE:
             printf("Encontei a palavra reservada %s na linha %d\n", yytext, numLinha);
             break;
	case ENTAO:
             printf("Encontei a palavra reservada %s na linha %d\n", yytext, numLinha);
             break;
	case SENAO:
             printf("Encontei a palavra reservada %s na linha %d\n", yytext, numLinha);
             break;
	case EXECUTE:
             printf("Encontei a palavra reservada %s na linha %d\n", yytext, numLinha);
             break;
	case CONST_STRING:
             printf("Encontei a cadeia de caracteres \"%s\" na linha %d\n", yytext, numLinha);
             break;
	case EOF: exit(1);
	}
   }

}
