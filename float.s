
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

        .importzp sp

;
; pop y/a from stack. This function will run directly into incsp2x
;
; routine saves 2 bytes each call, is 27 bytes long
; => usage pays off as a size improvement if called atleast 14 times,
; else 'bloats' the code by 27 bytes ;=)
;

        .export         popya           ; pop stack into YA (for kernal routines)

popya:  ldy     #1
   	lda	(sp),y		; get hi byte
       	tax	     		; into x
   	dey
   	lda	(sp),y		; get lo byte
        ; put parameters in right order for kernal routines
        tay
        txa
;
; routines for inc/dec'ing sp
;
        .export         incsp2x

; do this by hand, cause it gets used a lot

incsp2x: ldx     sp              ; 3
         inx                     ; 2
         beq     @L1             ; 2
         inx                     ; 2
         beq     @L2             ; 2
         stx     sp              ; 3
         rts

@L1:     inx                     ; 2
@L2:     stx     sp              ; 3
         inc     sp+1            ; 5
         rts


  .export   __ftostr,__strtof,__ftoi
  .export   __fcmp,__ftestsgn
  .export   __ctof,__utof,__itof,__stof
  .export   __fadd,__fsub,__fmul,__fdiv,__fpow
  .export   __fand,__for,__fnot,__fneg
  .export   __fabs, __fatn, __fcos, __fexp, __fint, __flog,__frnd
  .export   __fsgn, __fsin, __fsqr, __ftan,__fnot,__fround
  .export   __fpoly1,__fpoly2

  .import   popa,popax,pushax,pusha
  .importzp ptr1

  .include  "float.inc"

;---------------------------------------------------------------------------------------------
; first come the actual stubs to floating point routines, these are ment to be
; used from further written ml-math routines aswell. (maybe also from the compiler?!)
;---------------------------------------------------------------------------------------------

;---------------------------------------------------------------------------------------------
; converter integer types to float
;---------------------------------------------------------------------------------------------

___float_s8_to_fac:
        jsr popa
        ;a: low
__float_s8_to_fac:
        jsr __basicon
        jsr BASIC_s8_to_FAC
        jmp __basicoff
;       rts

___float_u8_to_fac:
        jsr popa
        ;a: low
__float_u8_to_fac:
        jsr __basicon
        jsr BASIC_u8_to_FAC
        jmp __basicoff
;       rts

___float_s16_to_fac:
        jsr popya
        ;a: low x: high
;        tay
;        txa
__float_s16_to_fac:
        jsr __basicon
        ;y: low a: high
        jsr BASIC_s16_to_FAC
        jmp __basicoff
;       rts

___float_u16_to_fac:
        jsr popax
        ;a: low x: high
__float_u16_to_fac:
        stx $62
        sta $63
        jsr __basicon
        ldx #$90
        sec
        jsr BASIC_u16_to_FAC
        jmp __basicoff
;       rts

__float_fac_to_u16:
        jsr __basicon
        jsr BASIC_FAC_to_u16
        jsr __basicoff
        ldx $64
        lda $65
        rts
;---------------------------------------------------------------------------------------------
; converter float to string and back
;---------------------------------------------------------------------------------------------

__float_fac_to_str:
        jsr __basicon
        jsr BASIC_FAC_to_string
        jmp __basicoff
;        rts

___float_str_to_fac:
        jsr popax
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
; load float from memory to fac and/or arg and back for further processing
; we cant use the routines from basic for this task since source adress
; may be located in the same bank as basic rom.
;---------------------------------------------------------------------------------------------

	.import ldeaxysp, incsp4

___float_float_to_fac:
;        jsr popax ; ptr to float
		  
 	ldy     #$03
 	jsr     ldeaxysp
        sta $63 ; mantissa
        stx $62 ; mantissa
	ldy     sreg
        sty $61 ; exp
	ldy     sreg+1
        sty $66 ; sign
	
        ldx #$00
	stx $64 ; mantissa
	stx $65 ; mantissa
		
        stx $70

	.if 1=0

	ldx #0
@l:
	lda $61,x
	sta $0400+(0*40),x
	inx
	cpx #6
	bne @l

	.endif
		
	jmp     incsp4
; 	rts

