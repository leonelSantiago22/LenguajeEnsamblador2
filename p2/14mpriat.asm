.model small
.386
org 100h
include ..\fun\macros.asm
.stack
.code

main:	mov ax, @data
		mov ds,ax 
		mov ah,02h
		int 21h
    print 'hola Mundo'
	.exit 0
end
	
