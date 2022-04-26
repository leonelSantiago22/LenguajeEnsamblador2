.model small
.386
extrn reto:near
.stack
.data
.code
print	macro cadena
local dbcad,dbfin,salta
	pusha			;respalda todo
	push ds			;respalda DS, porque vamos a usar segmento de código
	mov dx,cs		;segmento de código será también de datos
	mov ds,dx
	
	mov dx,offset dbcad	;dirección de cadena (en segmento de código)
	mov ah,09h
	int 21h			;desplegar
	jmp salta		;saltar datos para que no sean ejecutados
	dbcad db cadena		;aquí estará la cadena pasada en la sustitución
	dbfin db 24h		;fin de cadena
salta:	pop ds			;etiqueta local de salto, recuperar segmento de datos
	popa			;recuperar registros
endm

main:	mov ax,@data
	mov ds,ax
	
	print "Hola Mundo"
	print "aqui nomas"
	.exit 0
end