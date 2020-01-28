
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
    
    n = ftol(x);
    d = ltof(n);

    if (fcmpeq(d, x) || fcmplt(itof(0), x)) {
        return d;
    }
    return fsub(d, 1);
} 

// convert float into a string. this is surprisingly complex, so we just use
// the kernal function, and then fix up the result

char *ftoa(char *buf, float n) 
{ 
    char i, ii, epos = 0, ex;
    char tempbuf[0x20];
    _ftostr(tempbuf, n);
    
    // find position of the 'e'
    i=0;while(tempbuf[i]) {
        if (tempbuf[i] == 69) { /* 'e' */
            epos = i;
            break;
        }
        i++;
    }
    
    if (epos == 0) {
        i = ii = 0;
        // no exponent, we can return the number as is
        if (tempbuf[i] == '-') {
            buf[ii] = tempbuf[i];
            i++;ii++;
        } 
//         else {
//             buf[ii] = ' ';
//             ii++;
//         }

        // skip space
        if (tempbuf[i] == ' ') {
            i++;
        }

        if (tempbuf[i] == '.') {
            i++;
            buf[ii] = '0'; ii++;
            buf[ii] = '.'; ii++;
        }
        while (tempbuf[i]) {
            buf[ii] = tempbuf[i];
            i++;ii++;
        }
        buf[ii] = 0;
    } else {
        // we have an exponent, get rid of it
        
        i = ii = 0;
        if (tempbuf[i] == '-') {
            buf[ii] = tempbuf[i];
            i++;ii++;
        } 
//         else {
//             buf[ii] = ' ';
//             ii++;
//         }
        // skip space
        if (tempbuf[i] == ' ') {
            i++;
        }
        
        ex = ((tempbuf[epos+2] - '0') * 10) + (tempbuf[epos+3] - '0');

        if (tempbuf[epos+1] == '+') {
            // positive exponent, move decimal point to right, add zeros to the right
            
            // first copy until we see either the decimal point, or the 'e'
            while (tempbuf[i] && tempbuf[i] != '.' && tempbuf[i] != 69) {
                buf[ii] = tempbuf[i];
                i++;ii++;
            }
            
            // 'e' found, add as many zeros as in the exponent
            if (tempbuf[i] == 69) {
                while(ex) {
                    buf[ii] = '0';
                    ii++;
                    ex--;
                }
            }

            if (tempbuf[i] == '.') {
                i++; // skip '.'
                // copy digits until 'e'
                while(ex && tempbuf[i] != 69) {
                    buf[ii] = tempbuf[i];
                    ii++;i++;
                    ex--;
                }
                // add zeros
                while(ex) {
                    buf[ii] = '0';
                    ii++;
                    ex--;
                }
            }
            
        } else {
            // negative exponent, move decimal point to left, add zeros to left
            
            buf[ii] = '0'; ii++;
            buf[ii] = '.'; ii++;

            ex--;
            
            // add zeros
            while(ex) {
                buf[ii] = '0';
                ii++;
                ex--;
            }

            while (tempbuf[i] && tempbuf[i] != 69) {
                if (tempbuf[i] == '.') {
                    i++;
                }
                buf[ii] = tempbuf[i];
                i++;ii++;
            }
            
        }
        buf[ii] = 0;
    }
    
    return buf; 
}
