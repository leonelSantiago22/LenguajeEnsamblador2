.MODEL SMALL
extrn lee4:near
extrn des4:near
extrn spc:near
extrn reto:near
.STACK
.DATA
.CODE
main:	mov ax,@data
		mov ds,ax
		;Codigo para una resta 
		call lee4		;Mandamos a llamar la funcion de leer 4 numeros 
		call reto		;funcion de salto de linea
		mov bx,ax		;respaldamos lo que tenmos en el registro de 16 bits ax en bx
		;call lee4		;leemos la siguiente parte del codigo
		;call reto
		;mov cx,ax		;movemos los siguientes datos a cx 
		call lee4
		sub ax,bx		;Ya tenemos en ax algo y ahora lo sumamos con lo antes respaldad
		;add ax,cx
		mov dx,ax		;Movemos a dx para poder imprimir el registro de ax
		call reto		;Salto de linea
		call des4		;Desplegamos la suma de ambos numeros
		.exit 0

end
