
.section .text

global suma

; extern int64_t suma(int64_t rdi, int64_t rsi)
suma:
    mov         rax, rdi
    add         rax, rsi
    ret
