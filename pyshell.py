import argparse
from subprocess import getoutput
import os
import sys

def prerequesites():
    ready = True
    if (getoutput("which nasm") == ''):
        ready = False
    if (getoutput("which objdump") == ''):
        ready = False
    return ready

def dump_file(filename):
    dest = filename.replace(".nasm", ".o")
    tmp = getoutput("nasm -f elf32 %s -o %s"%(filename,dest))
    if 'error' in tmp:
        print("[!] Error in the asm file.")
        exit(42);
    tmp = getoutput("objdump -d %s"%dest)
    getoutput("rm %s"%dest)
    #print ("Output: %s"%tmp)
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

def format_output(dmp, width=8):
    dmp = dmp.split('\\x')[1:]
    return '\\x'+'\n\\x'.join(['\\x'.join(dmp[i:i+width]) for i in range(0,len(dmp), width)])

def run(options):
    if options.file:
        encoded = encode(dump_file(options.file))
        print('[+] Encoded:\n', encoded)

if not prerequesites():
    print("[!] Pyshell requires nasm and objdump!")
    sys.exit(1)
else:
    parser = argparse.ArgumentParser()
    parser.add_argument("file", help="The nasm file you want to convert into shellcode.") 
   # parser.add_argument("-v")
    run(parser.parse_args()) 
    sys.exit(0);
