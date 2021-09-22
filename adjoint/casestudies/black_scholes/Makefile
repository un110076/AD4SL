all : external.cpython-38-x86_64-linux-gnu.so black_scholes.py 
	ln -sf ../../tbr.cpython-38-x86_64-linux-gnu.so tbr.cpython-38-x86_64-linux-gnu.so
	ln -sf ../../intrinsic.cpython-38-x86_64-linux-gnu.so intrinsic.cpython-38-x86_64-linux-gnu.so
	python3 black_scholes_main.py

%.py : %.ppy
	../../parser.exe $< > $@

external.cpython-38-x86_64-linux-gnu.so : external.cpp
	g++ -O3 -Wall -shared -std=c++17 -fPIC -I/usr/include/python3.8 $< -o $@

clean:
	rm -fr __pycache__ *.so black_scholes.py 
