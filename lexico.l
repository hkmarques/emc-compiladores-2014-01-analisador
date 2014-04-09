
%{
// Secao do Flex de definicao de vriaveis da linguagem C, e inclusap  de arquivos de cabecalho
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include "tokenConst.h"
char msg[500];
extern void yyerror(char *s); 
int numLinha=1;
int erroOrigem=0;
%}

/*Secao do Flex destinada a definicoes regulares */

DIGIT [0-9]
CHAR [a-zA-Z]
ID [_a-zA-Z][_a-zA-Z0-9]*
STRING_DOUBLE \"[^([^\]\")]*\"
STRING_SINGLE \'[^([^\]\')]*\'
ASSIGNMENT [^<>!=]=[^<>!=]
%x comentario

%%

{DIGIT}+    {
 	             /* yytext armazena o lexema encontrado na entrada*/	
				return INTCONST;  /* numero inteiro correspondente ao token encontrado*/
	    }

"/*"		    BEGIN(comentario);
<comentario>[^*\n]*  /*se esta em uma start condition correspondente a comentario, consome 
                                    qualquer caractere que nao seja * ou \n */

<comentario>"*"+[^/\n]  
<comentario><<EOF>> 	{
				strcpy(msg, "Erro: comentario nao termina");
				yyerror(msg);
				erroOrigem = 1;
			}
<comentario>\n numLinha++;    
<comentario>"*"+"/"    BEGIN(INITIAL);  
     
"["			return '[';
   
"]"			return ']';
   			
"("			return '(';
			
")"			return ')';

"{"			return '{';

"}"			return '}';

"<="	                return LE;

">="			return GE;

"=="			return EQ;

{ASSIGNMENT}		return ASSIGN;

"!="			return DIFF;

"ou"			return OR;

"e"			return AND;

"+"			return '+';

"-"			return '-';

"*"			return '*';

"/"			return '/';

"programa"	        return PROGRAMA;

"leia" 			return LEIA;

"enquanto"		return ENQUANTO;

"car"			return TYPE_CAR;

"int"			return TYPE_INT;

"retorne"		return RETURN;

"escreva"		return ESCREVA;

"novalinha"		return NOVALINHA;

"se"			return SE;

"entao"			return ENTAO;

"senao"			return SENAO;

"execute"		return EXECUTE;

{STRING_DOUBLE}		return CONST_STRING;

{STRING_SINGLE}		return CONST_STRING;

{ID}                    return IDENTIFICADOR;

\n 			numLinha++;

[ \t]+ 			; /* consome caracteres de espaco */

<<EOF>> 		return(EOF);

.			{ 
				printf("Caractere invalido na linha %d: %s\n", numLinha, yytext);
                                erroOrigem = 1;
				exit(1);
			}		

%%

int yywrap(){return 1;}
