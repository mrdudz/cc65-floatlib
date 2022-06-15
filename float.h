
#ifndef _FLOAT_H_
#define _FLOAT_H_

#ifdef __CC65__

#define BINARYFORMAT_CBM_UNPACKED  0
#define BINARYFORMAT_CBM_PACKED    1
#define BINARYFORMAT_IEEE754       2

// BEWARE: also change in float.s
#define BINARYFORMAT BINARYFORMAT_IEEE754

/*

  format used in basic-variables

  we dont use this format, although it saves one byte per variable, since that
  removes the need of constantly converting between both formats. (someday
  we may use an entire different (not cbm-specific), more accurate, format anyway)

              sign
    exponent / /mantissa
    33333333 3 3222222222111111111110000000000
    98765432 1 0987654321098765432109876543210

 * The exponent can be computed from bits 39-32 by subtracting 129 (!)
 */
typedef struct {
    unsigned char exponent;
    unsigned char mantissa[4];
} FLOATBAS;

/* CBM format used in floating-point akku
 *
 * this format can be directly used with most CBM BASIC routines
 *
 *  exponent mantissa                         sign
 *  44444444 33333333332222222222111111111100 00000000
 *  76543210 98765432109876543210987654321098 76543210
 *
 * truncated to 32bit:
 *
 *  exponent mantissa         sign
 *  33222222 2222111111111100 00000000
 *  10987654 3210987654321098 76543210
 *
 * The exponent can be computed from bits 47-40 by subtracting 129 (!) (130 = 2^1)
 * MSB of the Mantissa must always be 1, if it is 0 the value is 0
 * 
 * 1.0 = exp=129, mantissa=$80
 *
 */
typedef struct {
    unsigned char exponent;
    unsigned char mantissa[4];
    unsigned char sign;
} FLOATFAC;

/* ieee754 32bit format:
 * 
 *  sign
 * / /exponent/mantissa
 * 3 32222222 22211111111110000000000
 * 1 09876543 21098765432109876543210
 * 
 * The sign is stored in bit 31.
 * The exponent can be computed from bits 23-30 by subtracting 127. (128 = 2^1)
 * The mantissa is stored in bits 0-22.
 *   An invisible leading bit (i.e. it is not actually stored) with value 1.0
 *   is placed in front, then bit 23 has a value of 1/2, bit 22 has value 1/4 etc.
 *   As a result, the mantissa has a value between 1.0 and 2.
 *
 * 1.0 = exp=127, mantissa=0
 *
 * If the exponent reaches -127 (binary 00000000), the leading 1 is no longer
 * used to enable gradual underflow.
 *
 */
typedef struct {
    unsigned char exponent;     // msb is the sign
    unsigned char mantissa[3];  // msb is lsb of exponent
} FLOAT754;

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

/* string convertion routines, these use the exponential form */
char * __fastcall__ _ftostr(char *d, float s); /* for vsprintf */
float __fastcall__ _strtof(char *d);

/* logical functions */
float __fastcall__ _fand(float f, float a);
float __fastcall__ _for(float f, float a);
float __fastcall__ _fnot(float f);

/* compare two floats, returns 0 if f = a, 1 if f < a, 255 if f > a */
unsigned char __fastcall__ _fcmp(float f, float a);

unsigned char __fastcall__ _ftestsgn(float f); /* fixme */

#define ctof(_s) _ctof((_s))
#define itof(_s) _itof((_s))
#define ltof(_s) _itof((_s))    /* TODO */
#define ftoi(_s) _ftoi((_s))
#define ftol(_s) _ftoi((_s))    /* TODO */

#define atof(_s)        _strtof((_s))
char *ftoa(char *buf, float n);

#define fneg(_s)        _fneg((_s))

#define fdiv(_f, _a) _fdiv((_f), (_a))
#define fmul(_f, _a) _fmul((_f), (_a))
#define fadd(_f, _a) _fadd((_f), (_a))
#define fsub(_f, _a) _fsub((_f), (_a))
#define fpow(_f, _a) _fpow((_f), (_a))

#define fcmp(_d, _s)    _fcmp((_d), (_s))
#define fcmplt(_d, _s)  (_fcmp((_d), (_s)) == 1)
#define fcmpgt(_d, _s)  (_fcmp((_d), (_s)) == 255)
#define fcmpeq(_d, _s)  (_fcmp((_d), (_s)) == 0)


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

#else /* __CC65__ */

/* some macros to allow testing of programs using the lib in 
   a different compiler (with float support) */

#include <math.h>

#define fdiv(a,b)   ((a)/(b))
#define fmul(a,b)   ((a)*(b))
#define fadd(a,b)   ((a)+(b))
#define fsub(a,b)   ((a)-(b))
#define fpow(a,b)   powf((a),(b))

#define fcmpgt(a,b) ((a)>(b))
#define fcmplt(a,b) ((a)<(b))
#define fcmpeq(a,b) ((a)==(b))

int fcmp(float a, float b)
{
    if (a > b) return 255;
    if (a < b) return 1;
    return 0;
}

#define _fand(a,b)  ((unsigned)(a) & (unsigned)(b))
#define _for(a,b)   ((unsigned)(a) | (unsigned)(b))

#define _fneg(a)    (-(float)(a))
#define fneg(a)     (-(float)(a))

#define _ctof(a)    ((float)(a))
#define _utof(a)    ((float)(a))
#define _stof(a)    ((float)(a))

#define ctof(a)     ((float)(a))
#define itof(a)     ((float)(a))
#define ftoi(a)     ((int)(a))

char* _ftostr(char *b, float a)
{
    sprintf(b, "%f", a);
    return b;
}

#define ftoa(a, b)  _ftostr((a), (b))

#endif /* __CC65__ */

#endif /* _FLOAT_H_ */
