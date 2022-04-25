.MODEL SMALL
extrn des1:near
extrn des2:near
extrn desdec:near
extrn leedec:near

.STACK
.DATA
.CODE
main:	mov ax,@data
		mov ds,ax
		call leedec
		mov bx,ax
		call leedec
		mul bx
		mov dx,ax
		call desdec
		.exit 0
end	