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

----
### Win64
To compile on Windows 64 bit, will from now on called as Win64, we must put the
`fasm.exe` available on the `PATH` global environment. Additionally, fasm needs
the global variable `INCLUDE` to where the include folder where fasm is extracted.  

For example we just put our fasm extraction on `c:\fasm`, at this stage we still
don't have the `fasm.exe` in the `PATH` so we can add it temporarily during
this particular cmd session.

```cmd
> set PATH=%PATH%;c:\fasm
> set INCLUDE=c:\fasm\include
> fasm
flat assembler  version 1.73.24
usage: fasm <source> [output]
optional settings:
 -m <limit>         set the limit in kilobytes for the available memory
 -p <limit>         set the maximum allowed number of passes
 -d <name>=<value>  define symbolic variable
 -s <file>          dump symbolic information for debugging
```

If we have the output as shown above, we can use `fasm.exe` as simple as
Linux example above.

---
### Win16
When compiling to Win16 COM object file, do the installation like Win64
example above.  
As Windows 64-bit cannot run COM object file anymore, we can install
[Dosbox][dosbox], Freedos [Virtualbox][freedos-vm] or [other][freedos-other],
or simply wrap our COM object with [winedvm/otvdm][otvdm-github] for
example `otvdm.exe lesson01.com`.
Add the folder where `otvdm.exe` to the `PATH` like we did for Win64.

After that it's as simple as

```
> fasm lesson01.asm
> otvdm lesson01.com
Hello world!
```

## Lesson Architecture

The original lessons are giving example using `int 80h` for Linux32 but
this notes is adapted to both Linux32 and Linux64.  
For any decent linux, the notes examples for Linux32 are still able to
be compiled and ran even the host machine is Linux64.

Avoid using `rcx` and `r11` when calling `syscall` for Linux64 because
both of register are implicitly used as return address and flags subsequently.
[Ref][so-answer-rcx].

----
### Win64
For Windows 64 bit, abbreviated as Win64, the lessons are using Win32 [index][win32-api-index]
instead of `syscall` because there's no reliable documentation available
freely. There's some book which explains the internals, [Windows Internal Books][win-internal],
but as mentioned before, it's not available for free. Hence we use the
available [Windows API][win32-api-index].

----
### Win16
In Windows 16, the COM object immediately calls the interrupts.
The list of kernel interrupts can be found at [Ralf Brown's Interrupt List][rbil]
for the local reference or [The Html version][rbil-html] to avoid downloading
the lists.

## Lessons' content

1. Lesson 01: Printing the constant string to the stdout.
2. Lesson 02: Adding the proper exit from Lesson 01. Win16 already available since lesson 01.
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
20. Lesson 20: Forking child process. Using `CreateThread` on Win64.
21. Lesson 21: Getting Unix epoch timestamp.
22. Lesson 22: Creating a file.
23. Lesson 23: Writing a file.
24. Lesson 24: Opening a file.
25. Lesson 25: Reading a file. Win64 version already available in lesson 24.
26. Lesson 26: Closing a file.
27. Lesson 27: Seeking a file. Make sure we have the writing permission when opening the file.
28. Lesson 28: Deleting a file.
29. Lesson 29: Creating socket.
30. Lesson 30: Binding socket.
31. Lesson 31: Listening socket.
32. Lesson 32: Accepting socket.
33. Lesson 33: Reading socket.
34. Lesson 34: Writing socket, responding HTTP.
35. Lesson 35: Closing the socket. Win64 version already available since lesson 32.
36. Lesson 36: Fetching HTML page.

[asmtutor]: https://asmtutor.com
[fasmSite]: https://flatassembler.net
[so-answer-rcx]: https://stackoverflow.com/a/50571366
[win32-api-index]: https://docs.microsoft.com/en-us/windows/win32/apiindex/windows-api-list
[win-internal]: https://docs.microsoft.com/en-us/sysinternals/resources/windows-internals
[dosbox]: [https://www.dosbox.com]
[freedos-vm]: [http://wiki.freedos.org/wiki/index.php/VirtualBox]
[freedos-other]: [https://www.osboxes.org/freedos/]
[otvdm-github]: [https://github.com/otya128/winevdm]
[rbil]: [https://www.cs.cmu.edu/~ralf/files.html]
[rbil-html]: [http://www.ctyme.com/rbrown.htm]
