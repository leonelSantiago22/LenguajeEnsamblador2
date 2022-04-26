;Uso de macro en torres de hanoi para la reduccion de codigo, o el uso de un tipo de polimorfismo  
.MODEL SMALL
include ..\fun\macros.asm
extrn desdec:near
extrn leedec:near
extrn reto:near
.STACK
.DATA
.CODE
hano macro	tam,ori,aux,des
	push ax
	mov ax,ori
	push ax 
	mov ax,aux 
	push ax 
	mov ax,des 
	push ax 
	call hanoi 
	add sp,08
endm ;end macro  
main:	mov ax,@data
		mov ds,ax
		mov es,ax
		call leedec
		hano ax 'O' 'A' 'D'
		add sp,8
		.exit 0

hanoi:	push bp 			;Movemos el base pointer la base de la pila 
		mov bp,sp
		mov ax, [bp+10]
		cmp ax,0
		je salida
		dec ax 				;(n-1)

		hano ax [bp+8]	[bp+4]	[bp+6]

		;moves un disco de 0 a D 
		print 'movemos disco de '
		mov dx,[bp+8]	;origen
		mov ah,02
		int 21h
		print ' a '
		mov dx,[bp+4]	;destino
		mov ah,02
		int 21h

		call reto
		mov ax,[bp+10]
		dec ax 
		hano ax [bp+6]	[bp+8]	[bp+4]
salida:
		mov sp,bp 		;movelos lo que tenemos en el base pointer al stack pointer apuntador de controlador de pila
		pop bp		;Salida del base pointer 
		ret
end
;Algortimo hanoi (n, 0,A,D) tamano n, origen, auxiliar, destino 