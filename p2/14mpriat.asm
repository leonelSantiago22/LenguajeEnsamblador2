.model small
.386
org 100h
include ..\fun\macros.asm
.stack
.code

main:
	print2 1,2,01000001b,"H"     ;parametros de cordenadas y parametros en binario que indican el color y el fondo
	print2 1,3,11110100b,"O"
	print2 1,4,00101011b,"L"
	print2 1,5,00101011b,"A"
	;print 1,1,00101011b," "

    print 'hola Mundo'
	.exit 0
end
	
