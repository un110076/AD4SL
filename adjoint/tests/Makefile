all : test01.py test02.py test03.py
	ln -sf ../tbr.cpython-38-x86_64-linux-gnu.so tbr.cpython-38-x86_64-linux-gnu.so
	ln -sf ../intrinsic.cpython-38-x86_64-linux-gnu.so intrinsic.cpython-38-x86_64-linux-gnu.so
	python3 test_all.py

%.py : %.ppy
	../parser.exe $< > $@

clean:
	rm -fr __pycache__ *.so test??.py
