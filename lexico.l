
%{
// Secao do Flex de definicao de vriaveis da linguagem C, e inclusap  de arquivos de cabecalho
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include "sintatico.h"

char msg[500];
int erroOrigem = 1, numLinha = 1;
%}

/*Secao do Flex destinada a definicoes regulares */

DIGIT [0-9]
CHAR [a-zA-Z]
ID [_a-zA-Z][_a-zA-Z0-9]*
STRING_DOUBLE \"(\\.|[^\\"])*\"
STRING_SINGLE \'(\\.|[^\\'])*\'
%x comentario

%%

{DIGIT}+    {
                /* yytext armazena o lexema encontrado na entrada*/
                //sscanf(yytext, "%d", &yylval->value);
                return INTCONST;  /* numero inteiro correspondente ao token encontrado*/
	    }

"/*"		    BEGIN(comentario);
<comentario>[^*\n]*  /*se esta em uma start condition correspondente a comentario, consome 
                                    qualquer caractere que nao seja * ou \n */

<comentario>"*"+[^/\n]  
<comentario><<EOF>> 	{
				strcpy(msg, "Erro: comentario nao termina");
				yyerror(msg);
                                erroOrigem=0;
			}
<comentario>\n numLinha++;    
<comentario>"*"+"/"    BEGIN(INITIAL);  
     
"["			return '[';
   
"]"			return ']';
   			
"("			return '(';
			
")"			return ')';

"{"			return '{';

"}"			return '}';

","                     return ',';

"<="	                return LE;

">="			return GE;

"=="			return EQ;

"="	 		return '=';

"!="			return DIFF;

"ou"			return OU;

"e"			return E;

"+"			return '+';

"-"			return '-';

"*"			return '*';

"/"			return '/';

"%"			return '%';

"programa"	        return PROGRAMA;

"leia" 			return LEIA;

"enquanto"		return ENQUANTO;

"car"			return TYPE_CAR;

"int"			return TYPE_INT;

"retorne"		return RETORNE;

"escreva"		return ESCREVA;

"novalinha"		return NOVALINHA;

"se"			return SE;

"entao"			return ENTAO;

"senao"			return SENAO;

"execute"		return EXECUTE;

";"                     return ';';

{STRING_DOUBLE}		{
				        return CONST_STRING;
			        }

{STRING_SINGLE}		{
				        return CONST_STRING;
			        }

{ID}                {
				        return IDENTIFICADOR;
			        }

[\n] 			numLinha++;

[ \t\r]+ 			; /* consome caracteres de espaco */

<<EOF>> 		return(EOF);

.			{ 
				printf("Caractere invalido na linha %d: %s\n", numLinha, yytext);
                                erroOrigem=0;
				exit(1);
			}		

%%

int yywrap(void) {
	return 1;
}
