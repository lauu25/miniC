miniC: main.c lex.yy.c miniC.tab.c 
	gcc lex.yy.c main.c miniC.tab.c -lfl -o miniC

lex.yy.c: miniC.l 
	flex miniC.l

miniC.tab.c miniC.tab.h: miniC.y
	bison -d miniC.y

clean: 
	rm -f miniC.tab.* lex.yy.c miniC

run: miniC prueba.txt
	./miniC prueba.txt