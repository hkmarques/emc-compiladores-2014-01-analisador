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

%token escreva leia ou retorne enquanto inteiro se senao execute entao programa novalinha carconst intconst car ID cadeiaCaracteres e/* Definicao de terminais (que não apenas caracteres), com o uso da diretiva
                              %token. Ha outras opcoes para definicao de tokens (especificando ordem de associacao e 
			      prescedencia de operadores -  ver secao 3.2 do manual do Bison*/

/* Pode haver mais de uma secao prologo e mais de uma secao de definicoes do Bison. 
   Estas secoes podem aparecer intercaladas entre si. Ver Secao 3.1.1 */

%%  /* Secao de regras - producoes da gramatica - Veja as normas de formação de produçoes na secao 3.3 do manual */

Programa 		:	DeclFuncVar
				| DeclProg
				;
DeclFuncVar             :       Tipo ID DeclVar ';' DeclFuncVar
                                | Tipo ID intconst DeclVar ';' DeclFuncVar
                                | Tipo ID DeclFunc DeclFuncVar
                                |
                                ;
DeclProg                :       programa Bloco
                                ;
DeclVar                 :       ',' ID DeclVar
                                | ',' ID intconst DeclVar
                                |
                                ;
DeclFunc                :       '(' ListaParametros ')' Bloco
                                ;
ListaParametros         :       
                                | ListaParametrosCont
                                ;
ListaParametrosCont     :       Tipo ID
                                | Tipo ID '['']'
                                | Tipo ID ',' ListaParametrosCont
                                | Tipo ID '['']' ',' ListaParametrosCont
                                ;
Bloco                   :       '{' ListaDeclVar ListaComando '}'
                                | '{' ListaDeclVar '}'
                                ;
ListaDeclVar            :       
                                | Tipo ID DeclVar ';' ListaDeclVar
                                | Tipo ID intconst DeclVar ';' ListaDeclVar
                                ;
Tipo                    :       inteiro
                                | car
                                ;
ListaComando            :       Comando
                                | Comando ListaComando
                                ;
Comando                 :       ';'
                                | Expr ';'
                                | retorne Expr ';'
                                | leia LValueExpr ';'
                                | escreva Expr ';'
                                | escreva '"'cadeiaCaracteres'"' ';'
                                | novalinha ';'
                                | se '(' Expr ')' entao Comando
                                | se '(' Expr ')' entao Comando senao Comando
                                | enquanto '(' Expr ')' execute Comando
                                | Bloco
                                ;
Expr                    :       AssignExpr
                                ;
AssignExpr              :       CondExpr
                                | LValueExpr '=' AssignExpr
                                ;
CondExpr                :       OrExpr
                                | OrExpr '?' Expr ':' CondExpr
                                ;
OrExpr                  :       OrExpr ou AndExpr
                                | AndExpr
                                ;
AndExpr                 :       AndExpr e EqExpr
                                | EqExpr
                                ;
EqExpr                  :       EqExpr '=''=' DesigExpr
                                | EqExpr '!''=' DesigExpr
                                | DesigExpr
                                ;
DesigExpr               :       DesigExpr '<' AddExpr
                                | DesigExpr '>' AddExpr
                                | DesigExpr '>''=' AddExpr
                                | DesigExpr '<''=' AddExpr
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
LValueExpr              :       ID '[' Expr ']'
                                | ID
                                ;
PrimExpr                :       ID '(' ListExpr ')'
                                | ID '('')'
                                | ID '[' Expr ']'
                                | ID
                                | carconst
                                | intconst
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
