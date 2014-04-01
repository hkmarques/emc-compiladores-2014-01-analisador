
%{
// Secao do Flex de definicao de vriaveis da linguagem C, e inclusap  de arquivos de cabecalho
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include "tokenConst.h"
char msg[500];
extern void yyerror(char *s); 
int numLinha=1;

%}

/*Secao do Flex destinada a definicoes regulares */

DIGIT [0-9]
CHAR[a-zA-Z]
ID [_a-zA-Z][_a-zA-Z0-9]*
%x comentario
%x literal_string_single_quote
%x literal_string_double_quote
%%


{DIGIT}+    {
 	             /* yytext armazena o lexema encontrado na entrada*/	
				return INTCONST;  /* numero inteiro correspondente ao token encontrado*/
	    }

"/*"		    BEGIN(comentario);
<comentario>[^*\n]*  /*se esta em uma start condition correspondente a comentario, consome 
                                    qualquer caractere que nao seja * ou \n */

<comentario>"*"+[^/\n]  
<comentario><<EOF>> {
                    strcpy(msg, "Erro: comentario nao termina");
		    yyerror(msg);
                  }
<comentario>\n numLinha++;    
<comentario>"*"+"/"    BEGIN(INITIAL);  
     
"["			return '[';
			
   
"]"			return ']';
   			

"("			return '(';
			
   
")"			return ')';
   				

"<="	                return LE;


"+"			return '+';

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

\"			BEGIN(literal_string_double_quote);
<literal_string_double_quote>\n 	{
						strcpy(msg, "Erro: a cadeira de caracteres ocupa mais de uma linha");
						yyerror(msg);
					}

<literal_string_double_quote>[^\\]\" 	{
						BEGIN(INITIAL);
						return CONST_STRING;
					}

\'			BEGIN(literal_string_single_quote);
<literal_string_single_quote>\n 	{
						strcpy(msg, "Erro: a cadeira de caracteres ocupa mais de uma linha");
						yyerror(msg);
					}

<literal_string_single_quote>[^\\]\' 	{
						BEGIN(INITIAL);
						return CONST_STRING;
					}

{ID}                    return IDENTIFICADOR;

\n 			numLinha++;

[ \t]+ 	; /* consome caracteres de espaco */

<<EOF>> return(EOF);

.			{ 
				
				printf("Caractere invalido: %s\n", yytext);
				exit(1);
			}		

%%

int yywrap(){return 1;}
