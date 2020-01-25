        .segment "LOWCODE"

;---------------------------------------------------------------------------------------------

__basicon:
        sei
        ldx #$37
        stx $01
        rts
__basicoff:
        ldx #$36
        stx $01
        cli
        rts

;---------------------------------------------------------------------------------------------
; first come the actual stubs to floating point routines, these are ment to be
; used from further written ml-math routines aswell. (maybe also from the compiler?!)
;---------------------------------------------------------------------------------------------

        .include  "float.inc"
        
        .importzp sreg, ptr1

;---------------------------------------------------------------------------------------------
; converter integer types to float
;---------------------------------------------------------------------------------------------

___float_s8_to_fac:
        ;a: low
__float_s8_to_fac:
        jsr __basicon
        jsr BASIC_s8_to_FAC
        jmp __basicoff

___float_u8_to_fac:
        ;a: low
        tay
        ;y: low
__float_u8_to_fac:
        jsr __basicon
        jsr BASIC_u8_to_FAC
        jmp __basicoff
        
; get C-parameter (signed int), convert to FAC
___float_s16_to_fac:
        ;a: low x: high
        tay
        txa
        ;y: low a: high
        
; convert signed int (YA) to FAC
__float_s16_to_fac:
        jsr __basicon           ; enable BASIC (trashes X)
        jsr BASIC_s16_to_FAC
        jmp __basicoff
       
; get C-parameter (unsigned short), convert to FAC          
___float_u16_to_fac:
        ;a: low x: high
        tay
        txa
        ;y: low a: high
        
__float_u16_to_fac:
        sta FAC_MANTISSA0
        sty FAC_MANTISSA1
        jsr __basicon
        ldx #$90
        sec
        jsr BASIC_u16_to_FAC
        jmp __basicoff

; return to C, FAC as unsigned int
__float_fac_to_u16:
        jsr __basicon
        jsr BASIC_FAC_to_u16
        jsr __basicoff
        ldx FAC_MANTISSA2
        lda FAC_MANTISSA3
        rts
        
;---------------------------------------------------------------------------------------------
; converter float to string and back
;---------------------------------------------------------------------------------------------

__float_fac_to_str:
        jsr __basicon
        jsr BASIC_FAC_to_string
        jmp __basicoff

___float_str_to_fac:
;        jsr popax
__float_str_to_fac:
        sta $22
        stx $23
        ldy #$00
@l:     lda ($22),y
        beq @s
        iny
        bne @l
@s:     tya
        jsr __basicon
        jsr BASIC_string_to_FAC
        jmp __basicoff

;---------------------------------------------------------------------------------------------

; get C-parameter (float), convert to FAC        
___float_float_to_fac:
        sta FAC_MANTISSA1
        stx FAC_MANTISSA0
        ldy sreg
        sty FAC_EXPONENT
        ldy sreg+1
        sty FAC_SIGN

        ldx #$00
        stx FAC_MANTISSA2
        stx FAC_MANTISSA3

        stx FAC_ROUNDING
        rts
        
; load BASIC float into FAC        
; in: pointer (a/x) to BASIC float (not packed)        
__float_float_to_fac:   ; only used in ATAN2?
        sta ptr1
        stx ptr1+1
        ldy #$00
        lda (ptr1),y
        sta FAC_EXPONENT
        iny
        lda (ptr1),y
        sta FAC_MANTISSA0
        iny
        lda (ptr1),y
        sta FAC_MANTISSA1
        iny
        lda (ptr1),y
        sta FAC_MANTISSA2
        iny
        lda (ptr1),y
        sta FAC_MANTISSA3
        iny
        lda (ptr1),y
        sta FAC_SIGN
        ldx #$00
        stx FAC_ROUNDING
        ; always load arg after fac so these can
        ; be removed in funcs that only take fac
        eor ARG_SIGN
        sta FAC_SIGN_COMPARE
        rts

; get C-parameter (two floats), to FAC and ARG
___float_float_to_fac_arg:
        jsr ___float_float_to_fac
___float_float_to_arg:
        ldy #$03
        jsr ldeaxysp
        sta ARG_MANTISSA1
        stx ARG_MANTISSA0
        ldy sreg
        sty ARG_EXPONENT

        ldx #$00
        stx ARG_MANTISSA2
        stx ARG_MANTISSA3

        lda sreg+1

        sta ARG_SIGN
        eor FAC_SIGN
        sta FAC_SIGN_COMPARE ; sign compare

        jmp incsp4

