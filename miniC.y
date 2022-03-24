%{
    #include <stdio.h>
    #include <stdlib.h>
    extern int yylex();
    extern int yylineno;    
    void yyerror(const char *msg);
    void inicializar_registros();  
    int errores_sintacticos = 0;
%}

/* Tipos de datos de los símbolos de la gramática */
%union{
    int entero;
    char *cadena;
}

/* Tokens de la gramática */
%token MAS "+"
%token MENOS "-"
%token POR "*"
%token DIV "/"
%token PARI "("
%token PARD ")"
%token <entero> ENTERO "number"
%token PYC ";"
%token <cadena> IDEN "id"
%token IGUAL "="
%token COMA ","
%token LLAVEI "{"
%token LLAVED "}"
%token <cadena> STRING 
%token PRINT "print"
%token VOID "void"
%token VAR "var"
%token CONST "const"
%token IF "if"
%token ELSE "else"
%token WHILE "while"
%token READ "read"

/* Asociatividad y precedencia de operadores (conforme bajas mayor precedencia) */
%left "+" "-"
%left "*" "/"
%precedence UMINUS


%start program
%define parse.error verbose
%expect 1

%%

/* Reglas de producción */

program         : VOID IDEN "(" ")" "{" declarations statement_list "}" { printf("P -> void id () { D ST }\n"); }
                ;

declarations    : declarations VAR identifier_list ";"                  { printf("D -> D VAR IL\n"); }
                | declarations CONST identifier_list ";"                { printf("D -> D CONST IL\n"); }
                | %empty                                                { printf("D -> lambda\n"); }
                ;
identifier_list : asig                                                  { printf("IL -> A\n"); }
                | identifier_list "," asig                              { printf("IL -> IL , A\n"); }
                ;
asig            : IDEN                                                 { printf("A -> id\n"); }
                | IDEN "=" expression                                   { printf("A -> id = E\n"); }
                ;
statement_list  : statement_list statement                              { printf("SL -> SL S\n"); }
                | %empty                                                { printf("SL -> lambda\n"); }
                ;
statement       : IDEN "=" expression ";"                               { printf("S -> id = E;\n"); }
                | "{" statement_list "}"                                { printf("S -> {SL}\n"); }
                | IF "(" expression ")" statement ELSE statement        { printf("S -> IF (E) S ELSE S = E\n"); }
                | IF "(" expression ")" statement                       { printf("S -> IF (E) S\n"); }
                | WHILE "(" expression ")" statement                    { printf("S -> WHILE (E) S\n"); }
                | PRINT print_list ";"                                  { printf("S-> PRINT PI ;\n"); }  
                | READ read_list ";"                                    { printf("S-> READ RL ;\n"); }  
                ;
print_list      : print_item                                            { printf("PL-> PI\n"); }  
                | print_list "," print_item                             { printf("PL-> PL , PI\n"); }  
                ;
print_item      : expression                                            { printf("PI-> E\n"); }  
                | STRING                                                { printf("PI-> STRING\n"); }
                ;
read_list       : IDEN                                                  { printf("RL-> id\n"); }
                | read_list "," IDEN                                      { printf("RL-> RL , id \n"); }
                ;
expression      : expression "+" expression                             { printf("EX-> EX + EX\n"); }
                | expression "-" expression                             { printf("EX-> EX - EX\n"); }
                | expression "*" expression                             { printf("EX-> EX * EX\n"); }
                | expression "/" expression                             { printf("EX-> EX / EX\n"); }
                | "-" expression %prec UMINUS                           { printf("EX-> - EX\n"); }
                | "(" expression ")"                                    { printf("EX-> ( EX )\n"); }
                | IDEN                                                  { printf("EX-> id\n"); }
                | ENTERO                                                   { printf("EX-> num\n"); }
                ;

%%

void yyerror(const char *msg){
    printf("Error en linea %d: %s\n", yylineno, msg);
}