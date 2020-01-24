##############################################################################################
# cc65 floating point lib
##############################################################################################

all: runtime.lib floattest.prg

runtime.lib: float.s floatc.c float.inc
	ca65 float.s -o float.o
	cc65 floatc.c -o floatc.s
	ca65 floatc.s -o floatc.o
	ar65 a runtime.lib float.o floatc.o

floattest.prg: runtime.lib math.h float.h floattest.c
#	cl65 -Osir floattest.c runtime.lib -o floattest.prg
	cl65 floattest.c runtime.lib -o floattest.prg
#	cc65 floattest.c -o floattest.s

clean:
	$(RM) floattest.s
	$(RM) *~
	$(RM) *.prg *.o *.map *.lbl *.log *.lst *.d64

