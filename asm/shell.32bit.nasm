BITS 32
; Simple shell '/bin/sh'
; Made by skuppers: skuppers@student.42.fr

section .text

global main

main:
    xor eax,eax		; Zero out eax
    push eax		; Push 0x0 on stack for string termination
    push 0x68732f2f	; Push '//sh'
    push 0x6e69622f	; Push '/bin'
    mov ebx,esp		; Push '/bin//sh' from stack to ebx
    mov ecx,eax		; Zero out ecx: argv
    mov edx,eax		; Zero out edx: envp
    mov al, 0xb		; Syscall 11
    int 0x80		; Interrupt