; load BASIC float into ARG
; in: pointer (a/x) to BASIC float (not packed)        
__float_float_to_arg:   ; only used in ATAN2?
        sta ptr1
        stx ptr1+1
        ldy #$00
        lda (ptr1),y
        sta ARG_EXPONENT
        iny
        lda (ptr1),y
        sta ARG_MANTISSA0
        iny
        lda (ptr1),y
        sta ARG_MANTISSA1
        iny
        lda (ptr1),y
        sta ARG_MANTISSA2
        iny
        lda (ptr1),y
        sta ARG_MANTISSA3
        iny
        lda (ptr1),y
        sta ARG_SIGN
        ; sign compare
        eor FAC_SIGN
        sta FAC_SIGN_COMPARE
        rts
        
; return to C, float as unsigned long
___float_fac_to_float:

        ; return as LONG
        lda FAC_SIGN
        sta sreg+1

        lda FAC_EXPONENT
        sta sreg
        ldx FAC_MANTISSA0
        lda FAC_MANTISSA1
        rts        

;; store float in memory        
;; in: dest. pointer (a/x), float in FAC
;__float_fac_to_float:   ; UNUSED
;        sta ptr1
;        stx ptr1+1
;        ldy #$00
;        lda FAC_EXPONENT
;        sta (ptr1),y
;        iny
;        lda FAC_MANTISSA0
;        sta (ptr1),y
;        iny
;        lda FAC_MANTISSA1
;        sta (ptr1),y
;        iny
;        lda FAC_MANTISSA2
;        sta (ptr1),y
;        iny
;        lda FAC_MANTISSA3
;        sta (ptr1),y
;        iny
;        lda FAC_SIGN
;        sta (ptr1),y
;        rts

;; store packed float in memory        
;; in: dest. pointer (a/x), float in FAC        
;__float_fac_to_float_packed:    ; UNUSED
;        sta ptr1
;        stx ptr1+1
;        ldy #4
;        lda FAC_MANTISSA3
;        sta (ptr1),y
;        dey
;        lda FAC_MANTISSA2
;        sta (ptr1),y
;        dey
;        lda FAC_MANTISSA1
;        sta (ptr1),y
;        dey
;; use the MSB of the mantissa for the sign
;        lda FAC_SIGN
;        ora #$7f
;        and FAC_MANTISSA0
;        sta (ptr1),y
;        dey
;        lda FAC_EXPONENT
;        sta (ptr1),y
;        rts
        
;; store packed float in memory        
;; in: dest. pointer (a/x), float in ARG
__float_arg_to_float_packed:
        sta ptr1
        stx ptr1+1
        ldy #4
        lda ARG_MANTISSA3
        sta (ptr1),y
        dey
        lda ARG_MANTISSA2
        sta (ptr1),y
        dey
        lda ARG_MANTISSA1
        sta (ptr1),y
        dey
; use the MSB of the mantissa for the sign
        lda ARG_SIGN
        ora #$7f
        and ARG_MANTISSA0
        sta (ptr1),y
        dey
        lda ARG_EXPONENT
        sta (ptr1),y
        rts
        
;---------------------------------------------------------------------------------------------

        .export __ftostr
        .importzp ptr1
        .import popax, ldeaxysp, incsp4

; convert float to string
; char* __fastcall__ _ftostr(char *d, float s);
;-> char* __fastcall__ _ftostr(char *d, unsigned long s);

__ftostr:
        jsr ___float_float_to_fac
        jsr __float_fac_to_str

___float_strbuf_to_string:
        jsr popax ; ptr to string
__float_strbuf_to_string:
        sta ptr1
        stx ptr1+1
        ldy #$00
@l:
        lda $0100,y
        sta (ptr1),y
        beq @s
        iny
        bne @l
@s:
        lda ptr1
        ldx ptr1+1
        rts

        .export __strtof
        
; convert a string to a float        
; float __fastcall__ _strtof(char *d);        
;-> unsigned long __fastcall__ _strtof(char *d);        
__strtof:
        jsr ___float_str_to_fac
        jmp ___float_fac_to_float

        .export __ctof

; convert char to float
; float __fastcall__ _ctof(char v);
;-> unsigned long __fastcall__ _ctof(char v);
 __ctof:
        jsr ___float_s8_to_fac
        jmp ___float_fac_to_float

        .export __utof
        
; convert unsigned char to float
; float __fastcall__ _utof(unsigned char v);
;-> unsigned long __fastcall__ _utof(unsigned char v);
 __utof:
        jsr ___float_u8_to_fac
        jmp ___float_fac_to_float

        .export __stof
        
; convert short to float
; float __fastcall__ _stof(unsigned short v);
;-> unsigned long __fastcall__ _stof(unsigned short v);
 __stof:
        jsr ___float_u16_to_fac
        jmp ___float_fac_to_float

        .export __itof

