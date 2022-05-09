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

		call suma 
		call reto 
		mov dx,ax
		call desdec 
		.exit 0 
		;Funcion para sumar n cantidad de numeros


suma: 	push bp 	;Movemos el base pointer la base de la pila 
		mov bp,sp 	;Creo el nuevo base pointer 
		sub sp,02h	;Creamos la variable localizada car local : [bp+2]
		call leedec
		mov [bp-2],ax
ini:	call leedec
		cmp ax,000
		je sal
		add [bp-2],ax
		jmp ini
sal:	mov ax,[bp-2]	
		mov sp,bp
		pop bp		
		ret	
end

;programa que sume 