.MODEL SMALL
.STACK
.DATA
.CODE
main:	mov ax,@data
		mov ds,ax
ini:	mov ah,01h
		int 21h
		add al,20h
		mov dl,al
		mov ah,02h
		int 21h
		cmp dl,20h
		jge ini
		.exit 0
end