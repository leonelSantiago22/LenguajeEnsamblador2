.MODEL SMALL
.STACK
.DATA
.CODE
main:	mov ax,@data
		mov ds,ax

ini:	mov ah,01h
		int 21h
		mov dl,al
		mov ah,02h
		int 21h
		cmp al,71h
		jne ini
		.exit 0
end