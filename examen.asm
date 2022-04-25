.MODEL SMALL
extrn lee1:near
extrn des2:near
.STACK
.DATA
.CODE
main:	mov ax,@data
		mov ds,ax
		call lee1
		mov bl,01h
		mov bh,0h
		
ini:	add bh,bl
		inc bl
		cmp bl,al
		jle ini 
		inc bl
		mov dl,bh
		call des2
		.exit 0
	
end