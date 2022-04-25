;0E. Hacer programa que despliegue A AB ABC ... ABCDE..Z.
.MODEL SMALL
.STACK
.DATA
.CODE
main:	mov ax,@data
		mov ds,ax

		mov bl,01h
cicl1:	mov cl,bl
		mov ch,0
		mov dl,'A'
cicl2: 	mov ah,02h
		int 21h
		inc dl
		loop cicl2
		inc bl
		mov dl,20h
		mov ah,02h
		int 21h
		cmp bl,1Bh
		jne cicl1
		.exit 0
end