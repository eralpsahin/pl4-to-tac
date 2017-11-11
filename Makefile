OS := $(shell uname)

build: scanner parser pl4
ifeq ($(OS), Darwin)
		gcc -o compiler lex.yy.c pl4.tab.c -ll
else
		gcc -o compiler lex.yy.c pl4.tab.c -lfl
endif
	rm lex.yy.c pl4.tab.c pl4.tab.h

file: build
	./pl4 input.pl4 output.tac

stout: build
	./compiler < input.pl4

scanner: pl4.flx
	flex pl4.flx

parser: pl4.y
	bison -d pl4.y

clean:
	rm lex.yy.c pl4.tab.c pl4.tab.h

pl4:
	gcc -o pl4 wrapper.c
purge:
	rm compiler pl4 lex.yy.c pl4.tab.c pl4.tab.h output.tac
