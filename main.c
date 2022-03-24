#include <stdio.h>
#include <stdlib.h>
extern FILE *yyin;
extern int yyparse();

int main(int argc, char *argv[]){
    if (argc != 2){
        printf("Uso : %s prueba.txt\n", argv[0]);
        exit(1);
    }
    yyin = fopen(argv[1], "r");
    if (yyin == NULL){
        printf("Error al abrir %s\n", argv[1]);
        exit(2);
    }

    int token;
    // Analizar sintácticamente
    yyparse();
}