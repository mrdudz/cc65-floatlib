
#include <conio.h>
#include <time.h>
#include <stdlib.h>
#include <stdio.h>

#include "float.h"
#include "math.h"

#define time() clock()

unsigned char strbuf[0x20];

float fd,fs;
float a,b,c1;
int c,i,t;
int n;

void csetpoint8(unsigned char x)
{
	while(x--)
	{
		printf(" ");
	}	
	printf("*\n");
}

#define YNUM	32
#define YNUM2	16

#define XNUM	32
#define XNUM2	16

void calcsin(void)
{
      for(i=0;i<YNUM;i++)
      {
        csetpoint8(XNUM2+(ftoi(fmul(fsin(deg2rad(itof(i),itof(YNUM))),itof(YNUM2)))/(YNUM/XNUM)));
      }
}
void calccos(void){
      for(i=0;i<YNUM;i++)
      {
        fs=deg2rad(itof(i),itof(YNUM));
        fd=fmul(fcos(fs),itof(YNUM2));
        csetpoint8(XNUM2+(ftoi(fd)/(YNUM/XNUM)));
      }
}

#if 0
void calcpoly1(void){

    p=malloc(sizeof(fpoly)+((1+3)*sizeof(float)));
    p.exponent=3;

//    _strtof(&(p->coffs[3]),"0.25");
//    _strtof(&(p->coffs[2]),"1");
//    _strtof(&(p->coffs[1]),"-0.5");
//    _strtof(&(p->coffs[0]),"0.25");

//    _ftostr(&strbuf,&(p->coffs[3])); printf("a0:%s\n",strbuf);
//    _ftostr(&strbuf,&(p->coffs[2])); printf("a1:%s\n",strbuf);
//    _ftostr(&strbuf,&(p->coffs[1])); printf("a2:%s\n",strbuf);
//    _ftostr(&strbuf,&(p->coffs[0])); printf("a3:%s\n",strbuf);

//    _fpoly1(&fd,&p,&_f_pi);
//    _ftostr(&strbuf,&fd); printf("x:%s\n",strbuf);

      for(i=0;i<256;i++){
        fs=_itof(i);
        _ftostr(&strbuf,fs); printf("%s:",strbuf);
        fd=_fpoly1(&p,&fs);
        _ftostr(&strbuf,fd); printf("%s\n",strbuf);
//        c=_ftoi(&fd);
//        csetpoint8(i/(256/35),12+(c/(256/23)));
      }

    free(p);
}
#endif

unsigned short var_bs;
unsigned short var_fs;
float var_i;
unsigned char var_w;
unsigned char var_j;
float var_k;
unsigned short var_co;


void f1(void)
{
	printf("i:%08lx\n",_ctof(0));

#if 0
	printf("exp mantissa sign\n");
	printf("%02x  ",*(unsigned char*)(1024+(40*2)+0));
	printf("%02x  ",*(unsigned char*)(1024+(40*2)+1));
	printf("%02x  ",*(unsigned char*)(1024+(40*2)+2));
	printf("%02x  ",*(unsigned char*)(1024+(40*2)+3));
	printf("%02x  ",*(unsigned char*)(1024+(40*2)+4));
	printf("%02x  ",*(unsigned char*)(1024+(40*2)+5));
#endif

	
        var_bs=1024;
        var_fs=55304;
	
//        var_i=_itof(var_bs);while(1)
        var_i=itof(2);while(1)
        {
	printf("i:%d\n",ftoi(var_i));
	var_bs++;if(var_bs==1030)break;

#if 0
        if(FCMPGT(0x00028000,U16TOF(0)))
        {
        	if (FCMPGTEQ(var_i,(U16TOF(var_bs+1000)))) break;
        }
        else if(FCMPLT(0x00028000,U16TOF(0)))
        {
        	if (FCMPLTEQ(var_i,(U16TOF(var_bs+1000)))) break;
        }
#endif
//        var_i=_fadd(var_i,0x00028000);
        var_i=fadd(var_i,0x00818000);
//        var_i=_fadd(var_i,_ctof(1));
	};
}

int main(void)
{
	printf("\x93 Floattest\n");

	f1();

	b=ctof(2);
	a=ctof(2);
	c1=fpow(a,b);
	printf("a:%x\n",a);
	printf("b:%x\n",b);
	printf("a:%d\n",ftoi(a));
	printf("c1:%d\n",ftoi(c1));

	printf("cmp: %d\n",fcmp(a,b));
	
	printf("a+b:%08lx\n",c1);

	n=ftoi(a);
	printf("n:%d\n",n);
	n=ftoi(b);
	printf("n:%d\n",n);
	n=ftoi(c1);
	printf("n:%d\n",n);

#if 0
      calcpoly1();
#endif
      
#if 0
    calcsin();

    t=1234;
    
    fd=itof((int)t); fs=itof((int)60); fd=fdiv(fd,fs);
    _ftostr(strbuf,fd);    printf("t:%s\n",strbuf);

    calccos();

    t=5678;
    
    fd=itof((int)t); fs=itof((int)60); fd=fdiv(fd,fs);
    _ftostr(strbuf,fd);    printf("t:%s\n",strbuf);
#endif
}