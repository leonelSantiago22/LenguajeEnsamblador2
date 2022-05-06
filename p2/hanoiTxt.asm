.MODEL SMALL
.386
extrn desdec:near
extrn leedec:near
extrn reto:near
extrn des4:near
.STACK
.DATA
    narchivo db "hanoi.txt",0h
    ;cadena 2 dup(?), 0dh, 0ah
    origen db "O",24h
    destino db "D",24h
    auxiliar db "A",24h
    salto db 0dh,0ah
    moverse db "Se movio de : ",24h
    moverse2 db " a ",24h
    fid dw ? ;aqui guradamos el identificador que nos retorna el sistema operativo
.CODE
escribir macro tam,identificador, cadena
        mov ah,40h      ;Código para escribir en archivo.
        mov bx,identificador      ;Identificador.
        mov cx,tam       ;Tamaño de datos.
        mov dx,offset cadena ;Dirección búfer.
        int 21h         ;Escribir.
        jc error       ;Saltar en caso de error.
        mov dx,ax
        ;call des4
        ;call reto 
endm
main:	mov ax,@data
		mov ds,ax
		mov es,ax
         ;crear y abrir el archivo
        ;Crear y abrir
        ;fid=fopen( "texto.txt", "w" );
        mov ah,3Ch      ;Código para crear archivo.
        mov cx,0        ;Archivo normal.
        mov dx,offset narchivo ;Dirección del nombre.
        int 21h         ;Crear y abrir, devuelve ident.
        jc error        ;Saltar en caso de error.
        mov fid,ax      ;guardar identificador en variable.
        ;Escribir en el archivo
        ;fwrite( &contenido, srtlen( contenido ), 1, fid );

		call leedec
		push ax 	;[bp+10]
		mov ax,offset origen
		push ax 	;origne: [bp+8]
		mov ax,offset auxiliar
		push ax 	;Auxiliar: [bp+6]
		mov ax,offset destino
		push ax 	;Destino: [bp+4]
		call hanoi
		add sp,8

        ;cerrar archivo
        mov ah,3Eh      ;Código para cerrar archivo
        mov bx,fid      ;Identificador.
        int 21h         ;Cerrar archivo
        jc error        ;Saltar en caso de error
        jmp salidita
error:  mov dx,ax ;Desplegar código de error
        call des4
        .exit 1         ;Y salir indicando que hubo error
salidita:	.exit 0

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
        Escribir 14 fid moverse
		;moves un disco de 0 a D 
		mov dx,[bp+8]	;origen
        Escribir 1 fid dx
        Escribir 3 fid moverse2
		mov dx,[bp+4]	;destino
		Escribir 1 fid dx
		;call reto
        Escribir 2 fid salto
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