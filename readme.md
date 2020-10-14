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
4. Lesson 04: Introducing subroutine.
5. Lesson 05: Including external file.
6. Lesson 06: Ending the string with null-terminating byte.
7. Lesson 07: Using Extended Stack Pointer (ESP) to print the `0Ah` byte.
8. Lesson 08: Command line arguments.
9. Lesson 09: Reading user input
10. Lesson 10: Counting and printing number to console.
11. Lesson 11: Printing integer more than 10 to console.
12. Lesson 12: Adding unsigned integer.
13. Lesson 13: Subtracting unsigned integer.
14. Lesson 14: Multiplying unsigned integer.
15. Lesson 15: Dividing unsigned integer.
16. Lesson 16: Calculating command arguments.
17. Lesson 17: Namespace local label.
18. Lesson 18: Fizz Buzz division.
19. Lesson 19: Executing external command.
20. Lesson 20: Forking child process.
21. Lesson 21: Getting Unix epoch timestamp.
22. Lesson 22: Creating a file.
23. Lesson 23: Writing a file.
24. Lesson 24: Opening a file.
25. Lesson 25: Reading a file.
26. Lesson 26: Closing a file.
27. Lesson 27: Seeking a file.