__float_float_to_fac:
        sta ptr1
        stx ptr1+1
        ldy #$00
        lda (ptr1),y
        sta $61
        iny
        lda (ptr1),y
        sta $62
        iny
        lda (ptr1),y
        sta $63
        iny
        lda (ptr1),y
        sta $64
        iny
        lda (ptr1),y
        sta $65
        iny
        lda (ptr1),y
        sta $66
        ldx #$00
        stx $70
         ; always load arg after fac so these can
         ; be removed in funcs that only take fac
;        eor $6e
;        sta $6f
        rts

; get two floats, to FAC and ARG

___float_float_to_fac_arg:
        ;jsr popax ; ptr to float
        jsr ___float_float_to_fac    ; also pops pointer to float
___float_float_to_arg:
;        jsr popax ; ptr to float

 	ldy     #$03
 	jsr     ldeaxysp
	; 1
        sta $6b ; mantissa
	; 2
        stx $6a ; mantissa

	ldy     sreg
	; 3
        sty $69 ; exp

        ldx #$00
	stx $6c ; mantissa
	stx $6d ; mantissa
			
	lda     sreg+1
	; 4
        sta $6e ; sign
        eor $66 ; sign FAC
        sta $6f

	.if 1=0
			
	ldx #0
@l:
	lda $69,x
	sta $0400+(1*40),x
	inx
	cpx #6
	bne @l

	.endif
			
	jmp     incsp4
;	rts

        
__float_float_to_arg:
        sta ptr1
        stx ptr1+1
        ldy #$00
        lda (ptr1),y
        sta $69
        iny
        lda (ptr1),y
        sta $6a
        iny
        lda (ptr1),y
        sta $6b
        iny
        lda (ptr1),y
        sta $6c
        iny
        lda (ptr1),y
        sta $6d
        iny
        lda (ptr1),y
        sta $6e
        ; sign compare
        eor $66
        sta $6f
        rts

	.importzp sreg

;
;	return 32bit float value
;
			
___float_fac_to_float:

	.if 1=0
	ldx #0
@l:
	lda $61,x
	sta $0400+(2*40),x
	inx
	cpx #6
	bne @l
	.endif	

        lda $66 ; sign
	sta     sreg+1 ; 1

			
        lda $61 ; exp
	sta     sreg   ; 2
	; 3
        ldx $62 ; mantissa
	; 4
        lda $63; mantissa
	
; 	lda #$12
; 	sta     sreg+1 ; 1
; 	lda #$34
; 	sta     sreg
; 	ldx #$56
; 	lda #$78
	rts

;        jsr popax ; ptr to float

__float_fac_to_float:
        sta ptr1
        stx ptr1+1
        ldy #$00
        lda $61
        sta (ptr1),y
        iny
        lda $62
        sta (ptr1),y
        iny
        lda $63
        sta (ptr1),y
        iny
        lda $64
        sta (ptr1),y
        iny
        lda $65
        sta (ptr1),y
        iny
        lda $66
        sta (ptr1),y
        rts

__float_fac_to_float_packed:
        sta ptr1
        stx ptr1+1
	ldy #4
        lda $65
        sta (ptr1),y
	dey
        lda $64
        sta (ptr1),y
	dey
        lda $63
        sta (ptr1),y
	dey
	lda #$66
	ora #$7f
	and $62
        sta (ptr1),y
	dey
        lda $61
        sta (ptr1),y
	rts

__float_arg_to_float_packed:
        sta ptr1
        stx ptr1+1
	ldy #4
        lda $65+8
        sta (ptr1),y
	dey
        lda $64+8
        sta (ptr1),y
	dey
        lda $63+8
        sta (ptr1),y
	dey
	lda #$66+8
	ora #$7f
	and $62+8
        sta (ptr1),y
	dey
        lda $61+8
        sta (ptr1),y
	rts

;---------------------------------------------------------------------------------------------

; convert float to string
; void _ftos(char *d,FLOATFAC *s)

__ftostr:
        ;jsr popax ; ptr to float
        jsr ___float_float_to_fac    ; also pops pointer to float
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
        rts

__strtof:
        jsr ___float_str_to_fac
        jmp ___float_fac_to_float    ; also pops pointer to float
