
section .text

global simd_light
; data should be a multiple of 16
; void simd_light(
;       uint8_t *data,      // rdi
;       uint32_t size,      // rsi
;       uint8_t *light);     // rdx

simd_light:
    movdqu      xmm0, [rdx]
    shr         rsi, 4          ; rsi <- rsi / 16
.repeat:
    movdqu      xmm1, [rdi]
    paddusb     xmm1, xmm0      ; xmm1 <- xmm1 + xmm0
    movdqu      [rdi], xmm1
    add         rdi, 16
    dec         rsi
    jnz         .repeat
    ret
