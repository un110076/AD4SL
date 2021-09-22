all: tbr.cpython-38-x86_64-linux-gnu.so intrinsic.cpython-38-x86_64-linux-gnu.so parser.exe
	cd tests && $(MAKE)
	cd casestudies && $(MAKE)

tbr.cpython-38-x86_64-linux-gnu.so : tbr.cpp
	g++ -O3 -Wall -shared -std=c++17 -fPIC -I/usr/include/python3.8 $< -o $@

intrinsic.cpython-38-x86_64-linux-gnu.so : intrinsic.cpp
	g++ -O3 -Wall -shared -std=c++17 -fPIC -I/usr/include/python3.8 $< -o $@

parser.exe : parser.tab.c lex.yy.c
	g++ -Wno-write-strings lex.yy.c parser.tab.c -lfl -o $@ -DNDEBUG

parser.tab.c : parser.y
	bison -g -v --defines=parser.tab.h -o $@ $<

lex.yy.c : scanner.l
	flex $<

clean:
	cd tests && $(MAKE) clean
	cd casestudies && $(MAKE) clean
	rm -fr parser.tab.c lex.yy.c parser.tab.h parser.exe parser.dot parser.output *.so
