##############################################################################################
# cc65 floating point lib
##############################################################################################

all: runtime.lib floattest.prg

runtime.lib: float.s float.inc
	ca65 float.s -o float.o
	ar65 a runtime.lib float.o

floattest.prg: runtime.lib math.h float.h floattest.c
#	cl65 -Osir floattest.c runtime.lib -o floattest.prg
	cl65 floattest.c runtime.lib -o floattest.prg
#	cc65 floattest.c -o floattest.s

clean:
	$(RM) floattest.s
	$(RM) *~
	$(RM) *.prg *.o *.map *.lbl *.log *.lst *.d64

