all :
	cd adjoint && $(MAKE)

clean :
	cd adjoint && $(MAKE) clean

.PHONY: all clean
