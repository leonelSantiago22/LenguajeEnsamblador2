.model small
.486
include ..\fun\macros.asm
extrn des4:near
extrn reto:near
extrn des2:near
extrn spc:near
.stack
.data
    pre_cad db 2 dup(?)
    nombre_archivo db 20 dup(00h) 
    bufer 	 db 0fffh dup('$');el buffer es un espacio de memoria para poner temporalmente los datos  
    bufer2 db "Hola buenas"
    fid dw ?            ;Identidificador del archivo
    espacio dw ?
    vec db 50 dup('$')
.code 
main:   mov ax,@data
        mov ds,ax 
                
        call leerelnombredelarchivo
        ;call insertar_archivo
        ;call crear_archivo
        ;call imprimir_archivo
        ;call cerrar_archivo
        call editar_archivo
        ;call borrar_archivo
         call cerrar_archivo
        
        .exit 0

;En caso de error para saber si el error es facil
error:  call reto
        mov dx,ax
        mov dx,offset nombre_archivo
        mov ah,09h
        int 21h
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
                        mov espacio,bx  ;conocer cuantos espacios se imprimieron
                        ;Desplegar cadena leída
                        mov dx,offset bufer
                        mov ah,09h
                        int 21h
		
		jmp cic_im
sal_im:
        ret
borrar_archivo:
        mov ah,41h
        mov dx, offset nombre_archivo
        int 21h
        jc error
ret
editar_archivo:
        push ax 
        push bx  
        push di
        push es 
        push dx
        push si
        mov si,0
pedir2: mov ah,01h
        mov bufer[si],al                ;obtenemos donde se encuentra la posicion
                                  ;Incrementamos las posiciones que agregamos
        int 21h
        inc si
        cmp al,1bh                      ;comparamos si es diferente de esc
        ;ja pedir                        ;SEgumimos pidiendo
        jne pedir2
        call reto
        mov ah,3dh                    ;SERVICIO DE APERTURA DE ARCHIVO
        mov dx, offset nombre_archivo  ;SE SETEA EL NOMBRE DEL ARCHIVO
        mov al,2                    ;MODO SOLO ESCRITURA
        int 21h                       ;SE ABRE EL FICHERO PARA TRABAJAR
        mov bx,ax
        mov ah,40h                  ;SERVICIO PARA ESCRIBIR MENSAJE
        mov cx,si               ;SETEO TAMANIO DE MENSAJE
        mov dx,offset bufer   ;PONGO EL MENSAJE QUE SE VA A ESCRIBIR
        int 21h                     ;SE GUARDA EL Mcd ENSAJE
        jc error
        pop si
        pop dx       
        pop es 
        pop di      
        pop bx
        pop ax
ret

insertar_archivo:
        ;mov ah,3dh                    ;SERVICIO DE APERTURA DE ARCHIVO                      ;SE ABRE EL FICHERO PARA TRABAJAR    
        mov si,0
pedir:  mov ah,01h
        mov bufer[si],al                ;obtenemos donde se encuentra la posicion
                                  ;Incrementamos las posiciones que agregamos
        int 21h
        inc si
        cmp al,1bh                      ;comparamos si es diferente de esc
        ;ja pedir                        ;SEgumimos pidiendo
        jne pedir
        call reto
        print "estas seguro que quieres hacer estos cambios? S/N"
        mov ah,01h
        int 21h
        cmp al,6eh
        je cancelar
        call reto
        print "Ingresa el nombre del archivo:"
        call leerelnombredelarchivo
        call crear_archivo
        mov ah,3dh
        mov al,1h  
        mov dx,offset nombre_archivo  ;SE SETEA EL NOMBRE DEL ARCHIVO                  ;MODO SOLO ESCRITURA
        int 21h                       ;SE ABRE EL FICHERO PARA TRABAJAR
        jc error
        mov bx,ax
        mov cx,si               ;SETEO TAMANIO DE MENSAJE
        mov dx,offset bufer   ;PONGO EL MENSAJE QUE SE VA A ESCRIBIR 
        mov ah,40h                  ;SERVICIO PARA ESCRIBIR MENSAJE
        int 21h                     ;SE GUARDA EL Mcd ENSAJE
        cmp cx,ax 
        jne salir_insertar
        call crear_archivo

salir_insertar:
        ret
cancelar:.exit 0
leecad: mov bx,dx ;vamos a usar bx como apuntador
        sub dx,2
        mov [bx-2],cl       ;ponemos donde apunta dx el tamano de la cadena
        mov ah,0Ah                  ;ya esta en dx el offset del arreglo 
        int 21h 
        call reto
        mov al, [bx-1]          ;aqui pone realemente el tamano que leyo
        ret
end