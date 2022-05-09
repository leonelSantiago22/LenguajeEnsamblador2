.MODEL SMALL
.STACK
.DATA
.CODE
main: 	mov ax,@data
		mov ds,ax
		mov bl,1h
cic1: 	mov cl,bl
		mov ch,0
		mov dl, 'a'
cic2:	mov ah,02h
		int 21h
		inc dl
		loop cic2
		inc bl
		mov dl,' '
		int 21h
		cmp bl,11h
		jne cic1
		mov ah,4ch
		int 21h

		.exit 0

end