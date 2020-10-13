# Fasm Adapted Lessons from asmtutor

## Table of Contents

1. [Intro](#intro)
2. [Compile](#compile)
3. [Lesson Architecture](#lesson-architecture)
4. [Lessons' content](#lessons-content)

## Intro

The source of lesson taken from [AsmTutor][asmtutor].

The assembly used is [Flat Assembler (FASM)][fasmSite]

The original lesson is in NASM but this lesson files are adapted to FASM.

## Compile

Using FASM is fairly straightforward. Simply invoking the `fasm file`
is enough to compile and just run the resulting executable with `./file`.

For example:

```bash
$ fasm lesson01.asm
$ ./lesson01
# will print
Hello world!
segmentation fault
```

## Lesson Architecture

This lessons are using the 32-bit arch but with decent Linux it would
be run no problem.

asmtutor: https://asmtutor.com
fasmSite: https://flatassembler.net

## Lessons' content

1. Lesson 01: Printing the constant string to the stdout.
2. Lesson 02: Adding the proper exit from Lesson 01.
3. Lesson 03: Calculating the length of message during runtime.
