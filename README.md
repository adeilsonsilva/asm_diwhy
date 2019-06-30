# ASM DIWHY

> A bunch of assembly code with no real point. Created by [@AD80](https://github.com/adeilsonsilva).

## Tools

* [NASM - The Netwide Assembler](https://www.nasm.us)
* [ld - The GNU linker ](https://linux.die.net/man/1/ld)

## Code style
```
procedure_name    <-- procedures named in snake case (lower)
CONSTANT_NAME     <-- constants are named in snake case (upper)
variableName      <-- variables are named in camel case
```


## Assembling and Linking

*The examples are created for 64 bits architectures. Feel free to search for the flags to your desired architecture in the docs above.*

### Compile all examples
*There is a script to compile all examples in this repo to ELF x86_64*

```
$ ./compile.sh
```

### ELF Format
```
$ nasm -f elf64 <file>.asm -o <objfile>.o
$ ld -m elf_x86_64 <objfile>.o -o <exefile>.exe
```

### ELF Format using external functions
```
$ nasm -f elf64 hello.asm
$ ld hello.o -dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc -m elf_x86_64
```

### PE32 Format
```
$ nasm -f win64 <file>.asm -o <objfile>.o
$ ld -m i386pep <objfile>.o -o <exefile>.exe
```
