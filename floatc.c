
#include "float.h"
#include "math.h"

#if 0
double my_floor_2(double num) {
    if (num >= LLONG_MAX || num <= LLONG_MIN || num != num) {
        /* handle large values, infinities and nan */
        return num;
    }
    long long n = (long long)num;
    double d = (double)n;
    if (d == num || num >= 0)
        return d;
    else
        return d - 1;
}
#endif

/* FIXME: this is really too simple */
float ffloor(float x)
{
    signed long n;
    float d;
    
    n = ftoi(x);
    d = itof(n);

    if (fcmpeq(d, x) || fcmplt(itof(0), x)) {
        return d;
    }
    return fsub(d, 1);
} 
