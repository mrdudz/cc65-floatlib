; C128 BASIC V7 zero page floating point register locations
; Note: C128 FAC1 is at $63-$68 (not $61-$66 as on C64/VIC-20)

FAC_EXPONENT    = $63
FAC_MANTISSA0   = $64
FAC_MANTISSA1   = $65
FAC_MANTISSA2   = $66
FAC_MANTISSA3   = $67
FAC_SIGN        = $68

ARG_EXPONENT    = $6a
ARG_MANTISSA0   = $6b
ARG_MANTISSA1   = $6c
ARG_MANTISSA2   = $6d
ARG_MANTISSA3   = $6e
ARG_SIGN        = $6f

FAC_SIGN_COMPARE = $70   ; ARISGN
FAC_ROUNDING     = $71   ; FACOV

; addresses of the floating point routines in CBM BASIC V7

; the following are the addresses in the C128 ROM

; Mapping the C128 p224 / Programmers 522 (but the jump table
; value at the given location)
BASIC_FAC_Not       = $8ffa     ; in/out: FAC updated (negates sign routine, but NOT appears to be two's complement in BASIC)
BASIC_FAC_Cos       = $9409     ; in/out: FAC updated (p 227)
BASIC_FAC_Sin       = $9410     ; in/out: FAC updated (p 227)
BASIC_FAC_Tan       = $9459     ; in/out: FAC updated (p 227)
BASIC_FAC_Atn       = $94b3     ; in/out: FAC updated (p 227)
BASIC_FAC_Rnd       = $8434     ; in/out: FAC updated (p 220)
BASIC_FAC_Int       = $8cfb     ; in/out: FAC updated (p 224)
BASIC_FAC_Sqr       = $8fb7     ; in/out: FAC updated (p 225)
BASIC_FAC_Exp       = $9033     ; in/out: FAC updated (p 225)
BASIC_FAC_Log       = $89ca     ; in/out: FAC updated (p 223)
BASIC_FAC_Round     = $8c47     ; in/out: FAC updated (p 224)
BASIC_FAC_Sgn       = $8c65     ; in/out: FAC updated
BASIC_FAC_Abs       = $8c84     ; in/out: FAC updated

BASIC_ARG_FAC_Or    = $4c86     ; in: ARG,FAC out:FAC (p 209)
BASIC_ARG_FAC_And   = $4c89     ; in: ARG,FAC out:FAC (p 209)
BASIC_ARG_FAC_Sub   = $8831     ; in: ARG,FAC out:FAC updated
BASIC_ARG_FAC_Add   = $8848     ; in: ARG,FAC out:FAC updated
BASIC_ARG_FAC_Mul   = $8a27     ; in: ARG,FAC out:FAC updated
BASIC_ARG_FAC_Div   = $8b4c     ; in: ARG,FAC out:FAC updated
BASIC_ARG_FAC_Pow   = $8fc1     ; in: ARG,FAC out:FAC updated

; GIVAYF: Y=lo byte, A=hi byte of a 16-bit value -> FAC1
; note: for u8, A must be $00; the calling stub in float.s may need adjustment
BASIC_u8_to_FAC     = $793c     ; y: value (GIVAYF; A must be $00 for correct u8 conversion)
BASIC_s8_to_FAC     = $8c68     ; a: value (SNGFLT = SGN+3, same structure as C64/VIC-20)
BASIC_u16_to_FAC    = $8c75     ; FLOATC: store hi->$64, lo->$65 before call, ldx#$90 sec
BASIC_s16_to_FAC    = $793c     ; Y=lo/A=hi value (GIVAYF)

BASIC_FAC_to_u16    = $84b4     ; in:FAC out: signed int in $66(hi)/$67(lo) (AYINT)

; note: C128 VAL_1 expects string pointer in $24/$25, not $22/$23 as on C64/VIC-20
BASIC_string_to_FAC = $8052     ; in: $24/$25 ptr to str, a=strlen out: FAC (VAL_1)
BASIC_FAC_to_string = $8e42     ; in: FAC value   out: str at $0100 a/y ptr to str (FOUT)

BASIC_LoadARG       = $8a89     ; a/y:lo/hi ptr to 5-byte float, loads FAC2 (ROMUPK, current bank)
BASIC_LoadFAC       = $8bd4     ; a/y:lo/hi ptr to 5-byte float, loads FAC1 (MOVFM, current bank)

BASIC_FAC_testsgn   = $8c57     ; in: FAC(x1) out: a=0 (x1=0) a=1 (x1>0) a=255 (x1<0) (SIGN)
BASIC_FAC_cmp       = $8c87     ; in: FAC(x1) a/y ptr lo/hi to x2 out: a=0 (x1=x2) a=1 (x1>x2) a=255 (x1<x2) (FCOMP)

BASIC_FAC_Poly2     = $909c     ; in: FAC x  a/y ptr to poly (1byte grade,5bytes per coeff) EXP series
BASIC_FAC_Poly1     = $9086     ; in: FAC x  a/y ptr to poly (1byte grade,5bytes per coeff) LOG/SIN/COS/TAN/ATN series
