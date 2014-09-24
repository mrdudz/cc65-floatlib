##############################################################################################
# cc65 floating point lib
##############################################################################################

all:
	ca65 float.s -o float.o
	ar65 a runtime.lib float.o

test:
	cl65 -Osir floattest.c runtime.lib -o floattest.prg
#	cc65 floattest.c -o floattest.s

clean:
	$(RM) floattest.s
	$(RM) *~
	$(RM) *.prg *.o *.map *.lbl *.log *.lst *.d64

