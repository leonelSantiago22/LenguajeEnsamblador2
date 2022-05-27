.model small
.386
extrn des4:near
extrn reto:near
extrn des2:near
extrn spc:near
.stack
.data
    pre_cad db 2 dup(?)
    nombre_archivo db 20 dup(00h) 
    bufer 	 db 0fffh dup(?);el buffer es un espacio de memoria para poner temporalmente los datos  
    fid dw ?            ;Identidificador del archivo
.code 
main:   mov ax,@data
        mov ds,ax 
                
        call leerelnombredelarchivo
        call imprimir_archivo
        call cerrar_archivo
        
        .exit 0

;En caso de error para saber si el error es facil
error:  mov dx,ax
        call des4
        ;.exit 1

leerelnombredelarchivo:
        mov dx,offset nombre_archivo
        mov cl,20
        call leecad         ;funcion que nos permite leer una cadena
        mov bl,al
        mov bh,0
        mov nombre_archivo[bx],24h
        
ret
;Desplegar el contenido del arreglo en hexadecimal
desarr: cld
        mov si,offset pre_cad    ;le agrea 3 posiciones al arrglo
        mov ch,0h
        ;mov cx,20
desarr_cic:  lodsb
        mov dl,al 
        call des2
        call spc 
        loop desarr_cic
        call reto
        ret 
;Funcion que nos permite crear el archivo puede ser con un nombre especifico 
crear_archivo:
        mov ah,3Ch ;Código para crear archivo.
        mov cx,0 ;Archivo normal.
        mov dx,offset nombre_archivo ;Dirección del nombre.
        int 21h ;Crear y abrir, devuelve ident.
        jc error ;Saltar en caso de error.
        mov fid,ax
ret 

;Funcion para cerral el archivo
cerrar_archivo: 
        mov ah,3Eh ;Código para cerrar archivo
        mov bx,fid ;Identificador.
        int 21h ;Cerrar archivo
        jc error ;Saltar en caso de error

ret

imprimir_archivo:
        mov ah,3Dh ;Código para abrir archivo
		mov al,0 ;Modo lectura
		mov dx,offset nombre_archivo ;Dirección del nombre
		int 21h ;Abrir, devuelve ident
		jc error ;En caso de error, saltar
		mov fid,ax ;guardar identificador
		;Leer el archivo
		;fread( &contenido, srtlen( contenido ), 1, fid );
		;dentro de un ciclo
        cic_im:	mov ah,3Fh ;Código para leer archivo
		mov bx,fid ;Identificador
		mov cx,10h ;Tamaño deseado
		mov dx,offset bufer ;Dirección búfer
		int 21h ;Leer archivo
		jc error ;Si hubo error, procesar
		;salir si ya no hay mas
		
		;Colocar símbolo $ al final de cadena leída
		cmp ax,0
		je sal_im
		mov bx,ax;nos dice cuanto leyo
		add bx,offset bufer
		mov byte ptr[bx],'$'
		;Desplegar cadena leída
		mov dx,offset bufer
		mov ah,09h
		int 21h
		
		jmp cic_im
sal_im:
        ret

leecad: mov bx,dx ;vamos a usar bx como apuntador
        sub dx,2
        mov [bx-2],cl       ;ponemos donde apunta dx el tamano de la cadena
        mov ah,0Ah                  ;ya esta en dx el offset del arreglo 
        int 21h 
        call reto
        mov al, [bx-1]          ;aqui pone realemente el tamano que leyo
        ret
end