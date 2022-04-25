.MODEL SMALL
.STACK
.DATA
.CODE
main: 	mov ax,@data
		mov ds,ax
		int 21h
		mov al,30h
		mov dl,al
impr:	mov ah,02h
		int 21h
		inc dl
		cmp dl,39h
		jle impr
		mov al,41h
		mov dl,al
imp2:	mov ah,02h
		int 21h
		inc dl
		cmp dl,5Ah
		jle imp2
		mov al,61h
		mov dl,alx
imp3:	mov ah,02h
		int 21h
		inc dl
		cmp dl,7Ah
		jle imp3
		.exit 0
end