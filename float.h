
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
float __fastcall__ _ctof(char v);
float __fastcall__ _utof(unsigned char v);
float __fastcall__ _itof(int v);
float __fastcall__ _stof(unsigned short v);

int __fastcall__ _ftoi(float f);

/* arithmetic functions */
float __fastcall__ _fdiv(float f, float a);
float __fastcall__ _fmul(float f, float a);
float __fastcall__ _fadd(float f, float a);
float __fastcall__ _fsub(float f, float a);
float __fastcall__ _fpow(float f, float a);

float __fastcall__ _fneg(float f);

/* string convertion routines */
void __fastcall__ _ftostr(char *d, float s); /* for vsprintf */
float __fastcall__ _strtof(char *d);

/* logical functions */
float __fastcall__ _fand(float f, float a);
float __fastcall__ _for(float f, float a);
float __fastcall__ _fnot(float f);

unsigned char __fastcall__ _fcmp(float f, float a);

unsigned char __fastcall__ _ftestsgn(float f); /* fixme */

#define ctof(_s) _ctof((_s))
#define itof(_s) _itof((_s))
#define ftoi(_s) _ftoi((_s))

#define atof(_s) _strtof((_s))
#define ftoa(_s, _f) _ftostr((_s), (_f))

#define fdiv(_f, _a) _fdiv((_f), (_a))
#define fmul(_f, _a) _fmul((_f), (_a))
#define fadd(_f, _a) _fadd((_f), (_a))
#define fsub(_f, _a) _fsub((_f), (_a))
#define fpow(_f, _a) _fpow((_f), (_a))

#define fcmp(_d, _s) _fcmp((_d), (_s))


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