; convert integer to float
; float __fastcall__ _itof(int v);
;-> unsigned long __fastcall__ _itof(int v);
 __itof:
        ;a: low x: high
        jsr ___float_s16_to_fac
        jmp ___float_fac_to_float

        .export __ftoi
        
; convert float to integer
; int __fastcall__ _ftoi(float f);
;-> int __fastcall__ _ftoi(unsigned long f);
 __ftoi:
        jsr ___float_float_to_fac
        jmp __float_fac_to_u16

;---------------------------------------------------------------------------------------------
; these functions take one arg (in FAC) and return result (in FAC) aswell
;---------------------------------------------------------------------------------------------

.macro __ffunc1 addr
        jsr ___float_float_to_fac
        jsr __basicon
        jsr addr
        jsr __basicoff
        jmp ___float_fac_to_float
.endmacro

        .export __fabs, __fatn, __fcos, __fexp, __fint, __flog
        .export __frnd, __fsgn, __fsin, __fsqr, __ftan, __fnot, __fround

__fabs:    __ffunc1 BASIC_FAC_Abs
__fatn:    __ffunc1 BASIC_FAC_Atn
__fcos:    __ffunc1 BASIC_FAC_Cos
__fexp:    __ffunc1 BASIC_FAC_Exp
;__ffre:    __ffunc1 BASIC_FAC_Fre
__fint:    __ffunc1 BASIC_FAC_Int
__flog:    __ffunc1 BASIC_FAC_Log
;__fpos:    __ffunc1 BASIC_FAC_Pos
__frnd:    __ffunc1 BASIC_FAC_Rnd
__fsgn:    __ffunc1 BASIC_FAC_Sgn
__fsin:    __ffunc1 BASIC_FAC_Sin
__fsqr:    __ffunc1 BASIC_FAC_Sqr
__ftan:    __ffunc1 BASIC_FAC_Tan
__fnot:    __ffunc1 BASIC_FAC_Not
__fround:  __ffunc1 BASIC_FAC_Round
        
;---------------------------------------------------------------------------------------------
; these functions take two args (in FAC and ARG) and return result (in FAC)
;---------------------------------------------------------------------------------------------
        
__float_ret2:

        ;jsr __basicoff
        ldx #$36
        stx $01
        cli
        jmp ___float_fac_to_float    ; also pops pointer to float

.macro __ffunc2a addr
        jsr ___float_float_to_fac_arg
        jsr __basicon
        lda FAC_EXPONENT
        jsr addr
        jmp __float_ret2
.endmacro

.macro __ffunc2b addr
        jsr ___float_float_to_fac_arg
        jsr __basicon
        jsr addr
        jmp __float_ret2
.endmacro
        
        .export __fadd, __fsub, __fmul, __fdiv, __fpow

; float __fastcall__ _fadd(float f, float a);        
;-> unsigned long __fastcall__ _fadd(unsigned long f, unsigned long a);        
__fadd:   __ffunc2a BASIC_ARG_FAC_Add
__fsub:   __ffunc2a BASIC_ARG_FAC_Sub
__fmul:   __ffunc2a BASIC_ARG_FAC_Mul
__fdiv:   __ffunc2a BASIC_ARG_FAC_Div
__fpow:   __ffunc2a BASIC_ARG_FAC_Pow

        .export __fand, __for

__fand:   __ffunc2b BASIC_ARG_FAC_And
__for:    __ffunc2b BASIC_ARG_FAC_Or
        
__float_ret3:
        ;jsr __basicoff
        ldx #$36
        stx $01
        cli
        ldx #0
        rts  
        
        .bss
        
tempfloat:
        .res 5

        .SEGMENT "LOWCODE"
        
        .export __fcmp
        
__fcmp:
        jsr ___float_float_to_fac_arg
        lda #<tempfloat
        ldx #>tempfloat
        jsr __float_arg_to_float_packed
        lda #<tempfloat
        ldy #>tempfloat
___float_cmp_fac_arg:
        jsr __basicon
        ; in: FAC=(x1) a/y= ptr lo/hi to x2
        jsr BASIC_FAC_cmp
        ; a=0 (==) / a=1 (>) / a=255 (<)
        jmp __float_ret3

        .export __ftestsgn
        
__ftestsgn:
        jsr ___float_float_to_fac
;___float_testsgn_fac:
        jsr __basicon
        ; in: FAC(x1)
        jsr BASIC_FAC_testsgn
        jmp __float_ret3
        
___float_testsgn_fac:
        lda FAC_EXPONENT
        beq @s
        lda FAC_SIGN
        rol a
        lda #$ff
        bcs @s
        lda #$01
@s:
        rts

