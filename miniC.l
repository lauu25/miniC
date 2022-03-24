/* Código literal y macros de ER */

%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "miniC.tab.h"  
    #define ERROR_NUM 1
    #define ERROR_IDEN 2
    #define ERROR_COMENT 3
    #define ERROR_PANIC 4
    #define ERROR_NOCLOSE 5
    #define MAX_IDEN 16
    #define MAX_ENT 2147483648  
    void error_lexico(int error);  
    int comprueba_entero();
    int comprueba_identificador();
    int num_errores = 0;
    int linea_coment_open = 0;
%}

digito [0-9]
letra [a-zA-Z_]
panico [^ \n\r\ta-zA-Z_0-9+\-*/();=,{}"]

%option yylineno

%x comentario

%%

 /* Expresiones regulares de comentarios y blanco */

[ \t\r\n]+          
"//".*     
"/*"                            { BEGIN(comentario);
                                  linea_coment_open = yylineno; }  /* Reconoce la parte de comienzo del comentario */
<comentario>"*/"                { BEGIN(INITIAL); }
<comentario>(.|\n)              { }    /* Ignorar los caracteres intermedios */
<comentario><<EOF>>             { error_lexico(ERROR_COMENT);
                                    return 0;}

 /* Expresiones regulares de tokens*/
 /* ORDEN DE FLEX: 1) La más larga, 2) La que viene antes */

"print"                         { return PRINT; }
"void"                          { return VOID; }
"var"                           { return VAR; }
"const"                         { return CONST; }
"if"                            { return IF; }
"else"                          { return ELSE; }
"while"                         { return WHILE; }
"read"                          { return READ; }
{letra}({letra}|{digito})*      { if (comprueba_identificador()) return IDEN;
                                    else error_lexico(ERROR_IDEN);}
"+"                             { return MAS; }
"-"                             { return MENOS; }
"*"                             { return POR; }
"/"                             { return DIV; } 
"("                             { return PARI; }
")"                             { return PARD; }
";"                             { return PYC; }
"="                             { return IGUAL; }
","                             { return COMA; }
"{"                             { return LLAVEI; } 
"}"                             { return LLAVED; } 
{digito}+                       { if (comprueba_entero()) return ENTERO;
                                  else error_lexico(ERROR_NUM); } 
\"([^"\n]|\\\")*\"              { return STRING;}             /* // para / y /" para " ==> ///" = /" */
\"([^"\n]|\\\")*                { error_lexico(ERROR_NOCLOSE); }
{panico}+                       { error_lexico(ERROR_PANIC); }

%%

void error_lexico(int error) {
    if (error==ERROR_NUM)
        printf("ERROR: entero demasiado grande en linea %d: %s\n", yylineno, yytext);
    else if (error==ERROR_IDEN)
        printf("ERROR: identificador demasiado largo en linea %d: %s\n", yylineno, yytext);
    else if (error==ERROR_COMENT){
        printf("ERROR: comentario sin cerrar en linea %d: %s\n", linea_coment_open, yytext);      
    }
    else if (error==ERROR_PANIC)
        printf("ERROR: caracteres no validos en linea %d: %s\n", yylineno, yytext);
    else if (error==ERROR_NOCLOSE)
        printf("ERROR: cadena sin cerrar en linea %d: %s\n", yylineno, yytext);
    num_errores++;
}

int comprueba_entero(){
    long l = atol(yytext);
    if (l<MAX_ENT)
        return 1;
    return 0;
}

int comprueba_identificador(){
    int l = strlen(yytext);
    /* printf("Identificador: %s, Longitud: %d\n",yytext,l);*/
    if (l<=MAX_IDEN)
        return 1;
    return 0;
}
