;0F. Programa que lea dos letras del teclado, y despliegue aquella que sea menor alfabéticamente.
.MODEL SMALL
.STACK
.DATA
.CODE
main: 	mov ax,@data
		mov ds,ax
		mov ah,01h
		int 21h
		mov bl,al
		mov ah,01h
		int 21h
		cmp bl,al
		jl5e sal
		mov dl,al
		jmp imp
sal:	mov dl,bl
imp:	mov ah,02h
		int 21h
		.exit 0
end