;        rts

; convert char to float
; void _ctof(FLOATFAC *f,char v);
 __ctof:
        ;jsr popa  ; char
        jsr ___float_s8_to_fac
        ;jsr popax ; ptr to float
        jmp ___float_fac_to_float
        ;rts

; convert unsigned char to float
; void _utof(FLOATFAC *f,unsigned char v);
 __utof:
        ;jsr popa  ; char
        jsr ___float_u8_to_fac
        ;jsr popax ; ptr to float
        jmp ___float_fac_to_float
        ;rts

; convert short to float
; void _stof(FLOATFAC *f,unsigned short v);
 __stof:
;        jsr popax
;        sta $62
;        stx $63
;        sec
;        ldx #$90
        jsr ___float_u16_to_fac
        ;jsr popax ; ptr to float
        jmp ___float_fac_to_float
        ;rts

; convert integer to float
; void _itof(FLOATFAC *f,int v);
 __itof:
        ;jsr popya ; integer
;        tay
;        txa
        ;y: low a: high
        jsr ___float_s16_to_fac
        ;jsr popax ; ptr to float
        jmp ___float_fac_to_float
        ;rts

; convert float to integer
; void _itof(FLOATFAC *f);
 __ftoi:
        jsr ___float_float_to_fac    ; also pops pointer to float

; /*	lda $61+0
; 	sta $0450+0
; 	lda $61+1
; 	sta $0450+1
; 	lda $61+2
; 	sta $0450+2
; 	lda $61+3
; 	sta $0450+3
; 	lda $61+4
; 	sta $0450+4
; 	lda $61+5
; 	sta $0450+5*/
        
        jsr __float_fac_to_u16

; ; 	ldy $61+0
; ; 	sty $0478+0
; ; 	ldy $61+1
; ; 	sty $0478+1
; ; 	ldy $61+2
; ; 	sty $0478+2
; ; 	ldy $61+3
; ; 	sty $0478+3
; ; 	ldy $61+4
; ; 	sty $0478+4
; ; 	ldy $61+5
; ; 	sty $0478+5

        
;       ldx #$12
;       lda #$34
;        jmp pushax ; ptr to integer
        rts

;---------------------------------------------------------------------------------------------
; these functions take one arg (in FAC) and return result (in FAC) aswell
;---------------------------------------------------------------------------------------------

.macro __ffunc1 addr
        ;jsr popax ; ptr to float
        jsr ___float_float_to_fac    ; also pops pointer to float
        jsr __basicon
        jsr addr
        jsr __basicoff
;        jsr popax ; ptr to float
        jmp ___float_fac_to_float    ; also pops pointer to float
        ;rts
.endmacro

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
;        jsr popax ; ptr to float
        jmp ___float_fac_to_float    ; also pops pointer to float
        ;rts

.macro __ffunc2a addr
        ;jsr popax ; ptr to float
        ;jsr ___float_float_to_fac    ; also pops pointer to float
        ;jsr popax ; ptr to float
        ;jsr ___float_float_to_arg    ; also pops pointer to float
        jsr ___float_float_to_fac_arg
        jsr __basicon
        lda $61
        jsr addr
        jmp __float_ret2
;        jsr __basicoff
;        jsr popax ; ptr to float
;        jmp ___float_fac_to_float    ; also pops pointer to float
        ;rts
.endmacro

.macro __ffunc2b addr
        ;jsr popax ; ptr to float
        ;jsr ___float_float_to_fac    ; also pops pointer to float
        ;jsr popax ; ptr to float
        ;jsr ___float_float_to_arg    ; also pops pointer to float
        jsr ___float_float_to_fac_arg
        jsr __basicon
        jsr addr
        jmp __float_ret2
;        jsr __basicoff
;        jsr popax ; ptr to float
;        jmp ___float_fac_to_float    ; also pops pointer to float
        ;rts
.endmacro

__fadd:   __ffunc2a BASIC_ARG_FAC_Add
__fsub:   __ffunc2a BASIC_ARG_FAC_Sub
__fmul:   __ffunc2a BASIC_ARG_FAC_Mul
__fdiv:   __ffunc2a BASIC_ARG_FAC_Div
__fpow:   __ffunc2a BASIC_ARG_FAC_Pow

