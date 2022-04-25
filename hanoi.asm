.MODEL SMALL
extrn desdec:near
extrn leedec:near
extrn reto:near
.STACK
.DATA
.CODE
main:	mov ax,@data
		mov ds,ax
		mov es,ax
		call leedec
		push ax 	;[bp+10]
		mov al,'O'
		push ax 	;origne: [bp+8]
		mov al,'A'
		push ax 	;Auxiliar: [bp+6]
		mov al,'D'
		push ax 	;Destino: [bp+4]
		call hanoi
		add sp,8
		.exit 0

hanoi:	push bp 			;Movemos el base pointer la base de la pila 
		mov bp,sp
		mov ax, [bp+10]
		cmp ax,0
		je salida
		dec ax 				;(n-1)
		push ax 			;n -1 lo mandamos 
		mov ax,[bp+8]
		push ax 			;origen 
		mov ax,[bp+4]
		push ax 			;Destino 
		mov ax,[bp+6]		
		push ax 			;Auxiliar
		call hanoi
		add sp,8 			;Restauramos la pila 
		;moves un disco de 0 a D 
		mov dx,[bp+8]	;origen
		mov ah,02
		int 21h
		mov dx,[bp+4]	;destino
		mov ah,02
		int 21h
		;call reto
		mov ax, [bp+10]
		dec ax 				;(n-1)
		push ax 			;n -1 lo mandamos 
		mov ax,[bp+6]
		push ax 			;Auxiliar 
		mov ax,[bp+8]
		push ax 			;Origen
		mov ax,[bp+4]		
		push ax 			;Destino
		call hanoi
		add sp,8 
salida:
		mov sp,bp 		;movelos lo que tenemos en el base pointer al stack pointer apuntador de controlador de pila
		pop bp		;Salida del base pointer 
		ret
end
;Algortimo hanoi (n, 0,A,D) tamano n, origen, auxiliar, destino 