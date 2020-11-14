import argparse
from subprocess import getoutput
import os
import sys

def dump_file(filename, verbose):
    dest = filename.replace(".nasm", ".o")
    tmp = getoutput("nasm -f elf32 %s -o %s"%(filename,dest))
    if 'error' in tmp:
        print("[!] Error in the asm file.")
        exit(42)
    
    tmp = getoutput("objdump -d %s"%dest)
    if verbose:
        print ("=> objdump: %s"%tmp)
        print("")
    getoutput("rm %s"%dest)
    opcodes = ''
    for line in tmp.split('\n')[7:]:
        tmp = line.split(':',1)
        if len(tmp) > 1 and len(tmp[1]) > 0: tmp = tmp[1]
        else: continue
        # split on tab to get opcodes
        tmp = ''.join(tmp).split('\t')
        if len(tmp) > 1: tmp = tmp[1].strip().replace(' ','')
        if '<' in tmp: continue
        opcodes += tmp
    return opcodes

def encode(lbyte):
    formatted_lbyte = ''.join(["\\x"+lbyte[idx]+lbyte[idx+1] for idx in range(0, len(lbyte)-1,2)])
    return formatted_lbyte

def run(options):
    if options.file:
        encoded = encode(dump_file(options.file, options.verbose))
        print('[+] Encoded:\n', encoded)
        if options.binary:
            tmp = getoutput("cp ./exec/tester.c shellcode.c")
            tmp = getoutput("sed -i 's/<insert_here>/%s/g' shellcode.c"%(encoded))
            tmp = getoutput("gcc -m32 -fno-stack-protector -z execstack -o shellcode.bin shellcode.c")
            tmp = getoutput("rm shellcode.c")
            print("\nShellcode exported in shellcode.bin")

def dependencies():
    ready = True
    if (getoutput("which nasm") == ''):
        ready = False
    if (getoutput("which objdump") == ''):
        ready = False
    return ready

def parse_arguments():
    parser = argparse.ArgumentParser()
    parser.add_argument("file", help="The nasm file you want to convert into shellcode.") 
    parser.add_argument("-v", "--verbose", action="store_true", help="Enables verbose output")
    parser.add_argument("-b", "--binary", action="store_true", help="Export shellcode as a binary")
    return parser.parse_args()

if __name__ == "__main__":
    # Execute if run as a script
    if not dependencies():
        print("[!] Pyshell requires nasm and objdump!")
        sys.exit(1)
    run(parse_arguments()) 
    sys.exit(0)
