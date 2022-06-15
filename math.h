
#ifndef _MATH_H_
#define _MATH_H_

#ifdef __CC65__

#include "float.h"

/* math functions */

float __fastcall__ _flog(float s);
float __fastcall__ _fexp(float s);
float __fastcall__ _fsqr(float s);

float __fastcall__ _fsin(float s);
float __fastcall__ _fcos(float s);
float __fastcall__ _ftan(float s);
float __fastcall__ _fatn(float s);

float __fastcall__ _fsgn(float s);
float __fastcall__ _fabs(float s);
float __fastcall__ _fint(float s);

#define flog(_s) _flog((_s))
#define fexp(_s) _fexp((_s))
#define fsqr(_s) _fsqr((_s))

#define fsin(_s) _fsin((_s))
#define fcos(_s) _fcos((_s))
#define ftan(_s) _ftan((_s))
#define fatn(_s) _fatn((_s))

/* some float constants */
#if BINARYFORMAT == BINARYFORMAT_CBM_UNPACKED
#define _f_2pi  0x0083c90f
#define _f_pi   0x0082c90f
#elif BINARYFORMAT == BINARYFORMAT_CBM_PACKED
#define _f_2pi  0x83490fda
#define _f_pi   0x82490fda
#elif BINARYFORMAT == BINARYFORMAT_IEEE754
#define _f_2pi  0x40c90fdb
#define _f_pi   0x40490fdb
#else
#error "BINARYFORMAT must be defined"
#endif

#define M_PI    _f_pi

/* degrees to radiants */
#define deg2rad(_fs, _n) fmul(fdiv(_fs, _n), _f_2pi)
/* radiants to degrees deg = (rad / (2 * pi)) * 256 */
#define rad2deg(_rad, _n)  fmul(fdiv(_rad, _f_2pi), _n)

#define fsqrt(_s) fsqr((_s))
#define fatan(_s) fatn((_s))

/* FIXME */
float __fastcall__ _fatan2(float x, float y);
#define fatan2(_x, _y) _fatan2((_x), (_y))

/* misc */
float __fastcall__ _frnd(float s);
#define frnd(_s) _frnd((_s))

#if 0

typedef struct {
    unsigned char exponent;
    FLOATBAS coffs[8];       /* ? */
} FLOATPOLY;

#define fpoly FLOATPOLY

/* polynom1 f(x)=a1+a2*x^2+a3*x^3+...+an*x^n */
void _fpoly1(float *d,fpoly *a,float *x);
/* polynom2 f(x)=a1+a2*x^3+a3*x^5+...+an*x^(2n-1) */
void _fpoly2(float *d,fpoly *a,float *x);

#endif

/*
   todo:

    acos,asin,ceil,cosh,fmod,hypot,ldexp,log10,modf,poly,pow10,sinh
    tanh,cabs,_matherr,matherr,

*/

float ffloor(float x);

#else /* __CC65__ */

/* some macros to allow testing of programs using the lib in 
   a different compiler */

#include <math.h>

#define flog(a)     (logf(a))
#define fexp(a)     (expf(a))
#define fsqr(a)     (sqrtf(a))

#define fsin(a)     (sinf(a))
#define fcos(a)     (cosf(a))
#define ftan(a)     (tanf(a))
#define fatn(a)     (atnf(a))

#define _f_2pi      ((float)(M_PI * 2.0f))

/* degrees to radiants */
#define deg2rad(_fs, _n) (((_fs) / (_n)) * _f_2pi)
/* radiants to degrees deg = (rad / (2 * pi)) * 256 */
#define rad2deg(_rad, _n) (((_rad) / _f_2pi) * (_n))

#define fsqrt(a)    (sqrtf(a))
#define ffloor(a)   (floorf(a))

#endif /* __CC65__ */

#endif /* _MATH_H_ */
