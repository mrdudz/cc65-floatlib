
#ifndef _MATH_H_
#define _MATH_H_


#include "float.h"

/* math functions */

float _flog(float s);
float _fexp(float s);
float _fsqr(float s);

float _fsin(float s);
float _fcos(float s);
float _ftan(float s);
float _fatn(float s);

float _fsgn(float s);
float _fabs(float s);
float _fint(float s);

#define flog(_s) _flog((_s))
#define fexp(_s) _fexp((_s))
#define fsqr(_s) _fsqr((_s))

#define fsin(_s) _fsin((_s))
#define fcos(_s) _fcos((_s))
#define ftan(_s) _ftan((_s))
#define fatn(_s) _fatn((_s))

/* some float constants */
#define _f_2pi	0x0083c90f
#define _f_pi	0x0082c90f

#define M_PI	_f_pi

/* degrees to radiants */
#define deg2rad(_fs,_n) fmul(fdiv(_fs,_n),_f_2pi)
/* radiants to degrees deg=(rad/(2*pi))*256 */
#define rad2deg(_rad,_n)  fmul(fdiv(_rad,_f_2pi),_n)

#define fsqrt(_d,_s) fsqr((_s))
#define fatan(_d,_s) fatn((_s))

/* misc */
float _frnd(float s);
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


void _fatan2(float *a,float *x,float *y);
#define fatan2(_d,_x,_y) _fatan2(&(_d),&(_x),&(_y))


/*
   todo:

    acos,asin,ceil,cosh,floor,fmod,hypot,ldexp,log10,modf,poly,pow10,sinh
    tanh,cabs,_matherr,matherr,

 */

#endif

#endif /* _MATH_H_ */
