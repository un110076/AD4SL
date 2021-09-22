all : speelpenning.py 
	ln -sf ../../tbr.cpython-38-x86_64-linux-gnu.so tbr.cpython-38-x86_64-linux-gnu.so
	ln -sf ../../intrinsic.cpython-38-x86_64-linux-gnu.so intrinsic.cpython-38-x86_64-linux-gnu.so
	python3 speelpenning_main.py

%.py : %.ppy
	../../parser.exe $< > $@

clean:
	rm -fr __pycache__ *.so speelpenning.py 
