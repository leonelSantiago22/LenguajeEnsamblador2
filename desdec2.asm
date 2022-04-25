.MODEL SMALL 
extrn desdec:near
.STACK
.DATA
.CODE
main:	mov ax,@data
		mov ds,ax
		mov es,ax	;habilitacion del extra segment
		mov dx,0
		call desdec
		
		.exit 0
end