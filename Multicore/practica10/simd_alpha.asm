
section .text

global simd_alpha
; data should be a multiple of 16
; void simd_alpha(
;       uint8_t *fore,      // rdi
;       uint8_t *back,      // rsi
;       uint32_t size,      // rdx
;       uint16_t *alpha,    // rcx
;       uint16_t *bAlpha);  // r8

simd_alpha:
;   Get alpha and 255 - alpha
    movdqu      xmm0, [rcx]
    movdqu      xmm1, [r8]
    shr         rdx, 3
.repeat:
;   Fore
    movq        xmm2, [rdi]
    pmovzxbw    xmm2, xmm2
    pmullw      xmm2, xmm0
    psrlw       xmm2, 8
;   Back 
    movq        xmm3, [rsi]
    pmovzxbw    xmm3, xmm3
    pmullw      xmm3, xmm1
    psrlw       xmm3, 8
;   Result
    paddw       xmm2, xmm3
    packuswb    xmm2, xmm2
    movq        [rdi], xmm2
    add         rdi, 8
    add         rsi, 8
    dec         rdx
    jnz         .repeat
    ret
