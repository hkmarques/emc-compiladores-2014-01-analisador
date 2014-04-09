%{
/* Secao prologo*/
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include "sintatico.h"
extern char * yytext;
extern int yylex();
extern int numLinha;
extern FILE* yyin;
extern int erroOrigem;
void yyerror( char const *s);
%}
/* Secao de definicoes para o Bison 
 define os simbolos usados na gramatica e tipos dos valores
 semanticos associados a cada simbolo (terminal e não terminal)*/ 

%start Programa /* Inidica que o simbolo incial da gramatica e programm */  

%token ESCREVA LEIA OU RETORNE ENQUANTO SE SENAO EXECUTE ENTAO PROGRAMA NOVALINHA CONST_STRING INTCONST TYPE_CAR TYPE_INT IDENTIFICADOR E ASSIGN DIFF EQ GE LE/* Definicao de terminais (que não apenas caracteres), com o uso da diretiva
                              %token. Ha outras opcoes para definicao de tokens (especificando ordem de associacao e 
			      prescedencia de operadores -  ver secao 3.2 do manual do Bison*/

/* Pode haver mais de uma secao prologo e mais de uma secao de definicoes do Bison. 
   Estas secoes podem aparecer intercaladas entre si. Ver Secao 3.1.1 */

%%  /* Secao de regras - producoes da gramatica - Veja as normas de formação de produçoes na secao 3.3 do manual */

Programa 		:	DeclFuncVar
				| DeclProg
				;
DeclFuncVar             :       Tipo IDENTIFICADOR DeclVar ';' DeclFuncVar
                                | Tipo IDENTIFICADOR INTCONST DeclVar ';' DeclFuncVar
                                | Tipo IDENTIFICADOR DeclFunc DeclFuncVar
                                |
                                ;
DeclProg                :       PROGRAMA Bloco
                                ;
DeclVar                 :       ',' IDENTIFICADOR DeclVar
                                | ',' IDENTIFICADOR INTCONST DeclVar
                                |
                                ;
DeclFunc                :       '(' ListaParametros ')' Bloco
                                ;
ListaParametros         :       
                                | ListaParametrosCont
                                ;
ListaParametrosCont     :       Tipo IDENTIFICADOR
                                | Tipo IDENTIFICADOR '['']'
                                | Tipo IDENTIFICADOR ',' ListaParametrosCont
                                | Tipo IDENTIFICADOR '['']' ',' ListaParametrosCont
                                ;
Bloco                   :       '{' ListaDeclVar ListaComando '}'
                                | '{' ListaDeclVar '}'
                                ;
ListaDeclVar            :       
                                | Tipo IDENTIFICADOR DeclVar ';' ListaDeclVar
                                | Tipo IDENTIFICADOR INTCONST DeclVar ';' ListaDeclVar
                                ;
Tipo                    :       TYPE_INT
                                | TYPE_CAR
                                ;
ListaComando            :       Comando
                                | Comando ListaComando
                                ;
Comando                 :       ';'
                                | Expr ';'
                                | RETORNE Expr ';'
                                | LEIA LValueExpr ';'
                                | ESCREVA Expr ';'
                                | ESCREVA CONST_STRING ';'
                                | NOVALINHA ';'
                                | SE '(' Expr ')' ENTAO Comando
                                | SE '(' Expr ')' ENTAO Comando SENAO Comando
                                | ENQUANTO '(' Expr ')' EXECUTE Comando
                                | Bloco
                                ;
Expr                    :       AssignExpr
                                ;
AssignExpr              :       CondExpr
                                | LValueExpr ASSIGN AssignExpr
                                ;
CondExpr                :       OrExpr
                                | OrExpr '?' Expr ':' CondExpr
                                ;
OrExpr                  :       OrExpr OU AndExpr
                                | AndExpr
                                ;
AndExpr                 :       AndExpr E EqExpr
                                | EqExpr
                                ;
EqExpr                  :       EqExpr EQ DesigExpr
                                | EqExpr DIFF DesigExpr
                                | DesigExpr
                                ;
DesigExpr               :       DesigExpr '<' AddExpr
                                | DesigExpr '>' AddExpr
                                | DesigExpr GE AddExpr
                                | DesigExpr LE AddExpr
                                | AddExpr
                                ;
AddExpr                 :       AddExpr '+' MulExpr
                                | AddExpr '-' MulExpr
                                | MulExpr
                                ;
MulExpr                 :       MulExpr '*' UnExpr
                                | MulExpr '/' UnExpr
                                | MulExpr '%' UnExpr
                                | UnExpr
                                ;
UnExpr                  :       '-'PrimExpr
                                | '!'PrimExpr
                                | PrimExpr
                                ;
LValueExpr              :       IDENTIFICADOR '[' Expr ']'
                                | IDENTIFICADOR
                                ;
PrimExpr                :       IDENTIFICADOR '(' ListExpr ')'
                                | IDENTIFICADOR '('')'
                                | IDENTIFICADOR '[' Expr ']'
                                | IDENTIFICADOR
                                | CONST_STRING
                                | INTCONST
                                | '(' Expr ')'
                                ;
ListExpr                :       AssignExpr
                                | ListExpr ','AssignExpr
                                ;

%% /* Secao Epilogo*/	

void yyerror( char const *s) {
    if(erroOrigem==0) /*Erro lexico*/
    {
        printf("%s na linha %d - token: %s\n", s, numLinha, yytext);
    }
    else
    {
        printf("Erro sintatico proximo a %s ", yytext);
	printf(" - linha: %d \n", numLinha); 
	erroOrigem=1;
    }
    exit(1);
}


int main(int argc, char** argv){
   if(argc!=2)
        yyerror("Uso correto: ./simpleLang nome_arq_entrada");
   yyin=fopen(argv[1], "r");
   if(!yyin)
        yyerror("arquivo não pode ser aberto\n");
   return yyparse();
}
