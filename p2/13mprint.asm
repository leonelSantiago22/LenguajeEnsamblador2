.model small
.386
extrn reto:near
extrn reto:near
.stack
.data
.code
print	macro cadena
local dbcad,dbfin,salta
	pusha			;respalda todo
	push ds			;respalda DS, porque vamos a usar segmento de c�digo
	mov dx,cs		;segmento de codigo ser� tambi�n de datos
	mov ds,dx
	
	mov dx,offset dbcad	;direccion de cadena (en segmento de c�digo)
	mov ah,09h
	int 21h			;desplegar
	jmp salta		;saltar datos para que no sean ejecutados
	dbcad db cadena		;aqui estara la cadena pasada en la sustitucion
	dbfin db 24h		;fin de cadena	con su signo de pesos
salta:	pop ds			;etiqueta local de salto, recuperar segmento de datos
	popa			;recuperar registros
endm

main:	mov ax,@data
		mov ds,ax		;data segmente/segmento de datos
	
		print "Hola Mundo"
		call reto
		print "como estaS?"
		.exit 0
end