___float_testsgn_arg:
        lda ARG_EXPONENT
        beq @s
        lda ARG_SIGN
        rol a
        lda #$ff
        bcs @s
        lda #$01
@s:
        rts

;---------------------------------------------------------------------------------------------
; polynom1 f(x)=a1+a2*x^2+a3*x^3+...+an*x^n
;---------------------------------------------------------------------------------------------
        .export __fpoly1
__fpoly1:
        jsr ___float_float_to_fac
        ;jsr popya
        jsr popax
        tay
        txa
        jsr __basicon
        jsr BASIC_FAC_Poly1
        jmp __float_ret2

;---------------------------------------------------------------------------------------------
; polynom2 f(x)=a1+a2*x^3+a3*x^5+...+an*x^(2n-1)
;---------------------------------------------------------------------------------------------
        .export __fpoly2
__fpoly2:
        jsr ___float_float_to_fac
        ;jsr popya
        jsr popax
        tay
        txa
        jsr __basicon
        jsr BASIC_FAC_Poly1
        jmp __float_ret2
        
;---------------------------------------------------------------------------------------------
        
__float_atn_fac:
        jsr __basicon
        jsr BASIC_FAC_Atn
        jmp __basicoff
__float_div_fac_arg:
        jsr __basicon
        lda FAC_EXPONENT
        jsr BASIC_ARG_FAC_Div
        jmp __basicoff
__float_add_fac_arg:
        jsr __basicon
        lda FAC_EXPONENT
        jsr BASIC_ARG_FAC_Add
        jmp __basicoff
        
__float_swap_fac_arg:
        lda   FAC_EXPONENT
        ldx   ARG_EXPONENT
        stx   FAC_EXPONENT
        sta   ARG_EXPONENT
        lda   FAC_MANTISSA0
        ldx   ARG_MANTISSA0
        stx   FAC_MANTISSA0
        sta   ARG_MANTISSA0
        lda   FAC_MANTISSA1
        ldx   ARG_MANTISSA1
        stx   FAC_MANTISSA1
        sta   ARG_MANTISSA1
        lda   FAC_MANTISSA2
        ldx   ARG_MANTISSA2
        stx   FAC_MANTISSA2
        sta   ARG_MANTISSA2
        lda   FAC_MANTISSA3
        ldx   ARG_MANTISSA3
        stx   FAC_MANTISSA3
        sta   ARG_MANTISSA3
        lda   FAC_SIGN
        ldx   ARG_SIGN
        stx   FAC_SIGN
        sta   ARG_SIGN
        rts
        
        .export __fneg
__fneg:
        jsr ___float_float_to_fac

        lda FAC_EXPONENT       ; FAC Exponent
        beq @sk
        lda FAC_SIGN       ; FAC Sign
        eor #$FF
        sta FAC_SIGN       ; FAC Sign
@sk:
        jmp ___float_fac_to_float
        
        
__f_pi2:  .byte $81,$80+$49,$0f,$da,$a1,$00
__f_pi:   .byte $82,$80+$49,$0f,$da,$a1,$00
__f_1pi2: .byte $83,$80+$16,$cb,$e3,$f9,$00

        .export __fatan2

; float _fatan2(float x, float y)
;-> unsigned long _fatan2(unsigned long x, unsigned long y)
__fatan2:

        jsr ___float_float_to_fac_arg

        jsr ___float_testsgn_arg
        beq @s11   ; =0
        bpl @s12   ; <0
      ; arg>0
                ; a=atn(y/x)
                jsr __float_swap_fac_arg
                jsr __float_div_fac_arg
                jsr __float_atn_fac
                jmp __float_ret2
@s12: ; arg<0
                ; a=atn(y/x)+pi
                jsr __float_swap_fac_arg
                jsr __float_div_fac_arg
                jsr __float_atn_fac
                lda #<__f_pi
                ldx #>__f_pi
                jsr __float_float_to_arg
                jsr __float_add_fac_arg
                jmp __float_ret2

@s11: ; arg=0
                jsr ___float_testsgn_fac
                beq @s21   ; =0
                bpl @s22   ; <0
      ; fac >0
                        ; a= 0.5*pi
                        lda #<__f_pi2
                        ldx #>__f_pi2
                        jsr __float_float_to_fac
                        jmp __float_ret2
      ; fac =0
@s21:
                        ; a= 0
                        lda #$00
                        sta FAC_MANTISSA0
                        jmp __float_ret2
      ; fac <0
@s22:
                        ; a= 1.5*pi
                        lda #<__f_1pi2
                        ldx #>__f_1pi2
                        jsr __float_float_to_fac
                        jmp __float_ret2
        
