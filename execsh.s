BITS 32

section .text:
global _start

_start:
    xor     eax, eax
    cdq
    push    edx
    push    0x68732f2f
    push    0x6e69622f
    push    esp
    pop     ebx
    push    edx
    push    ebx
    push    esp
    pop     ecx
    mov     al, 0xb
    int     0x80
