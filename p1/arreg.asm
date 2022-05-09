.MODEL SMALL

extrn des2:near
extrn spc:near

.STACK

.DATA

arreglo db 01h,02h,03h,04h

.CODE

main:	mov ax,@data
		mov ds,ax
		int 21h
		mov cx,04h
		lea bx,arreglo
		mov si,0h
cic:	mov dl,[bx+si]
		call des2
		call spc
		inc si
		loop cic
		.exit 0
end
		
		