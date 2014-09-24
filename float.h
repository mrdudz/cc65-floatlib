
#ifndef _FLOAT_H_
#define _FLOAT_H_

/*

  format used in basic-variables

  we dont use this format, although it saves one byte per variable, since that
  removes the need of constantly converting between both formats. (someday
  we may use an entire different (not cbm-specific), more accurate, format anyway)

 */
typedef struct {
    unsigned char exponent;
    unsigned char mantissa[4];
} FLOATBAS;
/*

  format used in floating-point akku

  this format can be directly used with most basic routines

 */
typedef struct {
    unsigned char exponent;
    unsigned char mantissa[4];
    unsigned char sign;
} FLOATFAC;

#define float unsigned long 
/* we dont wanna seriously use double precision eh? ;=P */
#define double float

/* integer convertion routines */
float _ctof(char v);
float _utof(unsigned char v);
float _itof(int v);
float _stof(unsigned short v);

int _ftoi(float f);

/* arithmetic functions */
float _fdiv(float f,float a);
float _fmul(float f,float a);
float _fadd(float f,float a);
float _fsub(float f,float a);
float _fpow(float f,float a);

float _fneg(float f);

/* string convertion routines */
void _ftostr(char *d,float s); /* for vsprintf */
float _strtof(char *d);

/* logical functions */
float _fand(float f,float a);
float _for(float f,float a);
float _fnot(float f);

unsigned char _fcmp(float f,float a);

unsigned char _ftestsgn(float f); /* fixme */

#define ctof(_s) _ctof((_s))
#define atof(_s) _stof((_s))
#define itof(_s) _itof((_s))
#define ftoi(_s) _ftoi((_s))

#define fdiv(_f,_a) _fdiv((_f),(_a))
#define fmul(_f,_a) _fmul((_f),(_a))
#define fadd(_f,_a) _fadd((_f),(_a))
#define fsub(_f,_a) _fsub((_f),(_a))
#define fpow(_f,_a) _fpow((_f),(_a))

#define fcmp(_d,_s) _fcmp((_d),(_s))


/*
   todo:

    support for complex numbers

    ...stdlib...
    char *ecvt( double value, int ndigit, int *decpt, int *sign )
    char *fcvt( double value, int ndigit, int *decpt, int *sign )
    char *gcvt( double value, int ndigit, char *buf )

 */

/* resets fp-libs in Turbo-C and M$-C */
#define _fpreset()

#endif /* _FLOAT_H_ */
