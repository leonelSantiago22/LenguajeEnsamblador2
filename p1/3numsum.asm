.MODEL SMALL
extrn lee4:near
extrn des4:near
extrn spc:near
extrn reto:near
.STACK
.DATA
numero1 dw 	?
numero2 dw 	?
numero3 dw 	?
numero4 dw 	?
numero5 dw	?
.CODE
main:	mov ax,@data
		mov ds,ax
		
		call lee4		;Mandamos a llamar la funcion de leer 4 numeros 
		call reto		;funcion de salto de linea
		mov numero1,ax
		call lee4
		call reto 
		mov numero2,ax
		call lee4
		call reto 
		mov numero3,ax
		call lee4
		call reto 
		mov numero4,ax
		call lee4
		call reto 
		add ax,numero1
		add ax,numero2
		add ax,numero3
		add ax,numero4
		mov dx,ax
		call des4
		.exit 0
end
