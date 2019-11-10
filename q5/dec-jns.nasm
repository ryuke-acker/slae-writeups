global _start

section .text

_start:

	mov ecx, 5

_dec_loop:
	
	xor eax, eax
	mov eax, 4
	mov ebx, 1
	mov edx, 1
	int 0x80

	dec ecx
	jns _dec_loop

	xor eax, eax
	mov eax, 4
	mov ebx, 1
	jmp _define_string


_print_string:
	
	pop ecx
	xor edx, edx
	mov edx, 12
	int 0x80

_exit:
	xor eax, eax
	xor ebx, ebx
	mov eax, 1
	mov ebx, 1
	int 0x80

_define_string:
	
	call _print_string
	myString db "End of loop!"
