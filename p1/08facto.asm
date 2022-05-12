;Programa que calcula el factorial de un numero pequeno

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

		call leedec		;Dato en el registro de AX, es un estandar
		push ax			;Lo respaldamos en la pila 
		call sumrec 	;Mandamos a llamar la sumatoria recursiva
		add sp,02h		;Restauramos la pila inmediatamente despues 
		mov dx,ax 		;Movemos el dato a dx para desplefar por que que desdec recibe el parametro en dx 
		call desdec		;Mandamos a llamar la funcion que imprime los numeros 
		call reto
		.exit 0

		;Funcion que permite el calculo de la sumatoria o factorial del numero ademas la funcion es recursiva

sumrec:	push bp 	;Movemos el base pointer la base de la pila 
		mov bp,sp 	;Creo el nuevo base pointer 
		mov ax,[bp+4]		;buscamos el dato en la pila ;parametro (el ultimo y el unico)
		cmp ax,1
		jg	sr_1			;suma recursiva punto de salto 1
		mov ax,1
		jmp sr_s			;suma recursiva punto de salto en salida
sr_1:	mov ax,[bp+4]
		dec ax
		push ax				;Asi es como pasamos el parametro a la funcion es otra invocacion separada 
		call sumrec 		;Resultado en ax
		add sp,02h			;Restauramos la pila
		mov dx,[bp+4]		
		mul dx				;Sumamos el resultado mas el parametro de la funcion guardandolo en DX-AX
		;Ignoramos la parte alta
sr_s:	;Dejando en AX el resultado
		mov sp,bp 		;movelos lo que tenemos en el base pointer al stack pointer apuntador de controlador de pila
		pop bp		;Salida del base pointer 
		ret
end
;crecimiento de la pila 
; ------
;|		|
;|------|
;|		|
;|------|
;|		|
; ------