org 256
mov ah,9
mov dx,hello
int 21h
int 20h

hello db 'Hello world!$'