__fand:   __ffunc2b BASIC_ARG_FAC_And
__for:    __ffunc2b BASIC_ARG_FAC_Or

__float_ret3:

        ;jsr __basicoff
        ldx #$36
        stx $01
        cli
        ; a=0 (==) / a=1 (>) / a=255 (<)
	ldx #0
;        jmp pushax
        rts

tempfloat:	.res 5
			
__fcmp:
        jsr ___float_float_to_fac_arg
	lda #<tempfloat
	ldx #>tempfloat
	jsr __float_arg_to_float_packed
        lda #<tempfloat
        ldy #>tempfloat
___float_cmp_fac_arg:
        jsr __basicon
        jsr BASIC_FAC_cmp
        jmp __float_ret3

__ftestsgn:
        jsr ___float_float_to_fac
;___float_testsgn_fac:
        jsr __basicon
        jsr BASIC_FAC_testsgn
        jmp __float_ret3

___float_testsgn_fac:
        lda $61
        beq @s
        lda $66
        rol a
        lda #$ff
        bcs @s
        lda #$01
@s:
        rts

___float_testsgn_arg:
        lda $69
        beq @s
        lda $6e
        rol a
        lda #$ff
        bcs @s
        lda #$01
@s:
        rts

;---------------------------------------------------------------------------------------------
; polynom1 f(x)=a1+a2*x^2+a3*x^3+...+an*x^n
;---------------------------------------------------------------------------------------------
__fpoly1:
        jsr ___float_float_to_fac
        jsr popya
        jsr __basicon
        jsr BASIC_FAC_Poly1
        jmp __float_ret2

;---------------------------------------------------------------------------------------------
; polynom2 f(x)=a1+a2*x^3+a3*x^5+...+an*x^(2n-1)
;---------------------------------------------------------------------------------------------
__fpoly2:
        jsr ___float_float_to_fac
        jsr popya
        jsr __basicon
        jsr BASIC_FAC_Poly1
        jmp __float_ret2

__float_atn_fac:
        jsr __basicon
        jsr BASIC_FAC_Atn
        jmp __basicoff
__float_div_fac_arg:
        jsr __basicon
        lda $61
        jsr BASIC_ARG_FAC_Div
        jmp __basicoff
__float_add_fac_arg:
        jsr __basicon
        lda $61
        jsr BASIC_ARG_FAC_Add
        jmp __basicoff

__float_swap_fac_arg:
        lda   $61
        ldx   $69
        stx   $61
        sta   $69
        lda   $62
        ldx   $6a
        stx   $62
        sta   $6a
        lda   $63
        ldx   $6b
        stx   $63
        sta   $6b
        lda   $64
        ldx   $6c
        stx   $64
        sta   $6c
        lda   $65
        ldx   $6d
        stx   $65
        sta   $6d
        lda   $66
        ldx   $6e
        stx   $66
        sta   $6e
        rts


__fneg:
        jsr ___float_float_to_fac    ; also pops pointer to float

	LDA $61       ; FAC Exponent
	BEQ @sk
	LDA $66       ; FAC Sign
	EOR #$FF
	STA $66       ; FAC Sign
@sk:
        jmp ___float_fac_to_float    ; also pops pointer to float
;	RTS

        .export __f_0,__f_256
        .export __f_pi2,__f_pi,__f_1pi2,__f_2pi

__f_0:    .byte $00,$80+$00,$00,$00,$00,$00
__f_256:  .byte $89,$80+$00,$00,$00,$00,$00

__f_pi2:  .byte $81,$80+$49,$0f,$da,$a1,$00
__f_pi:   .byte $82,$80+$49,$0f,$da,$a1,$00
__f_1pi2: .byte $83,$80+$16,$cb,$e3,$f9,$00
__f_2pi:  .byte $83,$80+$49,$0f,$da,$a1,$00

        .export __fatan2

; void _fatan2(float *a,float *x,float *y)
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
                        sta $62
                        jmp __float_ret2
      ; fac <0
@s22:
                        ; a= 1.5*pi
                        lda #<__f_1pi2
                        ldx #>__f_1pi2
                        jsr __float_float_to_fac
                        jmp __float_ret2
