#!/usr/bin/env bash

echo "-> Compiling 'hello_world'"
nasm -f elf64 hello_world.asm -o hello_world.o
ld -m elf_x86_64 hello_world.o -o hello_world.x

echo "-> Compiling 'procedure'"
nasm -f elf64 procedure.asm -o procedure.o
ld -m elf_x86_64 procedure.o -o procedure.x

echo "-> Compiling 'linear_regression'"
nasm -f elf64 linear_regression.asm -o linear_regression.o
ld -m elf_x86_64 linear_regression.o -o linear_regression.x -dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc
